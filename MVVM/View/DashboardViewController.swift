//
//  DashboardViewController.swift
//  Revolut
//
//  
//  Copyright © 2019 Prabhat. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    let viewModel:DashBoardVMProtocol = DashBoardVM(apiClient: APIClient.shared)
    @IBOutlet weak var tableView: UITableView!
    private var alert:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureView()
        viewModel.fetchCurrencyList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.cancelDispatchTimer()
    }
    
    private func configureViewModel() {
        viewModel.reloadTableView = {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                for row in 0 ..< weakSelf.viewModel.numberOfCells() {
                    if let cell = weakSelf.tableView.cellForRow(at: [row, 0]) as? DashBoardTableViewCell {
                        cell.configureCell(from: weakSelf.viewModel.cellModel(at: [row, 0]))
                    } else {
                        weakSelf.tableView.reloadData()
                    }
                }
            }
        }
        viewModel.showAlertMessage = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.alert = UIAlertController(title: "Message", message:value, preferredStyle: .alert)
            weakSelf.alert?.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in })
            
        }
    }
    
    private func configureView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let alert = alert{
            present(alert, animated: true, completion:nil)
        }
    }
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashBoardTableViewCell.identifier, for: indexPath) as? DashBoardTableViewCell
        let cellViewModel = viewModel.cellModel(at: indexPath)
        cell?.configureCell(from: cellViewModel)
        return cell!
    }
    
}

