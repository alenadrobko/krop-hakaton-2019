//
//  MainViewController.swift
//  KropHackathon
//
//  Created by Tetiana Nieizviestna on 02.12.2019.
//  Copyright © 2019 onix. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    var viewModel: MainViewModelType!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet weak var searchResult: SearchResultView!
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        searchResult.didSelected = { [weak self] row in
            self?.viewModel.openDetails()
        }
        
        searchResult.didDrag = {
            self.searchBar.endEditing(true)
        }
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    private func configure() {
    tableView.register([ServiceCell.identifier])
        tableView.setDataSource(self, delegate: self)
        tableView.reloadData()
        
        searchBar.delegate = self
        //searchBar.isUserInteractionEnabled = true //UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).isEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: "dismiss")
//
//
//        searchResult.view.addGestureRecognizer(tap)
        }
    


    @objc func dismiss() {
        searchBar.endEditing(true)
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = true

    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openList(row: indexPath.row)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.serviceModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .init(signOf: tableView.bounds.size.width, magnitudeOf: tableView.bounds.size.width / 2.6)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: ServiceCell = tableView.dequeCell(for: indexPath) else { return UITableViewCell() }
        cell.configure(viewModel.serviceModels[indexPath.row])
        
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
    }
    
    func cancel() {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
         configureSearchMode(true)
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       searchResult.update(viewModel.searchModel)
    }
    
    func configureSearchMode(_ state: Bool) {
        searchBar.showsCancelButton = true
        searchResult.isHidden = !state
        tableView.isHidden = state
        titleLabel.isHidden = state
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        configureSearchMode(false)
        searchBar.endEditing(true)
        searchBar.text = ""
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResult.update(viewModel.searchModel)
        searchBar.endEditing(true)
    }
    
}
