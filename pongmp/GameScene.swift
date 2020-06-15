//
//  GameScene.swift
//  pongmp
//
//  Created by Ronaldo on 25/05/2020.
//  Copyright © 2020 Ronaldo. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

/*struct PhysicsCategory{
    static let none : UInt32 = 0x0;
    
    static let ball   : UInt32 = 0b0001;
    static let paddle : UInt32 = 0b0010;
    static let border : UInt32 = 0b0100;
    
    static let all : UInt32 = 0x1;
}*/



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Game variables
    var time = CFTimeInterval();
    var lastUpdate = CFTimeInterval();
    var deltaTime = CFTimeInterval();
    
    //Game Objects
    var ball = SKSpriteNode(imageNamed: "ball");
    var paddleOne = SKSpriteNode(imageNamed: "pixel");
    var paddleTwo = SKSpriteNode(imageNamed: "pixel");
    var border = SKPhysicsBody();
    
    //Objects Variables
    var paddlesYPosition = CGFloat();
    var paddlesMaxXPosition = CGFloat();
    var paddlesXSize = CGFloat();
    var paddlesYSize = CGFloat();
    let minBallVelocity = CGFloat(500.0);
    let maxBallVelocity = CGFloat(2000.0);
    var currentBallSpeed = CGFloat(500.0);
    let speedToAddPerBounce = CGFloat(50.0);
    
    //Players Scores
    var scorePlayerOne = Int(0);
    var scorePlayerTwo = Int(0);
    var scoreBoardPlayerOne = SKLabelNode(fontNamed: "Arial");
    var scoreBoardPlayerTwo = SKLabelNode(fontNamed: "Arial");
    var scoreBoardYPosition = CGFloat();
    let ballShader = SKShader(fileNamed: "ballshader");
    
    
    override func didMove(to view: SKView) {
        
        //Setup Scene
        removeAllChildren();
        backgroundColor = SKColor.black;
        
        
        //Setup Sizes
        paddlesYPosition = (self.size.height/2.0)*0.9;
        paddlesXSize = (self.size.width/5.0);
        paddlesMaxXPosition = (self.size.width/2.0)-paddlesXSize/2.0;
        scoreBoardYPosition = (self.size.height/4.0);
        
        
        //Setup World Physics
        physicsWorld.gravity = .zero;
        physicsWorld.contactDelegate = self;
        
        
        //Setup Border Physics
        border = SKPhysicsBody(edgeLoopFrom: self.frame);
        border.isDynamic = false;
        border.categoryBitMask = 0b0010;
        border.usesPreciseCollisionDetection = true;
        self.physicsBody = border;
        
        
        //Setup Ball
        ball.name = "ball";
        ball.position = CGPoint(x:0.0,y:0.0);
        ball.size = CGSize(width: self.size.width*0.04, height: self.size.width*0.04);
        ball.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width*0.02);
        ball.physicsBody?.isDynamic = true;
        ball.physicsBody?.categoryBitMask = 0b0001;
        ball.physicsBody?.collisionBitMask = 0b0110;
        ball.physicsBody?.contactTestBitMask = 0b0110;
        ball.physicsBody?.restitution = 1;
        ball.physicsBody?.friction = 0;
        ball.physicsBody?.angularDamping = 0;
        ball.physicsBody?.linearDamping = 0;
        ball.physicsBody?.allowsRotation = false;
        ball.physicsBody?.affectedByGravity = true;
        ball.physicsBody?.usesPreciseCollisionDetection = true;
        
        
        //Setup Paddle One
        paddleOne.name = "p1";
        paddleOne.size = CGSize(width: paddlesXSize, height: 32);
        paddleOne.position = CGPoint(x: 0.0, y: -paddlesYPosition);
        paddleOne.physicsBody = SKPhysicsBody(rectangleOf: paddleOne.size);
        paddleOne.physicsBody?.isDynamic = false;
        paddleOne.physicsBody?.affectedByGravity = false;
        paddleOne.physicsBody?.categoryBitMask = 0b0100;
        paddleOne.physicsBody?.collisionBitMask = 0b0011;
        paddleOne.physicsBody?.contactTestBitMask = 0b0000;
        paddleOne.physicsBody?.allowsRotation = false;
        paddleOne.physicsBody?.usesPreciseCollisionDetection = true;
                
        
        //Setup Paddle Two
        paddleTwo.name = "p2";
        paddleTwo.size = CGSize(width: paddlesXSize, height: 32);
        paddleTwo.position = CGPoint(x: 0.0, y: paddlesYPosition);
        paddleTwo.physicsBody = SKPhysicsBody(rectangleOf: paddleTwo.size);
        paddleTwo.physicsBody?.isDynamic = false;
        paddleTwo.physicsBody?.affectedByGravity = false;
        paddleTwo.physicsBody?.categoryBitMask = 0b0100;
        paddleTwo.physicsBody?.collisionBitMask = 0b0011;
        paddleTwo.physicsBody?.contactTestBitMask = 0b0000;
        paddleTwo.physicsBody?.allowsRotation = false;
        paddleTwo.physicsBody?.usesPreciseCollisionDetection = true;
        
        
        //Add Score Board
        scoreBoardPlayerOne.text = "0";
        scoreBoardPlayerOne.fontSize = self.size.width/4.0;
        scoreBoardPlayerOne.name = "scoreboard_p1";
        scoreBoardPlayerOne.position = CGPoint(x: 0, y: -scoreBoardYPosition);
        scoreBoardPlayerOne.fontColor = UIColor(white: 1.0, alpha: 1.0);
        
        scoreBoardPlayerTwo.text = "0";
        scoreBoardPlayerTwo.fontSize = self.size.width/4.0;
        scoreBoardPlayerTwo.name = "scoreboard_p2";
        scoreBoardPlayerTwo.position = CGPoint(x: 0, y: scoreBoardYPosition);
        scoreBoardPlayerTwo.fontColor = UIColor(white: 1.0, alpha: 1.0);
        scoreBoardPlayerTwo.zRotation = .pi;
        
        
        //Add the In-Game Objects
        addChild(scoreBoardPlayerOne);
        addChild(scoreBoardPlayerTwo);
        addChild(ball);
        addChild(paddleOne);
        addChild(paddleTwo);
        
        
        //First Ball impulse
        ball.physicsBody!.applyImpulse(CGVector(dx: (Int.random(in: 0...1) == 0) ? CGFloat(-10.0) : CGFloat(10.0), dy: 10.0));
        
        
        //Apply Ball Shader
        ball.shader = ballShader;
        
        
        //Starting to Track Update
        lastUpdate = CFTimeInterval(CACurrentMediaTime());
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        time = currentTime;
        deltaTime = time - lastUpdate;
        
        if(ball.position.y <= -paddlesYPosition){
            scorePlayerTwo += 1;
            ball.position = CGPoint(x: 0.0, y: 0.0);
            ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0);
            ball.physicsBody!.applyImpulse(CGVector(dx: (Int.random(in: 0...1) == 0) ? CGFloat(-10.0) : CGFloat(10.0), dy: -10.0));
            scoreBoardPlayerTwo.text = "\(scorePlayerTwo)";
            currentBallSpeed = minBallVelocity;
        }else if(ball.position.y >= paddlesYPosition){
            scorePlayerOne += 1;
            ball.position = CGPoint(x: 0.0, y: 0.0);
            ball.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0);
            ball.physicsBody!.applyImpulse(CGVector(dx: (Int.random(in: 0...1) == 0) ? CGFloat(-10.0) : CGFloat(10.0), dy: 10.0));
            scoreBoardPlayerOne.text = "\(scorePlayerOne)";
            currentBallSpeed = minBallVelocity;
        }
        
        lastUpdate = time;
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if((contact.bodyA.node?.name == "p1" || contact.bodyA.node?.name == "p2") && contact.bodyB.node?.name == "ball"){
            var newVelocity = CGVector(dx: 0.0, dy: 0.0);
            newVelocity.dy = contact.contactNormal.dy;
            newVelocity.dx = CGFloat(((contact.bodyB.node?.position.x)!) - (contact.bodyA.node?.position.x)!) / (self.size.width/4.0);
            
            currentBallSpeed += speedToAddPerBounce;
            currentBallSpeed = (currentBallSpeed > maxBallVelocity) ? maxBallVelocity : currentBallSpeed;
            
            ball.physicsBody?.velocity = newVelocity.normalized()*currentBallSpeed;
        }
    }
    
    
    func touchMoved(toPoint pos : CGPoint) {
        if(pos.y<0.0)
        {MoveTo(paddle: paddleOne, fingerPosition: pos);}
        else
        {MoveTo(paddle: paddleTwo, fingerPosition: pos);}
    }
    
    
    func MoveTo(paddle : SKSpriteNode, fingerPosition : CGPoint){
        if(fingerPosition.x > paddlesMaxXPosition){
            paddle.position.x = paddlesMaxXPosition;
        }else if(fingerPosition.x < -paddlesMaxXPosition){
            paddle.position.x = -paddlesMaxXPosition;
        }else{
            paddle.position.x = fingerPosition.x;
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{self.touchMoved(toPoint: t.location(in: self))}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{self.touchMoved(toPoint: t.location(in: self))}
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       for t in touches{self.touchMoved(toPoint: t.location(in: self))}
    }
}
