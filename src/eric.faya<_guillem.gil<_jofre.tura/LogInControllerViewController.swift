//
//  LogInControllerViewController.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 1/24/25.
//

import UIKit
import FirebaseAuth
import CoreData


class LogInControllerViewController: UIViewController {

    @IBOutlet weak var titleSignin: UILabel!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var ErrorLogin: UILabel!
    private var loginSuccess = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
           if let identifier = identifier, identifier == "logIn" {
               if !loginSuccess {
                   // Block the segue if the login was not successful
                   //ErrorLogin.text = "No se puede navegar. Verifica los errores."
                   return false
               }
           }
           return true
       }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logIn" {
            guard segue.destination is HomeController else {
                // Si el cast falla, imprime un error o maneja el problema de alguna manera
                print("Error: el destino no es un HomeController")
                return
            }
        }
    }*/
    func fetchUserFromCoreData(mail: String) -> Users? {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "mail == %@", mail)

            do {
                let users = try context.fetch(fetchRequest)
                return users.first
            } catch {
                print("Error al buscar usuario en CoreData: \(error.localizedDescription)")
                return nil
            }
        }
        
        @IBAction func loginButtonTouched(_ sender: Any) {
            guard let mail = username.text,
                  let password = password.text,
                  !mail.isEmpty,
                  !password.isEmpty else {
                ErrorLogin.text = "Por favor, completa ambos campos."
                return
            }

            Auth.auth().signIn(withEmail: mail, password: password) { [weak self] authResult, error in
                guard let self = self else { return }

                if let error = error {
                    self.ErrorLogin.text = "Error al iniciar sesión: \(error.localizedDescription)"
                } else {
                    print("Usuario logueado en Firebase: \(authResult?.user.uid ?? "")")

                    // Recuperar usuario desde CoreData
                    if let user = self.fetchUserFromCoreData(mail: mail) {
                        print("Usuario encontrado en CoreData: \(user.username ?? "Sin nombre")")
                        
                        // Guardar userID en UserDefaults
                        UserDefaults.standard.set(user.objectID.uriRepresentation().absoluteString, forKey: "currentUserID")
                    } else {
                        print("No se encontró el usuario en CoreData")
                    }

                    self.performSegue(withIdentifier: "logIn", sender: self)
                }
            }
        }
    }
