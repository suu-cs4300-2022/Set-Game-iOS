//
//  Diamond.swift
//  Set
//
//  Created by Kai Cottrell on 2/20/22.
//

import SwiftUI

struct Diamond: Shape{
    var widthFactor: Float = 1.8 //could be changed when struct is called
    
    func path(in rect: CGRect) -> Path {
        //let paddingConstant: CGFloat = (min(rect.width,rect.height)/CGFloat(10))
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = (min(rect.width, rect.height))/*- paddingConstant*/
        let start = CGPoint(
            x: center.x - radius,
            y: center.y
        )
        let top = CGPoint(
            x: center.x,
            y: center.y - radius/CGFloat(widthFactor)
        )
        let bottom = CGPoint(
            x: center.x,
            y: center.y + radius/CGFloat(widthFactor)
        )
        let right = CGPoint(
            x: center.x + radius,
            y: center.y
        )
        
        var p = Path()
        p.move(to: start)
        p.addLine(to: start)
        p.addLine(to: top)
        p.addLine(to: right)
        p.addLine(to: bottom)
        p.addLine(to: start)
        return p
    }
    
    
    
}

