//
//  OperateViewController.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 1/27/25.
//

import UIKit
import LocalAuthentication

class OperateViewController: UIViewController {

    @IBOutlet weak var cryptoName: UILabel!
    @IBOutlet weak var biometricResultLabel: UILabel!
    
    var crypto: Crypto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let crypto = crypto {
            cryptoName.text = crypto.name
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonBuyTouched(_ sender: Any) {
        biometric()
    }
    
    @IBAction func buttonSellTouched(_ sender: Any) {
    }
    
    private func biometric() {
         let contexto = LAContext()
         var error: NSError?
        print("Biometría soportada: \(contexto.biometryType == .faceID ? "Face ID" : "Touch ID")")

         if contexto.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
             let descripción = "Autenticación requerida para acceder a la aplicación"
             
             contexto.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: descripción) { [weak self] (success, error) in
                 guard let self else { return }
                 DispatchQueue.main.async {
                     if success {
                         // Autenticación exitosa
                         self.biometricResultLabel.text = "ÉXITO EN LA BIOMETRÍA"
                         return
                     }
                     // Manejar el error
                     self.biometricResultLabel.text = "ERROR EN LA BIOMETRÍA"
                 }
             }
         } else {
             // El dispositivo no es compatible con Face ID o Touch ID
             biometricResultLabel.text = "NO DISPONE DE BIOMETRÍA SU DISPOSITIVO"
         }
     }

}
