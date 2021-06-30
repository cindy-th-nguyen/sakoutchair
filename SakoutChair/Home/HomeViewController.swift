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

class HomeViewController: UIViewController {
    let authManager = FirebaseAuthManager()
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var mainCarousel: ZKCarousel!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
        setUpMainCard()
        setupCarousel()
        authManager.getCurrentUser { user in
            guard let user = user else { return }
            if !user.hasConfigure {
                PopUpActionViewController.showPopup(parentVC: self)
            }
        }
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
        let slide = ZKCarouselSlide(image: UIImage(named: "work-slide"),
                                    title: "Not connected",
                                    description: "Connected your app with SakoutChair device to have full access to our features")
        let slide1 = ZKCarouselSlide(image: UIImage(named: "seated-slide"),
                                     title: "Seat : ? - Back : ?",
                                     description: "No data available")
        let slide2 = ZKCarouselSlide(image: UIImage(named: "break-slide"),
                                     title: "00:00",
                                     description: "Stay focus on your work")
        
        self.mainCarousel.slides = [slide, slide1, slide2]
        self.mainCarousel.stop()
    }
    
    @IBAction func logOutButtonDidTap(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let authViewController = storyBoard.instantiateViewController(withIdentifier: "auth") as! AuthViewController
            self.navigationController!.pushViewController(authViewController, animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
