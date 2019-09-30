//
//  APIClient.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation

protocol ApiClientProtocol {
    func fetchExchangeRates(forCountries countries:[String],
                            completion: @escaping ( _ success: Bool, _ rates: [ExchangeRate], _ error: Error? ) -> Void)
    func fetchCurrencyListWithCountryName(completion: @escaping ( _ success: Bool, _ rates: [Currency], _ error: Error? ) -> Void)
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

class APIClient: ApiClientProtocol {
    static let shared = APIClient(session: URLSession.shared)
    private var fetchCurrencyRatesDataTask: URLSessionDataTaskProtocol?
    private var currencyList:[Currency] = []
    private var exchangeRateList:[ExchangeRate] = []
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
        
    }
    
    func fetchExchangeRates(forCountries countries: [String], completion: @escaping (Bool, [ExchangeRate], Error?) -> Void) {
        fetchCurrencyRatesDataTask?.cancel()
        if let url = URLBuilder.getURL(forCountries: countries){
            let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
                guard let weakSelf = self else { return }
                if
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let responseData = data {
                    do {
                        if let exchangeRateListResponse = try JSONSerialization.jsonObject(with:
                            responseData, options: []) as? [String:Double]{
                            weakSelf.exchangeRateList.removeAll()
                            for fromAndToCurrencySymbol in exchangeRateListResponse.keys.sorted(){
                                if let rate = exchangeRateListResponse[fromAndToCurrencySymbol]{
                                    let exchangeRate = ExchangeRate(fromAndToCurrencySymbol: fromAndToCurrencySymbol, rates: rate)
                                    weakSelf.exchangeRateList.append(exchangeRate)
                                }
                            }
                        }
                        completion( true,weakSelf.exchangeRateList, nil )
                    } catch {
                        completion( false, [], error)
                    }
                    
                } else {
                    completion( false, [], nil)
                }
                weakSelf.fetchCurrencyRatesDataTask = nil
                
            }
            dataTask.resume()
            fetchCurrencyRatesDataTask = dataTask
        }
    }
    
    
    func fetchCurrencyListWithCountryName(completion: @escaping (Bool, [Currency], Error?) -> Void) {
        if APIClient.shared.currencyList.count > 0{
            completion( true,APIClient.shared.currencyList, nil )
            return
        } else{
            if let value = readJSONFromFile(fileName: Constants.JsonFileName, completion:completion) as? [String:String]{
                var list: [Currency] = []
                for symbol in value.keys.sorted() where value[symbol] != nil{
                    let currencyList = Currency(symbol: symbol, country: value[symbol]!, flagImage: symbol)
                    list.append(currencyList)
                }
                APIClient.shared.currencyList = list
                completion( true,list, nil)
            }else{
                completion( false, [], nil)
            }
        }
    }
    
    private func readJSONFromFile(fileName: String,completion: @escaping ( _ success: Bool, _ rates: [Currency], _ error: Error? ) -> Void) -> Any?
    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: Constants.JsonFileType) {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                completion( false, [], error)
            }
        }
        return json
    }
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
