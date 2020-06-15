//
//  Ball.swift
//  pongmp
//
//  Created by Ronaldo on 06/06/2020.
//  Copyright © 2020 Ronaldo. All rights reserved.
//

import Foundation
import SpriteKit;


class BallNode : SKSpriteNode{
    class func ball(location : CGPoint) -> BallNode {
        let sprite = BallNode(imageNamed: "ball");
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 32.0 / 2);
        sprite.physicsBody?.usesPreciseCollisionDetection = true;
        sprite.physicsBody?.isDynamic = true;
        sprite.physicsBody?.restitution = 1;
        sprite.physicsBody?.friction = 0;
        
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.ball;
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.paddle;
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.none;
        
        return sprite;
    }
}
