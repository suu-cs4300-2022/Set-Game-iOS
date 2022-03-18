//
//  CardView.swift
//  Set
//
//  Created by Kai Cottrell on 3/15/22.
//

import SwiftUI

struct CardView: View{
    @State var cardWidth :CGFloat = 0 //possbile @ state
    @State var cardHeight :CGFloat = 0 //possbile @ state
    let card: SetGameViewModel.Card
    var body: some View{
        GeometryReader(content: { geometry in
            VStack{
                if(card.count == 1){
                    HStack{
                        card.shape.foregroundColor(card.color).opacity(card.shading)
                        .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0 ))
                        .scaleEffect(card.wasInLastMismatch ?  0.5 :  1)
                   }
                }
                if(card.count == 2){
                    HStack{
                        card.shape.foregroundColor(card.color).opacity(card.shading)
                        .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0 ))
                        .scaleEffect(card.wasInLastMismatch ?  0.5 :  1)
                   }
                    HStack{
                        card.shape.foregroundColor(card.color).opacity(card.shading)
                        .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0 ))
                        .scaleEffect(card.wasInLastMismatch ?  0.5 :  1)
                   }
                }
                if(card.count == 3){
                    HStack{
                        card.shape.foregroundColor(card.color).opacity(card.shading)
                        .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0 ))
                        .scaleEffect(card.wasInLastMismatch ?  0.5 :  1)
                   }
                    HStack{
                        card.shape.foregroundColor(card.color).opacity(card.shading)
                        .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0 ))
                        .scaleEffect(card.wasInLastMismatch ?  0.5 :  1)
                   }
                    HStack{
                        card.shape.foregroundColor(card.color).opacity(card.shading)
                        .frame(width: geometry.size.width/1.5, height: geometry.size.height/6)
                        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0 ))
                        .scaleEffect(card.wasInLastMismatch ?  0.5 :  1)
                   }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .cardify(isFaceUp: card.isFaceUp)
            .foregroundColor(card.foreGroundColor)
            .opacity(card.cardCapcity)
        })
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants{
        static let fontScale: CGFloat = 0.65
        static let fontSize: CGFloat = 32
    }
    
}
