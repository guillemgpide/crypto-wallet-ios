import UIKit
import CoreData

class WalletViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!  // Displays the user's balance

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBalance()
    }

    func updateBalanceLabel() {
        fetchBalance()
    }

    // Function to fetch current user balance from the database
    func fetchBalance() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        // Retrieve the current user's ID from UserDefaults
        guard let userIDString = UserDefaults.standard.string(forKey: "currentUserID"),
              let userIDURL = URL(string: userIDString),
              let currentUserID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: userIDURL) else {
            print("No current user ID found")
            return
        }

        do {
            if let user = try context.existingObject(with: currentUserID) as? Users {
                DispatchQueue.main.async {
                    self.balanceLabel.text = "\(user.balance)€"
                }
            } else {
                print("No se encontró el usuario")
            }
        } catch {
            print("Error obteniendo el balance: \(error.localizedDescription)")
        }
    }

    @IBAction func didTapAddFunds(_ sender: UIButton) {
        showAddFundsPopup()
    }

    func showAddFundsPopup() {
        let alertController = UIAlertController(title: "Añadir fondos",
                                                message: "Introduce el importe y datos de la tarjeta",
                                                preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Número de tarjeta"
            textField.keyboardType = .numberPad
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "CVV"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Cantidad a añadir"
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        let confirmAction = UIAlertAction(title: "Confirmar", style: .default) { _ in
            guard let cardNumber = alertController.textFields?[0].text,
                  let cvv = alertController.textFields?[1].text,
                  let amountText = alertController.textFields?[2].text,
                  let amount = Float(amountText) else {
                self.showErrorPopup(message: "Datos inválidos")
                return
            }

            if cardNumber.count < 16 || cvv.count < 3 {
                self.showErrorPopup(message: "Datos de tarjeta inválidos")
                return
            }

            self.updateBalance(amount: amount)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)

        present(alertController, animated: true, completion: nil)
    }

    func showConfirmationPopup(amount: Float) {
        let confirmationAlert = UIAlertController(title: "Fondos añadidos",
                                                  message: "Se han añadido \(amount)€ a tu balance.",
                                                  preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        confirmationAlert.addAction(okAction)

        present(confirmationAlert, animated: true, completion: nil)
    }

    // Function to update the current user's balance in the database
    func updateBalance(amount: Float) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        // Retrieve the current user's ID from UserDefaults
        guard let userIDString = UserDefaults.standard.string(forKey: "currentUserID"),
              let userIDURL = URL(string: userIDString),
              let currentUserID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: userIDURL) else {
            print("No current user ID found")
            return
        }

        do {
            if let user = try context.existingObject(with: currentUserID) as? Users {
                user.balance += amount
                try context.save()

                DispatchQueue.main.async {
                    self.updateBalanceLabel()
                    self.showConfirmationPopup(amount: amount)
                }
            } else {
                print("No se encontró el usuario para actualizar")
                showErrorPopup(message: "No se encontró el usuario para actualizar")
            }
        } catch {
            print("Error actualizando balance: \(error.localizedDescription)")
            showErrorPopup(message: "Error al actualizar el balance")
        }
    }

    func showErrorPopup(message: String) {
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
