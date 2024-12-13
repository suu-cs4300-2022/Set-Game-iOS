//  Questions:
//   1). How do I properly implement the createSetGame func?
//   2). how do I return some shape?
//   3). How do I make getShading func to work?
//  SetGameViewModel.swift
//  Set
//
//  Created by Kai Cottrell on 2/20/22.
// ViewModel

import SwiftUI
class SetGameViewModel: ObservableObject{
    typealias Card = SetGame<Shapes,Colors,Count,Shading>.Card
    private static func createSetGame() -> SetGame<Shapes,Colors,Count,Shading> {
        return SetGame(create1: {Shapes.allCases[$0]},create2: {Colors.allCases[$0]},create3: {Count.allCases[$0]},create4: {Shading.allCases[$0]})
    }
    
    
    @Published private var model = createSetGame() //observable object that detects when changes occur
    
//    init(){
//        
//    }
    func getLastSetWasMisMatch() -> Bool{
        return model.getLastSetWasMisMatch()
    }
    func getCardCount() -> Int{
         return model.getCardsInHandCount()
    }
    func getNumberOfSets() -> Int{
        return model.getNumberOfSets()
    }
    func select(_ card: Card){
        model.select(card)
    }
    func addCardsToScreen(){
        model.addCardsToScreen()
    }
    var cardsInHand: Array<Card>{
        model.cardsInHand
    }
    var cardsOnScreen: Array<Card>{
        model.cardsOnScreen
    }
    var cardsInDiscard: Array<Card>{
        model.cardsInDiscard
    }
    func areCardsAvailableToDraw() -> Bool{
        model.areCardsAvailableToDraw()
    }
    func createNewGame(){
        model = SetGameViewModel.createSetGame()
    }
    func gameOver() -> Bool{
        model.gameOver()
    }
    enum Shapes: CaseIterable {
        case rectangle
        case diamond
        case oval
    }
    enum Colors: CaseIterable {
        case green
        case purple
        case red
    }
    enum Count: CaseIterable {
        case one
        case two
        case three
    }
    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }

}

extension SetGameViewModel.Card {
    
    @ViewBuilder
    var shape: some View {
        let needsStroke = attribute4 == .open
        
        switch attribute1 {
        case .diamond:
            if(needsStroke){
                Diamond().stroke()
            }
            else{
                Diamond()
            }
            
        case .oval:
            if(needsStroke){
                Ellipse().stroke()
            }
            else{
                Ellipse()
            }
        case .rectangle:
            if(needsStroke){
                Rectangle().stroke()
            }
            else{
                Rectangle()
            }
        }
    }
    var color: Color{
        switch attribute2{
        case .green: return Color.green
        case .purple: return Color.purple
        case .red: return Color.red
        }
    }
    var count: Int{
        switch(attribute3){
        case .one: return 1
        case .two: return 2
        case .three: return 3
        }
    }
    var shading: Double{
        switch(attribute4){
        case .solid: return 1
        case .striped: return 0.3
        case .open: return 1
        }
    }
    var foreGroundColor: Color{
        if isMatched{
            return Color.green
        }
        else if(isSelected){
            return Color.yellow
        }
        else if wasInLastMismatch{
            return Color.red
        }
        else{
            return Color.black
        }
    }
    var cardCapcity : Double {
        if(isShown){
            return 1.0
        }
        else{
            return 0
        }
    }
    

}
