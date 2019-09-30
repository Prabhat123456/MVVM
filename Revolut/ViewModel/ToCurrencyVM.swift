//
//  ToCurrencyVM.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import Foundation
import UIKit

class ToCurrencyVM: FromCurrencyVM,FromCurrencySelectedProtocol {
    var selectedCurrency: Currency?
    var fromAndToCurrencyMapper: [FromAndToCurrencyMapper]?
    var dbOperation = DBOperation()
    
    func didSelected(currency: Currency) {
        selectedCurrency = currency
    }
    
    func getPreviousConvertedCurrency(){
        dbOperation.fetchData(forTheEntity: Constants.DBCurrencyMapperTable) { [weak self] (records) in
            self?.fromAndToCurrencyMapper = (records as? [FromAndToCurrencyMapper])?.filter({($0.fromCurrency)?.country == self?.selectedCurrency?.country})
        }
    }
    
    override func getTheNextViewController() -> UIViewController? {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DashboardController") as? DashboardViewController
        return nextViewController
    }
}

extension ToCurrencyVM {
    @objc override func cellModel(at indexPath: IndexPath) -> Currency {
        let model = currency[indexPath.row]
        let value = fromAndToCurrencyMapper?.first{ ($0.toCurrency)?.country == model.country}
        model.isDisabled = false
        if(model.country == selectedCurrency?.country ||  value != nil){
            model.isDisabled = true
        }
        return model
    }
    
    @objc override func selectedCell(at indexPath: IndexPath) {
        let value = currency[indexPath.row]
        if let fromCurrencySymbol = selectedCurrency?.symbol , let toCurrencySymbol = value.symbol{
            saveMappingInDB(withKey: fromCurrencySymbol+toCurrencySymbol, andToCurrency: value)
            moveToNextView?()
        }
    }
    
    private func saveMappingInDB(withKey fromAndToCurrencySymbol: String , andToCurrency toCurrency: Currency) {
        if let entity = dbOperation.getNewEntity(forTable: Constants.DBCurrencyMapperTable){
            let context = dbOperation.persistentContainer.viewContext
            entity.setValue(selectedCurrency, forKey: "fromCurrency")
            entity.setValue(toCurrency, forKey: "toCurrency")
            entity.setValue(fromAndToCurrencySymbol, forKey: "fromAndToCurrencySymbol")
            do {
                try context.save()
            } catch {
            }
        }
    }
}
