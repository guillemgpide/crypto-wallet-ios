//
//  CryptoAPIModels.swift
//  eric.faya<_guillem.gil<_jofre.tura
//
//  Created by Jofre Tura Centelles on 29/1/25.
//

import Foundation

struct CoinRankingResponse: Decodable {
    let status: String
    let data: DataContainer
}

struct DataContainer: Decodable {
    let coins: [CoinData]
}

struct CoinData: Decodable {
    let uuid: String
    let symbol: String
    let name: String
    let price: String?       // Viene como String en la API
    let change: String?      // Cambio en 24h también como String
    let rank: Int?
    let iconUrl: String?
}
