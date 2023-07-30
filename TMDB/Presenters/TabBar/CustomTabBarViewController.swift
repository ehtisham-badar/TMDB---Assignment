//
//  CustomTabBarViewController.swift
//  TMDB
//
//  Created by Ehtisham Badar on 04/03/2022.
//

import UIKit

class CustomTabBarViewController: UIViewController {
    
    @IBOutlet weak var tabBarSeperatorVieww: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var contentView: UIView!
    var watchMovieListViewController: MainNavigationViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.tabbarController = self
        self.navigationController?.navigationBar.isHidden = true
        if(watchMovieListViewController == nil){
            watchMovieListViewController = storyboard?.instantiateViewController(withIdentifier: String(describing:MainNavigationViewController.self)) as? MainNavigationViewController
        }
        self.addChildController(vc: watchMovieListViewController, containerView: contentView)
        // Do any additional setup after loading the view.
    }
}
extension UIViewController{
    func addChildController(vc: UIViewController, containerView: UIView){
        vc.willMove(toParent: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    func removeChildController(vc: UIViewController?){
        if (vc != nil && vc!.parent != nil){
            vc!.willMove(toParent: nil)
            vc!.view.removeFromSuperview()
            vc!.removeFromParent()
            vc!.didMove(toParent: nil)
        }
    }
    func showAlert(){
        let alert = UIAlertController(title: "Alert", message: "NO INTERNET", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
