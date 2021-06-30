//
//  PopUpActionViewController.swift
//  SakoutChair
//
//  Created by NGUYEN, Cindy on 28/06/2021.
//

import UIKit

protocol PopUpDelegate {
    func handleAction(action: Bool)
}
class PopUpActionViewController: UIViewController {
    static let identifier = "PopUpActionViewController"
    var delegate: PopUpDelegate?

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var startSetUpButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpComponents()
    }
    
    func setUpComponents() {
        popUpView.layer.cornerRadius = 25
        popUpView.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.50)
    }
    
    @IBAction func startSetUpAction(_ sender: Any) {
        self.delegate?.handleAction(action: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelSetUpAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    static func showPopup(parentVC: UIViewController){
        if let popupViewController = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: "PopUpActionViewController") as? PopUpActionViewController {
            popupViewController.modalPresentationStyle = .custom
            popupViewController.modalTransitionStyle = .crossDissolve
            popupViewController.delegate = parentVC as? PopUpDelegate
            parentVC.present(popupViewController, animated: true)
        }
    }
}
