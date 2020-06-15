//
//  Extensions.swift
//  pongmp
//
//  Created by Ronaldo on 25/05/2020.
//  Copyright © 2020 Ronaldo. All rights reserved.
//

import Foundation
import UIKit


func /(left: CGPoint, scalar: CGFloat) -> CGPoint{
    return CGPoint(x: left.x/scalar, y: left.y/scalar)
}

func +(left: CGPoint, right: CGPoint) -> CGPoint{
    return CGPoint(x: left.x+right.x, y: right.y+left.y)
}
func -(left: CGPoint, right: CGPoint) -> CGPoint{
    return CGPoint(x: left.x-right.x, y: right.y-left.y)
}

func *(left: CGPoint, scalar: CGFloat) -> CGPoint{
    return CGPoint(x: left.x*scalar, y: left.y*scalar)
}
extension CGPoint {
    func length() -> CGFloat{
        return sqrt((x*x)+(y*y))
    }
    func normalized() -> CGPoint{
        return self/length()
    }
}


func /(left: CGVector, scalar: CGFloat) -> CGVector{
    return CGVector(dx: left.dx/scalar, dy: left.dy/scalar)
}

func +(left: CGVector, right: CGVector) -> CGVector{
    return CGVector(dx: left.dx+right.dx, dy: right.dy+left.dy)
}
func -(left: CGVector, right: CGVector) -> CGVector{
    return CGVector(dx: left.dx-right.dx, dy: right.dy-left.dy)
}

func *(left: CGVector, scalar: CGFloat) -> CGVector{
    return CGVector(dx: left.dx*scalar, dy: left.dy*scalar)
}

func *(left: CGVector, mult: CGVector) -> CGVector{
    return CGVector(dx: left.dx*mult.dx, dy: left.dy*mult.dy);
}


extension CGVector {
    func length() -> CGFloat{
        return sqrt((dx*dx)+(dy*dy))
    }
    func normalized() -> CGVector{
        return self/length()
    }
    func toString() -> String{
        return ("x: "+dx.description+", y: "+dy.description);
    }
    
}
