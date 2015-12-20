//
//  GameScene.swift
//  Black Ninja
//
//  Created by Bade-Adebowale Kehinde  on 2015-10-31.
//  Copyright (c) 2015 kowries.inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var movingGround: KMovingGround!
    var hero: KHero!
    var cloudGenerator: KCloudGenerator!
    var wallGenerator: KWallGenerator!
    
    var isStarted = false
    var isGameOver = false
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor(red: 159.0/225.0, green: 201.0/255.0, blue: 244.0/256.0, alpha: 1.0)
        
       
        let backgroundTexture = SKTexture(imageNamed: "kd.jpg")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture, size: view.frame.size)
        backgroundImage.position = view.center
        addChild(backgroundImage)


        // add ground
        // SpriteNode is something you can put in a scene
        movingGround = KMovingGround(size: CGSizeMake(view.frame.width, kMLGroundHeight))
        movingGround.position = CGPointMake(0, view.frame.size.height/2)
        addChild(movingGround)
        
        // add hero
        hero = KHero()
        hero.position = CGPointMake(70, movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breathe()
        
        // add cloud generator
        cloudGenerator = KCloudGenerator(color: UIColor.clearColor(), size: view.frame.size)
        cloudGenerator.position = view.center
        addChild(cloudGenerator)
        cloudGenerator.populate(7)
        cloudGenerator.startGeneratingWithSpawnTime(4)
        
        //add wall generator
        wallGenerator = KWallGenerator(color: UIColor.clearColor(), size: view.frame.size)
        wallGenerator.position = view.center
        addChild(wallGenerator)
        
        // add start label
        let taptostartlabel = SKLabelNode(text: "Tap Screen to start")
        taptostartlabel.name = "taptostartlabel"
        
        taptostartlabel.position.x = view.center.x
        taptostartlabel.position.y = view.center.y + 40
        taptostartlabel.fontName = "Helvetica"
        taptostartlabel.fontColor = UIColor.blackColor()
        taptostartlabel.fontSize = 22.0
        
        addChild(taptostartlabel)
        
        // add physics world
        physicsWorld.contactDelegate = self
        
    }
    
    // MARK: - Game LifeCycle
    func start() {
        isStarted = true
        
        let taptostartlabel = childNodeWithName("taptostartlabel")
        taptostartlabel?.removeFromParent()
        
        hero.stop()
        hero.startRunning()
        movingGround.start()
        
        wallGenerator.startGeneratingWallsEvery(1)
    }
    
    func gameOver() {
        isGameOver = true
        
        //stop everything
        hero.physicsBody = nil
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        
        // create game over label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.redColor()
        gameOverLabel.fontName = "Helvatica"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 40
        gameOverLabel.fontSize = 22.0
        addChild(gameOverLabel)
        
    }
    
    func restart() {
        cloudGenerator.stopGenerating()
        
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .AspectFill
        
        view!.presentScene(newScene)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isGameOver {
            restart()
        }

        else if !isStarted {
            start()
        } else {
            hero.flip()
        }
    }
    

   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: SKPhysicsDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        gameOver()
        print("didBeginContactCalled")
    }
}
