// Questions:
//  1).Convert arrays to sets? How to
//  2). do arrays/sets  automatically shift like arrayLists in java?
//  3). How to diagnosis crash
//  Set
//
//  Created by Kai Cottrell on 2/20/22.
//  Set Model

import Foundation

struct SetGame<a1: Equatable & Hashable,a2: Equatable & Hashable,a3: Equatable & Hashable,a4: Equatable & Hashable> {
    private var indexOfCard1: Int?
    private var indexOfCard2: Int?
    private var indexOfCard3: Int?
    private(set) var cardsInHand: Array<Card>
    private(set) var cardsOnScreen: Array<Card>
    private(set) var fullDeck: Array<Card>
    private(set) var cardsInDiscard: Array<Card>
    private(set) var numberOfSelectedCards: Int
    private(set) var numberOfSets: Int
    private(set) var lastSetWasMisMatch: Bool = false
    private(set) var replaceCards = false
    
    private(set) var isStartOfGame = true
    func getLastSetWasMisMatch() -> Bool{
        return lastSetWasMisMatch
    }
    mutating func select(_ card: Card){
        if let chosenIndex = cardsOnScreen.firstIndex(where: {$0.id == card.id})
        {
            cardsOnScreen[chosenIndex].isSelected = !cardsOnScreen[chosenIndex].isSelected
            if !cardsOnScreen[chosenIndex].isSelected{
                if chosenIndex == indexOfCard1{
                    indexOfCard1 = nil
                }
                if chosenIndex == indexOfCard2{
                    indexOfCard2 = nil
                }
                if chosenIndex == indexOfCard3{
                    indexOfCard3 = nil
                }
                numberOfSelectedCards-=1
            }
            else{
                numberOfSelectedCards+=1
                if(numberOfSelectedCards == 4){
                    if let indexToReplace1 = cardsOnScreen.firstIndex(where: {$0.isMatched && $0.hasBeenTested == false}){
                        cardsOnScreen[indexToReplace1].hasBeenTested = true
                        if let indexToReplace2 = cardsOnScreen.firstIndex(where: {$0.isMatched && $0.hasBeenTested == false}){
                            cardsOnScreen[indexToReplace2].hasBeenTested = true
                            if let indexToReplace3 = cardsOnScreen.firstIndex(where: {$0.isMatched && $0.hasBeenTested == false}){
                                cardsOnScreen[indexToReplace3].hasBeenTested = true
                                cardsInDiscard.append(cardsOnScreen[indexToReplace1])
                                cardsInDiscard.append(cardsOnScreen[indexToReplace2])
                                cardsInDiscard.append(cardsOnScreen[indexToReplace3])
                                cardsOnScreen[indexToReplace1].isShown = false
                                cardsOnScreen[indexToReplace2].isShown = false
                                cardsOnScreen[indexToReplace3].isShown = false
                                if(cardsInHand.count>0){
                                    cardsInHand.removeFirst(3)
                                }
                                
                            }
                        }
                    }
                    for index in 0..<cardsOnScreen.count{
                        cardsOnScreen[index].isSelected = false
                    }
                    cardsOnScreen[chosenIndex].isSelected = true
                    numberOfSelectedCards = 1
                    indexOfCard1 = nil
                    indexOfCard2 = nil
                    indexOfCard3 = nil
                }
                if indexOfCard1 == nil {
                    indexOfCard1 = chosenIndex
                }
                else if indexOfCard2 == nil {
                    indexOfCard2 = chosenIndex
                }
                else if indexOfCard3 == nil {
                    indexOfCard3 = chosenIndex
                }
                if numberOfSelectedCards == 3 {
                    for index in 0..<cardsOnScreen.count{
                        cardsOnScreen[index].wasInLastMismatch = false
                    }
                    if let ind1 = indexOfCard1, let ind2 = indexOfCard2, let ind3 = indexOfCard3{
                        let card1 = cardsOnScreen[ind1]
                        let card2 = cardsOnScreen[ind2]
                        let card3 = cardsOnScreen[ind3]
                        let match = getMatch(card1: card1, card2: card2, card3: card3)
                        if(match){
                            cardsOnScreen[ind1].isMatched = true
                            cardsOnScreen[ind2].isMatched = true
                            cardsOnScreen[ind3].isMatched = true
                            numberOfSets += 1
                            lastSetWasMisMatch = false
                        }
                        else{
                            lastSetWasMisMatch = true
                            cardsOnScreen[ind1].wasInLastMismatch = true
                            cardsOnScreen[ind2].wasInLastMismatch = true
                            cardsOnScreen[ind3].wasInLastMismatch = true
                            cardsOnScreen[ind1].isSelected = false
                            cardsOnScreen[ind2].isSelected = false
                            cardsOnScreen[ind3].isSelected = false
                        }
                    }
                }

            }
        }
        for card in 0..<cardsOnScreen.count{
            cardsOnScreen[card].isFaceUp = true
        }
        
    }
    func areCardsAvailableToDraw() -> Bool{
        if(cardsInHand.count >= 1){
            return true
        } else{
            return false
        }
    }
    func getNumberOfSets() -> Int{
        return numberOfSets
    }
    func gameOver() -> Bool{
        if(cardsOnScreen.count == 0){
            return true
        } else{
            return false
        }
    }
    
    mutating func addCardsToScreen(){
        if (isStartOfGame){
            cardsOnScreen.append(contentsOf: cardsInHand[0..<12])
            fullDeck = cardsInHand
            cardsInHand.removeFirst(12)
            isStartOfGame = false
        }
        else if let indexToReplace1 = cardsOnScreen.firstIndex(where: {!$0.isShown} ){
            cardsOnScreen[indexToReplace1] = cardsInHand[0]
            if let indexToReplace2 = cardsOnScreen.firstIndex(where: {!$0.isShown}){
                cardsOnScreen[indexToReplace2] = cardsInHand[1]
                if let indexToReplace3 = cardsOnScreen.firstIndex(where: {!$0.isShown}){
                    cardsOnScreen[indexToReplace3] = cardsInHand[2]
                    cardsInHand.removeFirst(3)
                }
            }
        }
        else if(numberOfSelectedCards == 3){
            for index in 0..<cardsOnScreen.count{
                cardsOnScreen[index].wasInLastMismatch = false
            }
            for index in 0..<cardsOnScreen.count{
                cardsOnScreen[index].isSelected = false
            }
            if let indexToReplace1 = cardsOnScreen.firstIndex(where: {$0.isMatched && $0.hasBeenTested == false}){
                cardsOnScreen[indexToReplace1].hasBeenTested = true
                if let indexToReplace2 = cardsOnScreen.firstIndex(where: {$0.isMatched && $0.hasBeenTested == false}){
                    cardsOnScreen[indexToReplace2].hasBeenTested = true
                    if let indexToReplace3 = cardsOnScreen.firstIndex(where: {$0.isMatched && $0.hasBeenTested == false}){
                        cardsOnScreen[indexToReplace3].hasBeenTested = true
                        cardsInDiscard.append(cardsOnScreen[indexToReplace1])
                        cardsInDiscard.append(cardsOnScreen[indexToReplace2])
                        cardsInDiscard.append(cardsOnScreen[indexToReplace3])
                        cardsOnScreen[indexToReplace1] = cardsInHand[0]
                        cardsOnScreen[indexToReplace2] = cardsInHand[1]
                        cardsOnScreen[indexToReplace3] = cardsInHand[2]
                       
                        cardsInHand.removeFirst(3)
                    }
                }
            }
            numberOfSelectedCards = 0
            indexOfCard1 = nil
            indexOfCard2 = nil
            indexOfCard3 = nil
        }
        else {
            if(cardsInHand.count > 1){
                cardsOnScreen.append(cardsInHand[0])
                cardsOnScreen.append(cardsInHand[1])
                cardsOnScreen.append(cardsInHand[2])
                cardsInHand.removeFirst(3)
            }
        }
        for card in 0..<cardsOnScreen.count{
            cardsOnScreen[card].isFaceUp = true
        }
    }
    func getCardsInHandCount() -> Int{
        return cardsInHand.count
    }
  
  
    func getMatch(card1: Card, card2: Card, card3: Card) -> Bool{
        let matchOnAttribute1 = ((card1.attribute1 == card2.attribute1) && (card2.attribute1 == card3.attribute1)) || ((card1.attribute1 != card2.attribute1) && (card2.attribute1 != card3.attribute1) && (card1.attribute1 != card3.attribute1))
        let matchOnAttribute2 = ((card1.attribute2 == card2.attribute2) && (card2.attribute2 == card3.attribute2)) || ((card1.attribute2 != card2.attribute2) && (card2.attribute2 != card3.attribute2) && (card1.attribute2 != card3.attribute2))
        let matchOnAttribute3 = ((card1.attribute3 == card2.attribute3) && (card2.attribute3 == card3.attribute3)) || ((card1.attribute3 != card2.attribute3) && (card2.attribute3 != card3.attribute3) && (card1.attribute3 != card3.attribute3))
        let matchOnAttribute4 = ((card1.attribute4 == card2.attribute4) && (card2.attribute4 == card3.attribute4)) || ((card1.attribute4 != card2.attribute4) && (card2.attribute4 != card3.attribute4) && (card1.attribute4 != card3.attribute4))
        return matchOnAttribute1 && matchOnAttribute2 && matchOnAttribute3 && matchOnAttribute4
    }
        
    init(create1: (Int) -> a1, create2: (Int) -> a2, create3: (Int) -> a3, create4: (Int) -> a4){
        cardsInHand = [] //Array<Card>()
        cardsOnScreen = []
        fullDeck = []
        cardsInDiscard = []
        numberOfSets = 0
        var id = 0
        for index1 in 0..<3{
            for index2 in 0..<3{
                for index3 in 0..<3{
                    for index4 in 0..<3{
                        cardsInHand.append(Card(attribute1: create1(index1), attribute2: create2(index2), attribute3: create3(index3), attribute4: create4(index4),id: id))
                        id = id+1
                    }
                }
            }
        }
        cardsInHand.shuffle()
        
        
        //let other = cardsInHand.prefix(12)// safe "up to 12"
        
        numberOfSelectedCards = 0
        
    }
    struct Card: Identifiable & Hashable{
        let attribute1: a1 // shape
        let attribute2: a2 // color
        let attribute3: a3 // shading
        let attribute4: a4 //count
        var isFaceUp = false
        var hasBeenTested : Bool = false
        var isShown = true
        var isSelected: Bool = false
        var wasInLastMismatch = false
       // let id = UUID()
        let id: Int
        var isMatched = false
    }

}
