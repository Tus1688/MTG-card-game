//
//  CardViewModel.swift
//  CardJson
//
//  Created by MacBook Pro on 10/11/23.
//

import SwiftUI

struct Card: Codable, Identifiable {
    let id: String
    let name: String
    let manaCost: String?
    let typeLine: String?
    let oracleText: String?
    let colors: [String]?
    let rarity: String
    let set: String
    let imageUrl: ImageUris?
    let prices: Prices?
    let foil: Bool?
    let nonfoil: Bool?
    let reserved: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case manaCost = "mana_cost"
        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case colors
        case rarity
        case set
        case imageUrl = "image_uris"
        case prices
        case foil
        case reserved
        case nonfoil
    }
}

struct Prices: Codable {
    var usd: String?
    var usdFoil: String?
    
    enum CodingKeys: String, CodingKey {
        case usd
        case usdFoil = "usd_foil"
    }
}

struct ImageUris: Codable {
    var small: URL
    var normal: URL
    var large: URL?
    var png: URL?
    var artCrop: URL?
    var borderCrop: URL?
    
    enum CodingKeys: String, CodingKey {
        case small
        case normal
        case large
        case png
        case artCrop = "art_crop"
        case borderCrop = "border_crop"
    }
}

struct CardResponse: Codable {
    let data: [Card]
}

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = []
    
    init() {
        if let url = Bundle.main.url(forResource: "WOT-Scryfall", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(CardResponse.self, from: data)
                self.cards = response.data
            } catch {
                print("error decoding json: \(error)")
            }
        }
    }
}
