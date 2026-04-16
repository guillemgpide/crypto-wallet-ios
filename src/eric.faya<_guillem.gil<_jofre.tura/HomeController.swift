//
//  HomeController.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 1/26/25.
//

import UIKit
import CoreData
import SDWebImage

class HomeController: UIViewController, UINavigationControllerDelegate {
//Hay que definir el delegado y el datasource de la tabla, deben ser un controlador,los delegados y datasource tipicamente suelen ser los elementos que los contengan

    @IBOutlet weak var balanceUser: UILabel!
    @IBOutlet weak var table: UITableView!
    var cryptos: [Crypto] = []  // Aquí guardaremos las instancias de CoreData

        override func viewDidLoad() {
            super.viewDidLoad()
            // configuraciones de la tabla
            table.dataSource = self
            table.delegate   = self
            self.navigationController?.delegate = self

        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchCryptos()         // 1) Hacemos el fetch
            table.reloadData()     // 2) Recargamos la tabla
            initializeCustomCell() // 3) Registramos la celda custom (opcional aquí o en viewDidLoad)
            fetchUserBalance()
        }
        
        private func initializeCustomCell(){
            table.register(UINib(nibName: "CryptoRow", bundle: .main),
                           forCellReuseIdentifier: "cryptoRowCell")
        }

        // MARK: - Fetch a CoreData
    private func fetchCryptos() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<Crypto> = Crypto.fetchRequest()
            // Ordenem la info per el valor RANK
            let sortDescriptor = NSSortDescriptor(key: "rank", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                let result = try context.fetch(fetchRequest)
                self.cryptos = result
                
                // 🔹 Debug: Ver los datos obtenidos
                print("✅ Número de criptos en Core Data: \(cryptos.count)")
                for crypto in cryptos {
                    print("🔹 Crypto: \(crypto.name ?? "Sin nombre"), Precio: \(crypto.price)")
                }

                // 🔹 Recargar la tabla para actualizar los datos
                DispatchQueue.main.async {
                    self.table.reloadData()
                }

            } catch {
                print("❌ Error al hacer fetch de Crypto: \(error.localizedDescription)")
            }
        }

        // Fetch the user's balance from the database
        private func fetchUserBalance() {
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
                        self.balanceUser.text = "\(user.balance)€"
                    }
                } else {
                    print("No se encontró el usuario")
                }
            } catch {
                print("Error obteniendo el balance: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    extension HomeController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cryptos.count
        }
        
        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "cryptoRowCell",
                for: indexPath
            ) as! CryptoRow  // tu clase custom de celda

            let crypto = cryptos[indexPath.row]
            
            cell.cryptoName.text = crypto.name
            cell.cryptoValue.text = "\(crypto.price)"         // si quieres formatear la moneda, hazlo aquí
            let lastMovement = crypto.lastMovement
                   
                   // Configura el texto de cryptoLastMovemenet con color dependiendo del valor
                   cell.cryptoLastMovemenet.text = "\(lastMovement)%"
                   cell.cryptoLastMovemenet.textColor = lastMovement >= 0 ? .green : .red
                   
            //cell.cryptoLastMovemenet.text = "\(crypto.lastMovement)%" // etc.
            // Cargar imagen con SDWebImage ELIMINAR SI N ES VOL IMATGE AL FINAL
            if let urlString = crypto.iconUrl,
               let url = URL(string: urlString) {
                cell.cryptoIcon.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
            } else {
                // Si no tiene iconUrl, pones un placeholder
                cell.cryptoIcon.image = UIImage(systemName: "photo")
            }
            

            return cell
        }
    }

    // MARK: - UITableViewDelegate
    extension HomeController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let crypto = cryptos[indexPath.row]
            print("Crypto Selected: \(crypto.name ?? "Desconocida")")
            if let operateVC = storyboard?.instantiateViewController(withIdentifier: "OperateViewController") as? OperateViewController {
                        operateVC.crypto = crypto
                navigationController?.pushViewController(operateVC, animated: true)
            }
        }
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
               if viewController === self {
                   navigationController.popViewController(animated: false)
               }
           }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "showOperateView" {
                    if let destinationVC = segue.destination as? OperateViewController,
                       let selectedCrypto = sender as? Crypto {
                        destinationVC.crypto = selectedCrypto
                    }
                }
            }
        
    }
