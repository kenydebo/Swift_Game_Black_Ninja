//
//  K_Hero.swift
//  Black Ninja
//
//  Created by Bade-Adebowale Kehinde  on 2015-10-31.
//  Copyright © 2015 kowries.inc. All rights reserved.
//

import Foundation
import SpriteKit

class KHero: SKSpriteNode {
    
    var body: SKSpriteNode!
    var arm: SKSpriteNode!
    var leftfoot: SKSpriteNode!
    var rightfoot: SKSpriteNode!
    
    var isUpsideDown = false
    
     init()
    {
        let size = CGSizeMake(32, 44)
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(32, 44))
        
        loadAppearance()
        loadPhysicsBodyWithSize(size)
     
    }
    
    func loadAppearance() {
        
        body = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(32, 40))
        body.position = CGPointMake(0, 2)
        addChild(body)
        
        let skinColor = UIColor(red: 207.0/255.0, green: 193.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        let face = SKSpriteNode(color: skinColor, size: CGSizeMake(self.frame.size.width, 12))
        face.position = CGPointMake(0, 6)
        body.addChild(face)
        
        let eyeColor = UIColor.whiteColor()
        let leftEye = SKSpriteNode(color: eyeColor, size: CGSizeMake(6, 6))
        let rightEye = leftEye.copy() as! SKSpriteNode
        let pupil = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(3, 3))
        
        pupil.position = CGPointMake(2, 0)
        leftEye.addChild(pupil)
        rightEye.addChild(pupil.copy() as! SKSpriteNode)
        
        leftEye.position = CGPointMake(-4, 0)
        face.addChild(leftEye)
        
        rightEye.position = CGPointMake(14, 0)
        face.addChild(rightEye)
        
        let eyeBrow = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(11, 1))
        eyeBrow.position = CGPointMake(-1, leftEye.size.height/2)
        leftEye.addChild(eyeBrow)
        rightEye.addChild(eyeBrow.copy() as! SKSpriteNode)
        
        let armColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        arm = SKSpriteNode(color: armColor, size: CGSizeMake(0, 14))
        arm.anchorPoint = CGPointMake(0.5, 0.9)
        arm.position = CGPointMake(-10, -7)
        body.addChild(arm)
        
        let hand = SKSpriteNode(color: skinColor, size: CGSizeMake(arm.size.width, 5))
        hand.position = CGPointMake(0, -arm.size.height * 0.9 + hand.size.height/2)
        arm.addChild(hand)
        
        leftfoot = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(9, 4))
        leftfoot.position = CGPointMake(-6, -size.height/2 + leftfoot.size.height/2)
        addChild(leftfoot)
        
        rightfoot = leftfoot.copy() as! SKSpriteNode
        rightfoot.position.x = 9
        addChild(rightfoot)
        
    }
    
    func loadPhysicsBodyWithSize(size: CGSize) {
        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.categoryBitMask = heroCategory
        physicsBody?.contactTestBitMask = wallCategory
        physicsBody?.affectedByGravity = false
        // physicsBody are affected by gravity by default
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flip() {
       
        isUpsideDown = !isUpsideDown
        
        var scale: CGFloat
        
        if isUpsideDown {
            scale = -1.0
        }
        else {
         scale = 1.0
        }
        let translate = SKAction.moveByX(0, y: scale*(size.height + kMLGroundHeight), duration: 0.1)
        let flip = SKAction.scaleXTo(scale, duration: 0.1)
        
        runAction(translate)
        runAction(flip)
    }
    
    func startRunning() {
        let rotateBack = SKAction.rotateByAngle(-CGFloat(M_PI)/2.0, duration: 0.1)
        arm.runAction(rotateBack)
        
        performOneRunCycle()
    }
    func performOneRunCycle() {
        let up = SKAction.moveByX(0, y: 2, duration: 0.05)
        let down = SKAction.moveByX(0, y: -2, duration: 0.05)
        
        leftfoot.runAction(up) { () -> Void in
            self.leftfoot.runAction(down)
            self.rightfoot.runAction(up, completion: { () -> Void in
                self.rightfoot.runAction(down, completion: { () -> Void in
                    self.performOneRunCycle()
                })
            })
        }
    }
    func breathe() {
        let breatheOut = SKAction.moveByX(0, y: -2, duration: 1)
        let breatheIn = SKAction.moveByX(0, y: 2, duration: 1)
        let breath = SKAction.sequence([breatheOut, breatheIn])
        body.runAction(SKAction.repeatActionForever(breath))
    }
    
    func stop() {
        body.removeAllActions()
        leftfoot.removeAllActions()
        rightfoot.removeAllActions()
    }
}
