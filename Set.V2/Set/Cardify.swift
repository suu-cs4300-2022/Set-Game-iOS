//
//  Cardify.swift
//  SetGame
//
//  Created by Kai Cottrell on 2/16/22.
//

import SwiftUI

struct Cardify: AnimatableModifier{
    init(isFaceUp: Bool){
        rotation = isFaceUp ? 0 : 180
    }
    var animatableData: Double{
        get{ rotation }
        set{ rotation = newValue }
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if rotation < 90{
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else{
                shape.fill()
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    private struct DrawingConstants{
        static let cornerRadius: CGFloat = 8
        static let lineWidth: CGFloat = 1
    }
}
extension View{
    func cardify(isFaceUp: Bool) -> some View{
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
