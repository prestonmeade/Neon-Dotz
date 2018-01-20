//
//  Menu.swift
//  Dotter
//
//  Created by Preston Meade on 6/19/17.
//  Copyright © 2017 com.preston.xc. All rights reserved.
//

import SpriteKit
import GameplayKit

class About: SKScene {
    
    var backButton = SKSpriteNode(imageNamed: "button.png")
    var label = SKLabelNode(text: "Menu")
    var about = SKSpriteNode(imageNamed: "aboutImage2.png")
    
    override func didMove(to view: SKView) {
        
        about.zPosition = 0
        about.size = self.frame.size
        self.addChild(about)
        
        backButton.zPosition = 1
        backButton.position.y = self.frame.minY + 200
        label.fontName = "OrangeKid-Regular"
        label.fontSize = 50
        
        self.addChild(backButton)
        
        self.addChild(label)
        label.zPosition = 100
        label.position.y = backButton.position.y - 15
        
    }
    
    
    
    
    func touchDown(atPoint pos : CGPoint){
        
        if(backButton.contains(pos)){
            backButton.run(SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: true))
            backButton.run(SKAction.sequence([SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: false), SKAction.run {
                
                self.backButton.texture = SKTexture(imageNamed: "p.png")
                
                },SKAction.wait(forDuration: 0.15),SKAction.run {
                    self.backButton.texture = SKTexture(imageNamed: "button.png")
                    
                    
                },SKAction.wait(forDuration: 0.05) ,SKAction.run {
                    if let view = self.view as! SKView? {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = SKScene(fileNamed: "Menu") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            print("SHOWING SCENE")
                            // Present the scene
                            view.presentScene(scene)
                        }
                        
                    }
                } ]))
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
}
