//
//  AccountViewController.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 2/1/25.
//

import UIKit
import CoreData
class AccountViewController: UIViewController {

    @IBOutlet weak var usernameInfo: UILabel!
    @IBOutlet weak var mailInfo: UILabel!
    @IBOutlet weak var actualFieldChangePassword: UITextField!
    @IBOutlet weak var textfieldChangePassword: UITextField!
    
    var currentUser: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        // Do any additional setup after loading the view.
    }
    private func loadUserData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")
        do {
            let users = try managedContext.fetch(fetchRequest)
            if let user = users.first {
                currentUser = user
                usernameInfo.text = user.value(forKey: "username") as? String
                mailInfo.text = user.value(forKey: "mail") as? String
                
            }
        }
        catch let error as NSError {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
    }
    
    @IBAction func confirmButtonTouched(_ sender: Any) {
        guard let actualPassword = actualFieldChangePassword.text, !actualPassword.isEmpty else {
            showAlert(message: "Please enter you current password")
            return
        }
        guard let newPassword = textfieldChangePassword.text, !newPassword.isEmpty else {
            showAlert(message: "Please enter a new password")
            return
        }
        guard let user = currentUser,
              let storedPassword = user.value(forKey: "password") as? String else {
            showAlert(message: "User data not found")
            return
        }
        if storedPassword != actualPassword {
            showAlert(message: "Incorrect current password")
            return
        }
        user.setValue(newPassword, forKey: "password")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
            /**
             TODO CHANGE PASSWORD IN FIREBASE
             */
        do {
            try managedContext.save()
            showAlert(message: "Password updated successfully")
            actualFieldChangePassword.text = "" //Netejem els camps
            textfieldChangePassword.text = ""
            
        } catch let error as NSError {
            showAlert(message: "Error updating password: \(error.localizedDescription)")

        }
    }
    
    private func showAlert(message: String) {
         let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         present(alert, animated: true)
     }
    
}
