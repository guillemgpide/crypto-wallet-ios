//
//  SignUpControllerViewController.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 1/24/25.
//

import UIKit
import FirebaseAuth
import CoreStore

class SignUpControllerViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var mail: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var ErrorSignUp: UILabel!
    private var loginSuccess = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "signUp" {
                if loginSuccess != true {                //ErrorSignUp.text = "No se puede navegar. Verifica los errores."
                    return false
                }
            }
        }
        return true
    }
    func saveUserToCoreData(username: String, mail: String, password: String) -> Users? {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
           let context = appDelegate.persistentContainer.viewContext

           let newUser = Users(context: context)
           newUser.username = username
           newUser.mail = mail
           newUser.password = password
           newUser.balance = 0.0  // Balance inicial

           do {
               try context.save()
               print("Usuario guardado en CoreData correctamente.")
               return newUser
           } catch {
               print("Error al guardar usuario en CoreData: \(error.localizedDescription)")
               return nil
           }
       }
       
       @IBAction func signUpButtonTouched(_ sender: Any) {
           guard let username = username.text,
                 let mail = mail.text,
                 let password = password.text,
                 let confirmPassword = confirmPassword.text,
                 !username.isEmpty,
                 !mail.isEmpty,
                 !password.isEmpty,
                 !confirmPassword.isEmpty else {
               ErrorSignUp.text = "Por favor, completa todos los campos."
               return
           }

           if password != confirmPassword {
               ErrorSignUp.text = "Las contraseñas no coinciden."
               return
           }

           Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
               if let error = error {
                   self.ErrorSignUp.text = "Error al crear cuenta: \(error.localizedDescription)"
               } else {
                   print("Usuario creado en Firebase: \(authResult?.user.uid ?? "")")

                   // Guardar usuario en CoreData
                   if let user = self.saveUserToCoreData(username: username, mail: mail, password: password){
                       // Guardar userID en UserDefaults
                       UserDefaults.standard.set(user.objectID.uriRepresentation().absoluteString, forKey: "currentUserID")
                       // Redirigir a la siguiente pantalla
                       self.performSegue(withIdentifier: "signUp", sender: self)
                   } else {
                       print("No se pudo guardar el usuario en CoreData")
                   }
               }
           }
       }
   }
