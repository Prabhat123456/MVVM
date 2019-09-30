//
//  BaseCurrencyViewCell.swift
//  Sample
//
//  Created by Philips on 20/09/19.
//  Copyright © 2019 Prabhat. All rights reserved.
//

import UIKit

class CurrencyViewCell: UITableViewCell {
    
    @IBOutlet weak var symbolImage: UIImageView!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var countryNameSymbol: UILabel!
    
    func configureCell(from model: Currency) {
        if let symbol = model.symbol{
            currencySymbolLabel.text = symbol
            countryNameSymbol.text = model.country
            symbolImage?.image = UIImage.init(named: symbol)
        }
        if model.isDisabled{
            currencySymbolLabel.textColor = UIColor.gray.withAlphaComponent(0.6)
            countryNameSymbol.textColor =  UIColor.gray.withAlphaComponent(0.6)
        }else{
            currencySymbolLabel.textColor = UIColor.black
            countryNameSymbol.textColor =  UIColor.black
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currencySymbolLabel.text = nil
        countryNameSymbol.text = nil
        symbolImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
