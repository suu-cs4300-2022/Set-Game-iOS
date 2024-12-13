//
//  SetView.swift
//  Set
//
//  Created by Kai Cottrell on 2/20/22.
// View
//TO DO:
/*

 */

import SwiftUI

struct SetView: View {
    @ObservedObject var game: SetGameViewModel
    @Namespace private var dealingNamespace
    @State private var dealt = Set<Int>()
    @State var delayNumber: Double = 1
    var body: some View {
        VStack{
            Text("Set!").font(.largeTitle).foregroundColor(Color.orange)
            HStack{
                Text("Num of sets: " + String(game.getNumberOfSets()))
                newGameButton
            }
            .padding(.horizontal)
            gameBody
            HStack{
                if(game.areCardsAvailableToDraw()){
                    drawDeckBody
                }
                if(game.cardsInDiscard.count != 0){
                    discardDeckBody
                }
            }
            Spacer()
        }
    }

    
    private func deal(_ card: SetGameViewModel.Card){
        dealt.insert(card.id)
    }
    private func isUnDealt(_ card: SetGameViewModel.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: SetGameViewModel.Card) -> Animation{
        var delay = 0.0
        
        if game.cardsOnScreen.count < 14{
            if let index = game.cardsOnScreen.firstIndex(where: {$0.id == card.id}){
                delay = Double(index) * (CardConstants.totalDealDuration  / Double(game.cardsOnScreen.count))
            }
        }
        else{
    
            if (delayNumber  == 4){
                delayNumber = 1
            }
            delay = delayNumber/2
            delayNumber+=1
        
        }
        
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    var drawDeckBody: some View{
        //let myCard = game.cardsOnScreen[0]
        ZStack{
            ForEach(game.cardsInHand.filter(isUnDealt)){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
            
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(Color.black)
        .onTapGesture {
            withAnimation{
                game.addCardsToScreen()
            }
            for card in game.cardsOnScreen{
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
    }
    
    var discardDeckBody: some View{
        ZStack{
            ForEach(game.cardsInDiscard){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
            
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(Color.black)
    }
    
    private func zIndex(of card: SetGameViewModel.Card) -> Double{
        -Double(game.cardsOnScreen.firstIndex(where: {$0.id == card.id}) ?? 0 )
    }
    
    private struct CardConstants{
        static let color = Color.red
        static let aspectRatio: CGFloat = 5/7
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    var gameBody: some View{
        AspectVGrid(items: game.cardsOnScreen, aspectRatio: CardConstants.aspectRatio){ card in
            if isUnDealt(card) || !card.isFaceUp{
                Color.clear
            }else{
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex((zIndex(of:card)))
                    .onTapGesture {
                        withAnimation{
                            game.select(card)
                        }
                    }
            }
        }
    }
    
    var newGameButton: some View{
        HStack{
            Spacer()
            Text("New Game:")
            Button(action: {
                withAnimation{
                    dealt = []
                    game.createNewGame()
                }
            },label:{
                HStack{
                    Image(systemName: "play.rectangle").aspectRatio(2/3, contentMode: .fit).font(.largeTitle)
                }
            })
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetView(game: game)
    }
}
