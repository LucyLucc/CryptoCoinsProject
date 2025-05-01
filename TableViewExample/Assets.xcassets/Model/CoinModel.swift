//
//  Root.swift
//  CryptoCoinProject
//
//  Created by Lucy Chetalam on 28/04/2025.
//


import Foundation

// MARK: - Root
struct Root: Codable {
    let status: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let stats: Stats
    let coins: [Coin]
}

// MARK: - Stats
struct Stats: Codable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    let totalExchanges: Int
    let totalMarketCap: String
    let total24hVolume: String
}

// MARK: - Coin
struct Coin: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let color: String
    let iconUrl: String
    let marketCap: String
    let price: String
    let listedAt: Int
    let tier: Int
    let change: String
    let rank: Int
    let sparkline: [String?] // Array can contain strings or null
    let lowVolume: Bool
    let coinrankingUrl: String
    let volume24h: String
    let btcPrice: String
    let contractAddresses: [String]
    
    // Property to match `24hVolume` key in JSON with `volume24h` in Swift
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume, coinrankingUrl, btcPrice, contractAddresses
        case volume24h = "24hVolume"
    }
}

