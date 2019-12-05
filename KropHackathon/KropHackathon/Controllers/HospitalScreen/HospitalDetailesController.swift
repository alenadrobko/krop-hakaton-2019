//
//  HospitalDetailesController.swift
//  KropHackathon
//
//  Created by Альона Дробко on 04.12.2019.
//  Copyright © 2019 onix. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

final class HospitalDetailesController: UIViewController {
    var viewModel: HospitalDetailesModelType!
    
    @IBOutlet private weak var lookOnMapButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var map: MapView!
    @IBOutlet private weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func pushToMap(_ sender: Any) {
        UrlOpenHelper.openDirections(to: viewModel.point)
        
    }
    
    private func configure() {
        
        map.customSetup(with: viewModel.point)
        map.addMarker(coordinate: viewModel.point)
        map.moveToLocation(location: CLLocation.init(latitude: 48.510942, longitude: 32.270891))
        configureNavigationBar()
        lookOnMapButton.layer.cornerRadius = 16.0
        lookOnMapButton.layer.borderWidth = 0.5
        lookOnMapButton.layer.borderColor = Style.Color.borderColor.cgColor
        lookOnMapButton.layer.applySketchShadow(color: Style.Color.shadowColor, alpha: 0.14, xxx: 0, yyy: 4, blur: 12, spread: 0)
        
        tableView.register([HospitalDetailsTableViewCell.className, TitleTableViewCell.className])
        tableView.setDataSource(self)
        
        tableView.reloadData()
    }
    
    private func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isTranslucent = true
                
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        viewModel.goBack()
    }
    
    @objc
    func backBtnClicked() {
        viewModel.goBack()
    }
}

extension HospitalDetailesController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hospitalInfoDetailModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell: TitleTableViewCell = tableView.dequeCell(for: indexPath) else {
            print("can't find cell")
            return UITableViewCell()
            }
            cell.configure(title: viewModel.title)
            return cell
            
        } else {
            guard let cell: HospitalDetailsTableViewCell = tableView.dequeCell(for: indexPath) else {
                print("can't find cell")
                return UITableViewCell()
            }
            cell.configure(model: viewModel.hospitalInfoDetailModels[indexPath.row - 1])
            return cell
        }
    }
    
    
}
