//
//  LogOutViewController.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 2/1/25.
//

import UIKit

class LogOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutButtonTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LogInControllerViewController {

                    
                // Obtenim el actual SceneDelegate
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    // Settejem el nou root view controller
                    let navigationController = UINavigationController(rootViewController: loginVC)
                    sceneDelegate.window?.rootViewController = navigationController
                }
            }
        }
    
}
