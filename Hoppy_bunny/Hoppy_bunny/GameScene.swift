//
//  GameScene.swift
//  Hoppy_bunny
//
//  Created by Wiem Ben Rim on 12/28/16.
//  Copyright © 2016 WBR. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var hero: SKSpriteNode!
    var sinceTouch : CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 160
    var scrollLayer: SKNode!
    
    override func didMove(to view: SKView) {
        //We recursively look for 'hero', child of referenced node
        hero = self.childNode(withName: "//hero") as! SKSpriteNode
        /* Set reference to scroll layer node */
        scrollLayer = self.childNode(withName: "scrollLayer")
        
        
    }
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width/2) + ground.size.width, y: groundPosition.y)
                
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250)) //apply vertical impulse
        
        /* Apply subtle rotation */
        hero.physicsBody?.applyAngularImpulse(1)
        
        /* Reset touch timer */
        sinceTouch = 0
        
        
        /* Play SFX */
        let flapSFX = SKAction.playSoundFileNamed("sfx_flap", waitForCompletion: false)
        self.run(flapSFX)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //get current velocity 
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        /* Check and cap vertical velocity */
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        
        /* Apply falling rotation */
        if sinceTouch > 0.1 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        
        /* Clamp rotation */
        hero.zRotation = hero.zRotation.clamp(v1: CGFloat(-20).degreesToRadians(),CGFloat(30).degreesToRadians())
        
        hero.physicsBody?.angularVelocity = (hero.physicsBody?.angularVelocity.clamp(v1: -2, 2))!
        
        
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
        
        /* Process world scrolling */
        scrollWorld()
    }
}
