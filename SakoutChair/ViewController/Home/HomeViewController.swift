//
//  HomeViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 01/05/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ZKCarousel

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PopUpDelegate {
    let authManager = FirebaseAuthManager()
    var userHasConfigure: Bool = false
    var userSensorsDataArray: [UserSensorsData]?
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var mainCarousel: ZKCarousel!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var liveChartButton: UIButton!
    
    var seatData : [Bool] {
        get {
            return SeatDataManager.sharedInstance.data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCarousel()
        authManager.getCurrentUser { user in
            guard let user = user else { return }
            if !user.hasConfigure {
                PopUpActionViewController.showPopup(parentVC: self)
            }
        }
        MqttRequester.prepareRequester()
        guard let mqttClient = MqttRequester.mqttClient else {
            return
        }
        mqttClient.subscribe("sakoutcher/test/payload", qos: 0)
        authManager.getDataHistoryByUser { [weak self] payloadData in
            guard let self = self else { return }
            self.userSensorsDataArray = payloadData
            DispatchQueue.main.async {
                self.historyCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpComponents() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        self.historyCollectionView.alwaysBounceHorizontal = true
        self.historyCollectionView.backgroundColor = UIColor.CustomColor.customBeige
        view.backgroundColor = UIColor.CustomColor.customBeige
        definesPresentationContext = true
        
        mainCardView.clipsToBounds = true
        mainCardView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        mainCardView.layer.cornerRadius = 30
    }
    
    private func setupCarousel() {
        //TO DO: 
        //        guard let userPayload = UserPayload.payload else {
        //            return
        //        }
        authManager.getCurrentUser { user in
            guard let user = user else { return }
            if !user.hasConfigure {
                let slide = ZKCarouselSlide(image: UIImage(named: "work-slide"),
                                            title: "Not connected",
                                            description: "Connect your app with SakoutChair device to have full access of our features")
                self.mainCarousel.slides = [slide]
            } else {
                let slide = ZKCarouselSlide(image: UIImage(named: "work-slide"),
                                            title: "Good position",
                                            description: "Your back position is good, keep going!")
                let slide1 = ZKCarouselSlide(image: UIImage(named: "seated-slide"),
                                             title: "Seat : ? - Back : ?",
                                             description: "No data available")
                let slide2 = ZKCarouselSlide(image: UIImage(named: "break-slide"),
                                             title: "00:00",
                                             description: "Stay focus on your work")
                
                self.mainCarousel.slides = [slide, slide1, slide2]
                self.mainCarousel.stop()
            }
        }
    }
    
    @IBAction func showHistoryDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let historyViewController = storyBoard.instantiateViewController(withIdentifier: "myHistoryID") as! MyHistoryViewController
        self.navigationController!.pushViewController(historyViewController, animated: true)
    }
    
    @IBAction func myAccountButtonDidTap(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let authViewController = storyBoard.instantiateViewController(withIdentifier: "myAccount") as! MyAccountViewController
        self.navigationController!.pushViewController(authViewController, animated: true)
    }
    
    func handleAction(action: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if action {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let setUpViewController = storyBoard.instantiateViewController(withIdentifier: "SetUpChairID") as! SetUpChairViewController
                self.navigationController?.present(setUpViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onLiveChartButton(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let liveChartViewController = storyBoard.instantiateViewController(withIdentifier: "liveChart") as! LiveChartViewController
        self.navigationController!.pushViewController(liveChartViewController, animated: true)
    }
}

extension HomeViewController {
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
       
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCellID", for: indexPath) as? HistoryCollectionViewCell {
            cell.configureCell(date: "", hadGoodPosition: true)
            let date = datesArray[indexPath.row]
            cell.configureCell(date: date, hadGoodPosition: true)
            cell.layer.cornerRadius = 20
            cell.backgroundColor = .white
            return cell
        }
        historyCollectionView.reloadData()
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}

