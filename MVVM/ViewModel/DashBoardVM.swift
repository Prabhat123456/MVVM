//
//  DashBoardVM.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
import SystemConfiguration

@objc internal protocol DashBoardTableViewProtocol: AnyObject{
    var reloadTableView: (() -> Void)? {get set}
    func cellModel(at indexPath: IndexPath) -> Dashboard
    func numberOfCells() -> Int
}

internal protocol DashBoardDisPatchProtocol{
    func cancelDispatchTimer()
}

protocol DashBoardVMProtocol: DashBoardTableViewProtocol,FetchingOperationProtocol,DashBoardDisPatchProtocol {
}

class DashBoardVM: DashBoardVMProtocol {
    var apiClient: ApiClientProtocol?
    var dispatchTimer = DispatchSource.makeTimerSource()
    var reloadTableView: (() -> Void)?
    var fromAndToCurrencySymbol = [String]()
    var showAlertMessage: ((String) -> Void)?
    var dbOperation = DBOperation()
    var fromAndToCurrencyMapper = [FromAndToCurrencyMapper]()
    var dashBoard = [Dashboard]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchCurrencyList() {
        let reachablity = Reachability()
        if reachablity.isConnectedToNetwork() {
            dbOperation.fetchData(forTheEntity: Constants.DBCurrencyMapperTable) { [weak self](records) in
                self?.fromAndToCurrencyMapper = records as? [FromAndToCurrencyMapper] ?? []
            }
            getCurrencyMapperDataFromDB { [weak self] (currencyConversionMapper) in
                guard let weakSelf = self else { return }
                if let currencyConversionMapper = currencyConversionMapper as? [FromAndToCurrencyMapper]{
                    weakSelf.dispatchTimer.schedule(deadline: .now(), repeating: .seconds(1), leeway: .never)
                    weakSelf.dispatchTimer.setEventHandler { [weak self]  in
                        guard let weakSelf = self else { return }
                        weakSelf.fromAndToCurrencySymbol.removeAll()
                        for item in currencyConversionMapper where item.fromAndToCurrencySymbol != nil{
                            weakSelf.fromAndToCurrencySymbol.append(item.fromAndToCurrencySymbol!)
                        }
                        if reachablity.isConnectedToNetwork(){
                            weakSelf.apiClient?.fetchExchangeRates(forCountries: weakSelf.fromAndToCurrencySymbol, completion: { [weak self] (success, result, error) in
                                guard let weakSelf = self else { return }
                                if success {
                                    weakSelf.processFetched(currency: result)
                                } else {
                                }
                            })
                        }else{
                            DispatchQueue.main.async {
                                weakSelf.cancelDispatchTimer()
                                weakSelf.showAlertMessage?("Internet Not Available")
                            }
                        }
                       
                    }
                    weakSelf.dispatchTimer.resume()
                }
            }
        }else{
            showAlertMessage?("Internet Not Available")
        }
        
    }

    func cancelDispatchTimer(){
        dispatchTimer.cancel()
    }
    
    private func getCurrencyMapperDataFromDB(completion: @escaping (([Any]?)->())){
        dbOperation.fetchData(forTheEntity:Constants.DBCurrencyMapperTable) { (data) in
            completion(data)
        }
    }
    
    private func processFetched(currency: [ExchangeRate]) {
        var localDashBoard = [Dashboard]()
        for item in currency{
            getFromToKeySymbol(exchangeRateModel: item) { [weak self] (exchangeRate) in
                guard let weakSelf = self else { return }
                
                if let fromCurrency = exchangeRate?.fromCurrency,
                   let toCurrency = exchangeRate?.toCurrency,
                   let fromCountry = fromCurrency.country,
                   let fromSymbol = fromCurrency.symbol,
                   let toSymbol = toCurrency.symbol,
                   let toCountry = toCurrency.country,
                    let rate = item.rates{
                    let fromCurrency: Dictionary<String, String> = [fromSymbol:fromCountry]
                    let toCurrency: Dictionary<String, String> = [toSymbol:toCountry]
                    let currencyConverterObject = Dashboard(fromCurrency: fromCurrency, toCurrency: toCurrency)
                    currencyConverterObject.toRates = rate
                    localDashBoard.append(currencyConverterObject)
                    if localDashBoard.count == currency.count {
                        weakSelf.dashBoard = localDashBoard
                    }
                }
                
            }
        }
    }
    
    private func getFromToKeySymbol(exchangeRateModel: ExchangeRate,completion :((FromAndToCurrencyMapper?) -> ())?){
        var currencyMapper: FromAndToCurrencyMapper?
        currencyMapper = fromAndToCurrencyMapper.first{$0.fromAndToCurrencySymbol == exchangeRateModel.fromAndToCurrencySymbol}
        completion?(currencyMapper)
    }
    
}


extension DashBoardVM {
    @objc func numberOfCells() -> Int {
        return dashBoard.count
    }
    
    @objc func cellModel(at indexPath: IndexPath) -> Dashboard {
        return dashBoard[indexPath.row]
    }
}


public class Reachability {
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
