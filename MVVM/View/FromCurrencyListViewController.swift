//
//  FromCurrencyListViewController.swift
//  Revolut
//
//
//  Copyright © 2019 Prabhat. All rights reserved.
//


import UIKit

class FromCurrencyListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FromCurrencyVMModel = FromCurrencyVM(apiClient: APIClient.shared)
    private var alert:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
        viewModel.fetchCurrencyList()
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
            if let  controller = nextViewController{
                weakSelf.present(controller, animated: true, completion: nil)
            }
        }
        viewModel.showAlertMessage = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.alert = UIAlertController(title: "Message", message:value, preferredStyle: .alert)
            weakSelf.alert?.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in })
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let alert = alert{
            present(alert, animated: true, completion:nil)
        }
    }
    
    private func configureView() {
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
}

extension FromCurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyViewCell.identifier, for: indexPath) as? CurrencyViewCell
        let cellViewModel = viewModel.cellModel(at: indexPath)
        cell?.configureCell(from: cellViewModel)
         return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCell?(at: indexPath)
    }
}
