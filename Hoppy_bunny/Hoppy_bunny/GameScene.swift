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
    
    override func didMove(to view: SKView) {
        //We recursively look for 'hero', child of referenced node
        hero = self.childNode(withName: "//hero") as! SKSpriteNode
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
    }
}
