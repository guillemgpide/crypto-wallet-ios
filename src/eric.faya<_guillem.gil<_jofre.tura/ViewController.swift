//
//  ViewController.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by user273002 on 1/24/25.
//
	
import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        performRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    private func performRequest() {
        let url = "https://coinranking1.p.rapidapi.com/coins?referenceCurrencyUuid=yhjMzLPhuIDl&timePeriod=24h&tiers=1&orderBy=marketCap&orderDirection=desc&limit=50&offset=0"
        
        let headers: HTTPHeaders = [
            "X-RapidAPI-Key": "7f4314a05emsh242c66f7019aeb3p1f6281jsn7c5ebb8c04ef",
            "X-RapidAPI-Host": "coinranking1.p.rapidapi.com"
        ]
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CoinRankingResponse.self) { response in
                switch response.result {
                case .success(let decodedData):
                    print("✅ Respuesta de la API recibida correctamente:")
                    print(decodedData) // 🔹 Verifica que los datos lleguen correctamente
                    self.saveToCoreData(coins: decodedData.data.coins)
                    
                case .failure(let error):
                    print("❌ Error en la petición: \(error.localizedDescription)")
                }
            }
    }
    
    private func saveToCoreData(coins: [CoinData]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // 1) BORRAR TODO PARA EVITAR DUPLICADOS
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Crypto.fetchRequest()
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDelete)
            print("➡️ Datos previos borrados de CoreData (entidad Crypto).")
        } catch {
            print("❌ Error al borrar datos previos: \(error.localizedDescription)")
        }

        // 2) AHORA INSERTAS LAS NUEVAS COINS
        for coin in coins {
            let newCrypto = Crypto(context: context)
            newCrypto.uuid   = coin.uuid
            newCrypto.symbol = coin.symbol
            newCrypto.name   = coin.name
            newCrypto.iconUrl = coin.iconUrl
            
            // price ->  si falla, lo ponemos a 0
            if let priceString = coin.price, let priceFloat = Float(priceString) {
                newCrypto.price = priceFloat
            } else {
                newCrypto.price = 0
            }

            // change -> si falla, lo ponemos a 0
            if let changeString = coin.change, let changeFloat = Float(changeString) {
                newCrypto.lastMovement = changeFloat
            } else {
                newCrypto.lastMovement = 0
            }

            // rank
            if let rank = coin.rank {
                newCrypto.rank = Int16(rank)
            }
        }

        // 3) Guardar todo
        do {
            try context.save()
            print("✅ Datos guardados correctamente en CoreData.")
        } catch {
            print("❌ Error al guardar en CoreData: \(error.localizedDescription)")
        }
    }
}
