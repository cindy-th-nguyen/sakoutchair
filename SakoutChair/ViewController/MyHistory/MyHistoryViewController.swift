//
//  MyHistoryViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 01/07/2021.
//

import UIKit

class MyHistoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    var userSensorsDataArray: [UserSensorsData]?
    let authManager = FirebaseAuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        self.historyCollectionView.alwaysBounceVertical = true
        self.setUpComponents()
        authManager.getDataHistoryByUser { [weak self] payloadData in
            guard let self = self else { return }
            self.userSensorsDataArray = payloadData
            DispatchQueue.main.async {
                self.historyCollectionView.reloadData()
            }
        }
    }
    
    private func setUpComponents() {
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        self.headerView.backgroundColor = UIColor.CustomColor.customBeige
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userSensorsDataArray = userSensorsDataArray else {
            return 0
        }
        let dataByDate = Dictionary(grouping: userSensorsDataArray, by: { $0.date })
        return dataByDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let userSensorsDataArray = userSensorsDataArray else {
            return UICollectionViewCell()
        }
        var datesArray = Dictionary(grouping: userSensorsDataArray, by: { $0.date }).compactMap { $0.key }
        datesArray.sort { $0 > $1 }
       
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell2ID", for: indexPath) as? MyHistoryCollectionViewCell {
            cell.configureCell(date: "", hadGoodPosition: true)
            let date = datesArray[indexPath.row]
            cell.configureCell(date: date, hadGoodPosition: true)
            cell.layer.cornerRadius = 15
            cell.backgroundColor = UIColor.CustomColor.customBeige
            return cell
        }
        historyCollectionView.reloadData()
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let userSensorsDataArray = userSensorsDataArray else {
            return
        }
        var datesArray = Dictionary(grouping: userSensorsDataArray, by: { $0.date }).compactMap { $0.key }
        datesArray.sort { $0 > $1 }
        var dataByDate: [String: Payload] = [:]
        for data in userSensorsDataArray {
            if datesArray[indexPath.row] == data.date {
                dataByDate[data.hour] = data.payload
            }
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let chartViewController = storyBoard.instantiateViewController(withIdentifier: "chartID") as! ChartViewController
        chartViewController.date = datesArray[indexPath.row]
        chartViewController.userSensorsDataArray = dataByDate
        self.navigationController!.pushViewController(chartViewController, animated: true)
    }
}
