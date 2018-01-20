//
//  Menu.swift
//  Dotter
//
//  Created by Preston Meade on 6/19/17.
//  Copyright © 2017 com.preston.xc. All rights reserved.
//

import SpriteKit
import GameplayKit

class Menu: SKScene {
    
    var gameLabel = SKLabelNode(text: "Dotter")
    
    var playButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 450, height: 180))
    var playLabel = SKLabelNode(text: "PLAY")
    
    var hiScoresButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 337, height: 135))
    var hiscoreLabel = SKLabelNode(text: "ABOUT")
    
    override func didMove(to view: SKView) {
        print("SCENE 2")
        
        gameLabel.position = CGPoint(x: 0, y: self.frame.maxY - (self.frame.height / 3))
        gameLabel.fontSize = 200
        gameLabel.zPosition = 100
        
        gameLabel.fontName = "OrangeKid-Regular"
        self.addChild(gameLabel)
        
        playButton.position = CGPoint(x: 0, y: -100)
        playButton.texture = SKTexture(imageNamed: "button")
        
        playLabel.position.x = playButton.position.x
        playLabel.position.y = playButton.position.y - (playLabel.frame.height )
        playLabel.fontName =  "OrangeKid-Regular"
        playLabel.fontSize = 100
        playLabel.zPosition = 100
        
        self.addChild(playButton)
        
        self.addChild(playLabel)
        
        
        hiScoresButton.position = CGPoint(x: 0, y: -400)
        hiScoresButton.texture = SKTexture(imageNamed: "button")
        
        hiscoreLabel.position.x = hiScoresButton.position.x
        hiscoreLabel.position.y = hiScoresButton.position.y - (hiscoreLabel.frame.height / 2 )
        
        hiscoreLabel.fontName =  "OrangeKid-Regular"
        hiscoreLabel.fontSize = 50
        hiscoreLabel.zPosition = 100
        self.addChild(hiScoresButton)
        
        self.addChild(hiscoreLabel)
        
        let defaults = UserDefaults.standard
        defaults.set("Some String Value", forKey: "1")
        defaults.set("Another String Value", forKey: "2")
        
        // Getting
        
        
    }
    
    func animateBackground(){
        
    }
    
    
    func touchDown(atPoint pos : CGPoint){
        if(playButton.contains(pos)){
            playButton.run(SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: true))
            playButton.run(SKAction.sequence([SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: false), SKAction.run {
                self.playButton.texture = SKTexture(imageNamed: "p.png")
                },SKAction.wait(forDuration: 0.15),SKAction.run {
                    self.playButton.texture = SKTexture(imageNamed: "button.png")
                    
                },SKAction.wait(forDuration: 0.05) ,SKAction.run {
                    if let view = self.view as! SKView? {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = SKScene(fileNamed: "GameScene") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            print("SHOWING SCENE")
                            // Present the scene
                            view.presentScene(scene)
                        }
                        
                    }
                } ]))
            
        }else if(hiScoresButton.contains(pos)){
            
            hiScoresButton.run(SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: true))
            hiScoresButton.run(SKAction.sequence([SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: false), SKAction.run {
                self.hiScoresButton.texture = SKTexture(imageNamed: "p.png")
                },SKAction.wait(forDuration: 0.15),SKAction.run {
                    self.hiScoresButton.texture = SKTexture(imageNamed: "button.png")
                    
                },SKAction.wait(forDuration: 0.05) ,SKAction.run {
                    
                    
                    
                    if let view = self.view as! SKView? {
                        // Load the SKScene from 'GameScene.sks'
                        if let scene = SKScene(fileNamed: "About") {
                            // Set the scale mode to scale to fit the window
                            scene.scaleMode = .aspectFill
                            print("SHOWING SCENE")
                            // Present the scene
                            view.presentScene(scene)
                        }
                        
                    }
                    
                } ]))
            
            var url: NSURL = NSURL(string: "http://cookiesinthebag.com/process.php")!
            var request :NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
            
            request.httpMethod = "POST"
            // request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
            {
                (response, data, error) in
                print(response)
                
            }
            
            let defaults = UserDefaults.standard
            if let stringOne = defaults.string(forKey: "1") {
                print(stringOne) // Some String Value
            }
            if let stringTwo = defaults.string(forKey: "2") {
                print(stringTwo) // Another String Value
            }
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
