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
    
    var seatData: [Bool] {
        get {
            return SeatDataManager.sharedInstance.data
        }
    }
    
    var sonarData: [Float] {
        get {
            return SensorDataManager.sharedInstance.data
        }
    }
    var timer = Timer()
    var counterSecondes = 0
    var counterMinutes = 0
    var counterHours = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
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
        
        if !seatData.contains(true) {
            let slide = ZKCarouselSlide(image: UIImage(named: "work-slide"),          title: "Not connected",                                    description: "Connect your app with SakoutChair device to have full access of our features")
            self.mainCarousel.slides = [slide]
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
    
    func startTimer() {
        print("😛 startTimer")
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func timerAction(){
        if seatData.contains(true) {
            counterSecondes += 1
            if counterSecondes % 60 == 0 {
                counterSecondes %= 60
                counterMinutes += 1
                if counterMinutes % 60 == 0 {
                    counterMinutes %= 60
                    counterHours += 1
                }
            }
            var valueHour = "00"
            var valueMin = "00"
            var valueSec = "00"
            if counterHours < 10 {
                valueHour = "0\(counterHours)"
            } else {
                valueHour = "\(counterHours)"
            }
            if counterMinutes < 10 {
                valueMin = "0\(counterMinutes)"
            } else {
                valueMin = "\(counterMinutes)"
            }
            if counterSecondes < 10 {
                valueSec = "0\(counterSecondes)"
            } else {
                valueSec = "\(counterSecondes)"
            }
            
            let timerValue = "\(valueHour):\(valueMin):\(valueSec)"
            setupCarousel(timerValue: timerValue)
            
            if counterMinutes % 60 == 0 && counterHours != 0 {
                let alert = UIAlertController(title: "Take a break!", message: "It's recommended you take a break of 5 minutes every hour.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                    self.counterHours = 0
                    self.counterSecondes = 0
                    self.counterMinutes = 0
                }))
                alert.addAction(UIAlertAction(title: "Later", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupCarousel(timerValue: String) {
        var hasGoodPosition: Bool = false
        guard let bottom = sonarData.first, let top = sonarData.last else { return }
        let val: Float = bottom - top
        hasGoodPosition = val < 9 ? true : false
        let slide1 = ZKCarouselSlide(image: UIImage(named: "seated-slide"),
                                     title: seatData.isEmpty && sonarData.isEmpty ? "No data available" : "Data available",
                                     description: seatData.isEmpty && sonarData.isEmpty ? "Reconnect ..." : "Go to live chart")
        let slide2 = ZKCarouselSlide(image: UIImage(named: "work-slide"),
                                     title: hasGoodPosition ? "Good position" : "Bad position",
                                     description: hasGoodPosition ? "Your back position is good, keep going!": "Fix your position")
        let slide3 = ZKCarouselSlide(image: UIImage(named: "break-slide"),
                                     title: timerValue,
                                     description: "Stay focus on your work")
        
        self.mainCarousel.slides = [slide1, slide2, slide3]
        self.mainCarousel.stop()
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

