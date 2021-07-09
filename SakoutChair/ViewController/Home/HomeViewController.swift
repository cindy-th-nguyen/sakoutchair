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
    let names: [String] = ["Test", "Test2", "Test3", "Test4", "Test5"]
    var userHasConfigure: Bool = false
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var mainCarousel: ZKCarousel!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainCard()
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
        
        self.navigationController?.isNavigationBarHidden = false
        self.historyCollectionView.delegate = self
        self.historyCollectionView.dataSource = self
        self.historyCollectionView.alwaysBounceHorizontal = true
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpComponents()
    }
    
    func setUpComponents() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setUpMainCard() {
        mainCardView.clipsToBounds = true
        mainCardView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        mainCardView.layer.cornerRadius = 30
    }
    
    private func setupCarousel() {
        //TO DO: 
        guard let userPayload = UserPayload.payload else {
            return
        }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if action {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let setUpViewController = storyBoard.instantiateViewController(withIdentifier: "SetUpChairID") as! SetUpChairViewController
                self.navigationController?.present(setUpViewController, animated: true, completion: nil)
            }
        }
    }
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCellID", for: indexPath) as? HistoryCollectionViewCell {
            let name = names[indexPath.row]
            cell.configureCell(name: name)
            cell.layer.cornerRadius = 20
            cell.backgroundColor = UIColor.CustomColor.customBeige
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
    
    // item spacing = vertical spacing in horizontal flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // line spacing = horizontal spacing in horizontal flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}

