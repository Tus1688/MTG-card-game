//
//  CardDetailView.swift
//  CardJson
//
//  Created by MacBook Pro on 16/11/23.
//

import SwiftUI

struct CardDetailView: View {
    let cards: [Card]
    @State private var currentCardIndex: Int
    @State private var isPeeking = false
    @State private var offset: CGFloat = 0
    
    init(cards: [Card], initialIndex: Int) {
        self.cards = cards
        _currentCardIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged { gesture in
                offset = gesture.translation.width
            }
            .onEnded { gesture in
                let dragThreshold: CGFloat = 100
                if gesture.translation.width < -dragThreshold && currentCardIndex < cards.count - 1 {
                    withAnimation {
                        currentCardIndex += 1
                        offset = UIScreen.main.bounds.width // Move to the right
                    }
                } else if gesture.translation.width > dragThreshold && currentCardIndex > 0 {
                    withAnimation {
                        currentCardIndex -= 1
                        offset = -UIScreen.main.bounds.width // Move to the left
                    }
                } else {
                    withAnimation {
                        offset = 0 // Return to the center
                    }
                }
            }
        
        ZStack {
            ScrollView {
                VStack(alignment: .center, content: {
                    if let imageUris = cards[currentCardIndex].imageUrl {
                        AsyncImage(url: imageUris.artCrop) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .onTapGesture {
                                    isPeeking.toggle()
                                }
                        } placeholder: {
                            Color.secondary
                                .opacity(0.6)
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                        }
                        .cornerRadius(14)
                    }
                    HStack(alignment: .top , content: {
                        VStack(alignment: .leading, content: {
                            Text(cards[currentCardIndex].name)
                                .multilineTextAlignment(.leading)
                                .font(.title2)
                                .bold()
                            Text(cards[currentCardIndex].typeLine ?? "")
                                .multilineTextAlignment(.leading)
                                .font(.subheadline)
                        })
                        Spacer()
                        if let manaCost = cards[currentCardIndex].manaCost {
                            HStack(spacing: 5) {
                                ForEach(Array(manaCost.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")), id: \.self) { char in
                                    Text(String(char))
                                        .font(.subheadline)
                                        .bold()
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.secondary)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    })
                    .padding(.vertical)
                    Text(cards[currentCardIndex].oracleText ?? "")
                        .font(.caption)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(14)
                    HStack {
                        Text("Legalities")
                            .font(.subheadline)
                            .bold()
                            .padding(.top)
                        Spacer()
                    }
                    legalitiesView(legalities: cards[currentCardIndex].legalities)
                })
                .padding()
                .gesture(dragGesture)
            }
            
            if isPeeking {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all) // Dark overlay
                    .onTapGesture {
                        isPeeking = false
                    }
                
                if let imageUris = cards[currentCardIndex].imageUrl {
                    AsyncImage(url: imageUris.large) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                isPeeking = false
                            }
                    } placeholder: {
                        Color.secondary
                            .opacity(0.6)
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                    }
                    .cornerRadius(14)
                    .onTapGesture {
                        isPeeking = false
                    }
                }
            }
        }
        
    }
}

private struct legalitiesView: View {
    let legalities: Legalities
    var body: some View {
        HStack(alignment: .top, content: {
            VStack {
                helperView(label: "Standard", value: legalities.standard)
                helperView(label: "Future", value: legalities.future)
                helperView(label: "Historic", value: legalities.historic)
                helperView(label: "Gladiator", value: legalities.gladiator)
                helperView(label: "Pioneer", value: legalities.pioneer)
                helperView(label: "Explorer", value: legalities.explorer)
                helperView(label: "Modern", value: legalities.modern)
                helperView(label: "Legacy", value: legalities.legacy)
                helperView(label: "Pauper", value: legalities.pauper)
                helperView(label: "Penny", value: legalities.penny)
                helperView(label: "Vintage", value: legalities.vintage)
            }
            .padding(.trailing)
            VStack {
                helperView(label: "Commander", value: legalities.commander)
                helperView(label: "Oathbreaker", value: legalities.oathbreaker)
                helperView(label: "Brawl", value: legalities.brawl)
                helperView(label: "Historic Brawl", value: legalities.historicbrawl)
                helperView(label: "Alchemy", value: legalities.alchemy)
                helperView(label: "Pauper Commander", value: legalities.paupercommander)
                helperView(label: "Duel", value: legalities.duel)
                helperView(label: "Old School", value: legalities.oldschool)
                helperView(label: "Premodern", value: legalities.premodern)
                helperView(label: "Pre DH", value: legalities.predh)
            }
            .padding(.leading)
        })
    }
    
    func helperView(label: String, value: String) -> some View {
        HStack {
            Text(value == "legal" ? "Legal" : "Not Legal")
                .font(.caption)
                .bold()
                .padding(7)
                .frame(minWidth: 80)
                .background(getBackgroudColor(value))
                .cornerRadius(6)
                .multilineTextAlignment(.center) // Align the text center
            Spacer()
            Text(label)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func getBackgroudColor(_ value: String) -> Color {
        switch value {
        case "legal":
            return Color.green.opacity(0.5)
        case "not_legal":
            return Color.secondary.opacity(0.5)
        default:
            return Color.secondary.opacity(0.5)
        }
    }
}

private struct previewCardDetailView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    var body: some View {
        CardDetailView(cards: cardViewModel.cards, initialIndex: 0)
    }
}

#Preview {
    previewCardDetailView()
}
