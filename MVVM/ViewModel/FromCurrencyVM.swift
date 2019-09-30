//
//  FromCurrencyVM.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
import UIKit

internal protocol FromCurrencySelectedProtocol: AnyObject {
    func didSelected(currency : Currency)
}

 @objc internal protocol UIOperationProtocol: AnyObject{
    var moveToNextView: (() -> Void)? {get set}
    
    func getTheNextViewController() -> UIViewController?
}

@objc internal protocol TableViewProtocol: AnyObject{
    var reloadTableView: (() -> Void)? {get set}
    func cellModel(at indexPath: IndexPath) -> Currency
    func numberOfCells() -> Int
    @objc optional func selectedCell(at indexPath: IndexPath)
}

internal protocol FetchingOperationProtocol: AnyObject{
    var showAlertMessage: ((String) -> Void)? {get set}
    var apiClient: ApiClientProtocol? {get set}
    func fetchCurrencyList()
}

internal protocol FromCurrencyVMModel:UIOperationProtocol,TableViewProtocol,FetchingOperationProtocol{
    
}

class FromCurrencyVM: NSObject, FromCurrencyVMModel{
    var apiClient: ApiClientProtocol?
    var reloadTableView: (() -> Void)?
    var showAlertMessage: ((String) -> Void)?
    var moveToNextView: (() -> Void)?
    var fromCurrencySelectedProtocol: FromCurrencySelectedProtocol?
    var disabledItem = [String]()
    var currency = [Currency]() {
        didSet {
            self.reloadTableView?()
        }
    }
    let dbOperations = DBOperation()
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchCurrencyList() {
        apiClient?.fetchCurrencyListWithCountryName(completion: { [weak self] (success, currencyListWithCountry, error) in
            guard let weakSelf = self else { return }
            if success {
                weakSelf.processFetched(currency: currencyListWithCountry)
            } else {
                weakSelf.showAlertMessage?("Unable to Load Data")
            }
        })
    }
    
    func getTheNextViewController() -> UIViewController?{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "toCurrency") as? ToCurrencyListViewController
        fromCurrencySelectedProtocol = nextViewController?.viewModel
        return nextViewController
    }
    
    func processFetched(currency: [Currency]) {
        dbOperations.fetchData(forTheEntity: Constants.DBCurrencyMapperTable) { [weak self] (records) in
            var forCurrency = [String]()
            if let recordsItem = records as? [FromAndToCurrencyMapper]{
                for item in recordsItem{
                    if let country = (item.fromCurrency as? Currency)?.country{
                      forCurrency.append(country)
                    }
                }
            }
            for country in forCurrency {
                if (forCurrency.filter{$0 == country}.count == currency.count - 1){
                    self?.disabledItem.append(country)
                }
            }
             self?.currency = currency
        }
    }
}

extension FromCurrencyVM {
    @objc func numberOfCells() -> Int {
        return currency.count
    }
    
    @objc func cellModel(at indexPath: IndexPath) -> Currency {
        let element = currency[indexPath.row]
        if let country = element.country{
            element.isDisabled = false
            if disabledItem.contains(country) {
                element.isDisabled = true
            }
        }
        return element
    }
    
    @objc func selectedCell(at indexPath: IndexPath) {
        fromCurrencySelectedProtocol?.didSelected(currency: currency[indexPath.row])
        moveToNextView?()
    }
}
