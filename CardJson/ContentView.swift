//
//  ContentView.swift
//  CardJson
//
//  Created by MacBook Pro on 10/11/23.
//

import SwiftUI

struct Card: Codable, Identifiable {
    let id: String
    let name: String
    let manaCost: String
    let typeLine: String
    let oracleText: String
    let colors: [String]
    let rarity: String
    let set: String
    let imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case manaCost = "mana_cost"
        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case colors
        case rarity
        case set
        case imageUrl = "image_uris.normal"
    }
}

struct CardResponse: Codable {
    let data: [Card]
}

class CardViewModel: ObservableObject {
    @Published var cards: [Card] = [
    ]
    
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

struct ContentView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    @State var searchvalue = ""
    
    var filteredCard: [Card] {
        if searchvalue.isEmpty {
            return cardViewModel.cards
        } else {
            return cardViewModel.cards.filter{ $0.name.contains(searchvalue) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredCard) { card in
                HStack {
                    AsyncImage(url: URL(string: card.imageUrl ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp_9jJ4eO7bVSx4KtliS0KK4ydiOpWojSvrdyFqbk&"))
                    VStack(alignment: .leading, content: {
                        Text("\(card.name)")
                            .font(.title2)
                            .bold()
                        Text(card.rarity)
                            .font(.caption)
                            .padding(.bottom)
                        Text(card.oracleText)
                            .font(.caption2)
                    })
                }
            }
            .searchable(text: $searchvalue, prompt: "Search Card")
            .navigationTitle("Cards")
        }
    }
}

#Preview {
    ContentView()
}
