//
//  ExchangeRateTableViewCell.swift
//  Sample
//
//  Created by Philips on 21/09/19.
//  Copyright © 2019 Prabhat. All rights reserved.
//

import UIKit

class DashBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var fromCurrencySymbol: UILabel!
    @IBOutlet weak var toCurrencySymbol: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(from model: Dashboard) {
        
        if let fromSymbol = model.fromCurrency?.keys.first,
            let toSymbol = model.toCurrency?.keys.first,
            let toCountry = model.toCurrency?.values.first,
            let fromCountry = model.fromCurrency?.values.first{
            fromCurrencyLabel.text = "\(model.fromRates)\(" ")\(fromSymbol)"
            fromCurrencySymbol.text = fromCountry
            rateLabel.text = "\(model.toRates)"
            toCurrencySymbol.text =  toCountry + "  " + toSymbol
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fromCurrencyLabel.text = nil
        rateLabel.text = nil
        fromCurrencySymbol.text = nil
        toCurrencySymbol.text = nil
    }
    
}
