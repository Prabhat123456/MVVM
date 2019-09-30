//
//  ToCurrencyListViewController.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import UIKit

class ToCurrencyListViewController: UIViewController {
    let viewModel = ToCurrencyVM(apiClient: APIClient.shared)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
        viewModel.fetchCurrencyList()
        viewModel.getPreviousConvertedCurrency()
    }
    
    private func configureViewModel() {
        let nextViewController = viewModel.getTheNextViewController()
        viewModel.reloadTableView = {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.tableView.reloadData()
            }
        }
        viewModel.moveToNextView = { [weak self]  in
            guard let weakSelf = self else { return }
            if let controller = nextViewController{
                weakSelf.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    private func configureView() {
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

extension ToCurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToCurrencyViewCell", for: indexPath) as? CurrencyViewCell
        let cellViewModel = viewModel.cellModel(at: indexPath)
        cell?.isUserInteractionEnabled = true
        cell?.backgroundColor = UIColor.white
        if cellViewModel.isDisabled {
            cell?.isUserInteractionEnabled = false
            cell?.backgroundColor = UIColor.gray.withAlphaComponent(0.05)
        }
        cell?.configureCell(from: cellViewModel)
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCell(at: indexPath)
    }
}
