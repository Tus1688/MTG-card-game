//
//  ContentView.swift
//  CardJson
//
//  Created by MacBook Pro on 10/11/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    @State var searchvalue = ""
    @State var sortingAscending: Bool? = nil
    
    var filteredCards: [Card] {
        var sortedCards = cardViewModel.cards
        
        if let isAscending = sortingAscending {
            sortedCards.sort(by: { card1, card2 in
                if isAscending {
                    return card1.name < card2.name
                } else {
                    return card1.name > card2.name
                }
            })
        }
        
        if !searchvalue.isEmpty {
            sortedCards = sortedCards.filter { $0.name.lowercased().contains(searchvalue.lowercased()) }
        }
        
        return sortedCards
    }
    
    var body: some View {
        NavigationView {
            List(filteredCards) { card in
                NavigationLink(destination: CardDetailView(card: card)) {
                    HStack(alignment: .center) {
                        CardImageView(card: card)
                        VStack(alignment: .leading) {
                            Text(card.name)
                                .font(.headline)
                                .bold()
                            Text(card.rarity)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 15)
                            Text(card.oracleText ?? "")
                                .font(.caption2)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchvalue, prompt: "Search Card")
            .navigationTitle("Card List")
            .navigationBarItems(trailing: Button(action: {
                if sortingAscending == nil {
                    sortingAscending = true
                } else if sortingAscending == true {
                    sortingAscending = false
                } else {
                    sortingAscending = nil
                }
            }) {
                Text(sortingAscending == nil ? "Sort A-Z" : (sortingAscending! ? "Sort Z-A" : "Clear Sort"))
                    .padding(.horizontal)
            })
        }
    }
}

#Preview {
    ContentView()
}
