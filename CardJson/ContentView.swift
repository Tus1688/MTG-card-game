//
//  ContentView.swift
//  CardJson
//
//  Created by MacBook Pro on 10/11/23.
//

import SwiftUI

struct CardImageView: View {
    let card: Card
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            if let imageUris = card.imageUrl {
                AsyncImage(url: imageUris.small) { image in
                    image.resizable()
                } placeholder: {
                    Color.secondary.frame(width: 80, height: 120)
                        .opacity(0.6)
                }
                .frame(width: 80, height: 120)
                .cornerRadius(6)
                
                if card.foil == true{
                    Text("F")
                        .fontWeight(.bold)
                        .font(.caption2)
                        .padding(4)
                        .background(Color.accentColor.opacity(0.7))
                        .cornerRadius(4)
                        .padding([.bottom, .leading], 4)
                }
                
                if card.nonfoil == true {
                    Text("N")
                        .fontWeight(.bold)
                        .font(.caption2)
                        .padding(4)
                        .background(Color.indigo.opacity(0.7))
                        .cornerRadius(4)
                        .padding([.leading], 22)
                        .padding([.bottom], 4)
                }
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
            return cardViewModel.cards.filter{$0.name.lowercased().contains(searchvalue.lowercased())}
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredCard) { card in
                HStack(alignment: .center, content: {
                    CardImageView(card: card)
                    VStack(alignment: .leading, content: {
                        Text(card.name)
                            .font(.headline)
                            .bold()
                        Text(card.rarity)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 15)
                        Text(card.oracleText ?? "")
                            .font(.caption2)
                    })
                    .padding(.vertical, 10)
                })
            }
            .searchable(text: $searchvalue, prompt: "Search Card")
            .navigationTitle("Card List")
        }
    }
}

#Preview {
    ContentView()
}
