//
//  GameScene.swift
//  Dotter
//
//  Created by Preston Meade on 6/15/17.
//  Copyright © 2017 com.preston.xc. All rights reserved.
//

import SpriteKit
import GameplayKit

//TODO
//- fix placing dots... not allowed in preview *
//- fix collision based on radius *
//- add special proptiers
//- score starts at 100 || 200, decresases each x [tbd] seconds/milliseconds, encourganes fast paced game *
//- Score: add score increments!
//- add padding for the 5 preview blocks *
//- ensure all variabels reset on new game*
//- ending game/ new round!*


//- graphics/fonts:
//~ Font, get nice h0t font! must be readable
//~ Graphics, make cool/simple graphics
//~ Loading screen + Start menu screen
//- Music
// add place dot noise
//add game over noise
// add new game noise
// add implosion noise
// add explosion nosie
// add nice game melody

class GameScene: SKScene{
    
    private var adsOn = false;
    
    private var redPercent = 10
    private var greenPercent = 10
    private var bluePercent = 80
    
    
    private var tapToStart : SKLabelNode?
    private var tapped = false
    
    private var RADIUS : CGFloat = 40
    
    private var firstDot = true
    
    private var dot : SKShapeNode?
    private var explodingDot : SKShapeNode?
    private var implosionDot : SKShapeNode?
    
    private var dots = [SKShapeNode]()
    private var upcomingDots = [SKShapeNode]()
    
    private var gameOver = false
    private var score = 0
    private var highscore = 0
    private var scoreLabel = SKLabelNode(text: "0")
    private var gameEndLabel = SKLabelNode(text: "Round Over :( Tap To Play Again")
    
    private var gameTimer : Timer!
    
    private var timeSinceTouch = 0.0
    private var maxScorePerTouch = 500
    
    private var previewBox : SKSpriteNode?
    private var background : SKSpriteNode?
    
    private var mainMenuButton : SKSpriteNode?
    private var mainMenuLabel : SKLabelNode?
    private var playAgainLabel : SKLabelNode?
    
    private var statBox : SKSpriteNode?
    
    
    
    override func didMove(to view: SKView) {
        
        
        
        // Get label node from scene and store it for use later
        
        gameTimer =  Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.handleTime), userInfo: nil, repeats: true)
        
        self.background?.color = SKColor.white
        
        gameEndLabel.zPosition = 100
        gameEndLabel.fontColor = SKColor.white
        gameEndLabel.fontSize = 90
        gameEndLabel.fontName = "OrangeKid-Regular"
        gameEndLabel.position = CGPoint(x: 0, y: self.frame.maxY - 300)
        
        gameEndLabel.isHidden = true;
        self.addChild(gameEndLabel)
        
        scoreLabel.zPosition = 100
        scoreLabel.fontName =  "OrangeKid-Regular"
        scoreLabel.fontSize = 80
        scoreLabel.position = CGPoint(x: self.frame.minX + 40, y: self.frame.maxY - 80)
        self.addChild(scoreLabel)
        
        statBox = SKSpriteNode(imageNamed: "roundStats")
        statBox?.position = CGPoint(x: 0, y: 300)
        statBox?.isHidden = true
        statBox?.zPosition = 110
        
        // self.addChild(statBox!)
        //statBox?.addChild(gameEndLabel)
        
        
        var xAdDisplace : CGFloat = 0.0
        if(adsOn){
            xAdDisplace = 100.0
        }
        
        self.tapToStart = SKLabelNode(text: "Tap To Place A Dot!!!")
        self.tapToStart?.isHidden = true
        self.tapToStart?.fontName = "OrangeKid-Regular"
        self.tapToStart?.fontSize = 70
        
        self.tapToStart?.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 0.6, duration: 0.7), SKAction.scale(to: 1, duration: 0.7) ])))
        
        self.tapToStart?.run(SKAction.repeatForever(SKAction.sequence([ SKAction.fadeOut(withDuration: 0.7), SKAction.fadeIn(withDuration: 0.7)])))
        
        
        self.addChild((tapToStart)!)
        
        self.previewBox = SKSpriteNode(color: SKColor.gray, size: CGSize(width: self.frame.width, height: 150))
        self.previewBox?.position = CGPoint(x: 0, y: self.frame.minY + ((self.previewBox?.frame.height)! / 2) + (xAdDisplace))
        self.previewBox?.texture = SKTexture(imageNamed: "whiteBox.png")
        self.previewBox?.zPosition = -100
        self.addChild((previewBox)!)
        
        self.mainMenuButton = SKSpriteNode(color: SKColor.white, size: CGSize(width: 250, height: 150))
        self.mainMenuButton?.isHidden = true
        self.mainMenuButton?.texture = SKTexture(imageNamed: "playAgainButton.png")
        self.mainMenuButton?.position = CGPoint(x: 0, y: -100)
        // self.addChild(mainMenuButton!)
        
        self.mainMenuLabel = SKLabelNode(text: "Main Menu")
        self.mainMenuLabel?.isHidden = true
        self.mainMenuLabel?.position = CGPoint(x: 0, y: -340)
        self.mainMenuLabel?.color = SKColor.blue
        self.mainMenuLabel?.fontName = "OrangeKid-Regular"
        self.mainMenuLabel?.zPosition = 200
        self.mainMenuLabel?.fontSize = 90
        self.addChild(mainMenuLabel!)
        
        mainMenuLabel?.run(SKAction.playSoundFileNamed("roundEnd", waitForCompletion: true))
        
        
        self.playAgainLabel = SKLabelNode(text: "Play Again")
        self.playAgainLabel?.isHidden = true
        self.playAgainLabel?.color = SKColor.blue
        self.playAgainLabel?.fontName = "OrangeKid-Regular"
        self.playAgainLabel?.zPosition = 200
        self.playAgainLabel?.fontSize = 180
        self.playAgainLabel?.position = CGPoint(x: 0, y: -50)
        self.addChild(playAgainLabel!)
        
        // fillScreen()
        self.dot = SKShapeNode.init(circleOfRadius: RADIUS)
        self.explodingDot = SKShapeNode.init(circleOfRadius: RADIUS)
        self.implosionDot = SKShapeNode.init(circleOfRadius: RADIUS)
        
        
        if let explosion = self.dot {
            explosion.position = CGPoint(x: 0, y: 0)
            explosion.name = "explosion"
            explosion.fillColor = SKColor.red
            explosion.zPosition = 0
            explosion.lineWidth = 0
            
        }
        if let implosion = self.dot {
            implosion.position = CGPoint(x: 0, y: 0)
            implosion.name = "implosion"
            implosion.fillColor = SKColor.green
            implosion.zPosition = 0
            
        }
        if let dot = self.dot {
            dot.position = CGPoint(x: 0, y: 0)
            dot.name = "dot"
            dot.fillColor = SKColor.blue
            dot.zPosition = 0
            
        }
        
        loadHighscore()
        newRound()
    }
    
    func randomChance(){
        redPercent = Int(arc4random_uniform(20))
        greenPercent = Int(arc4random_uniform(20))
        bluePercent = Int(arc4random_uniform(60))
    }
    
    func handleTime(){
        timeSinceTouch += 0.1
    }
    
    func addToScore(score : Int){
        var scoreFloatLabel = SKLabelNode(text: "+\(score)")
        scoreFloatLabel.position = CGPoint(x: scoreLabel.position.x + 40, y: scoreLabel.position.y - 65 )
        scoreFloatLabel.color = SKColor.green
        // self.addChild(scoreFloatLabel)
        scoreFloatLabel.run(SKAction.scale(to: 0, duration: 1))
        
        scoreFloatLabel.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 65, duration: 1), SKAction.run({
            scoreFloatLabel.removeFromParent()
            }
            )]))
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 0), SKAction.run({
            self.score += Int(score)
            self.scoreLabel.text = "\(self.score)"
            
        })  ]))
    }
    
    func generateDot()  {
        var dotNum = arc4random_uniform(100)
        
        
        
        
        var rDot = SKShapeNode.init(circleOfRadius: RADIUS)
        var dotPicked = false
        
        while (dotPicked == false){
            
            dotNum = arc4random_uniform(100)
            
            if(dotNum < 50){
                rDot.name = "dot"
                rDot.setScale(0.5)
                
                rDot.fillColor = SKColor.blue
                dotPicked = true
                // rDot.fillTexture = SKTexture(imageNamed: "blueDot")
                
                
            }else if (dotNum < 85){
                rDot.name = "explosion"
                rDot.fillColor = SKColor.red
                dotPicked = true
                
                // rDot.fillTexture = SKTexture(imageNamed: "redDot")
                
            }else if (dotNum < 100 && !firstDot){
                rDot.name = "implosion"
                rDot.fillColor = SKColor.green
                rDot.setScale(0.75)
                
                dotPicked = true
                
                // rDot.fillTexture = SKTexture(imageNamed: "greenDot")
                
            }
            
        }
        
        if(firstDot){
            firstDot = false
        }
        rDot.lineWidth = 0
        
        upcomingDots.append(rDot)
    }
    
    func populateDots(){
        for i in 0..<100 {
            
            generateDot()
        }
    }
    
    func showUpcomingDots(){
        var widthPerBox = self.frame.width / 5
        var paddingPerbox = (widthPerBox - (80)) / 2
        var center = paddingPerbox + RADIUS
        
        var heightPerBox = self.previewBox?.frame.height
        var paddingPerHeight = (heightPerBox! - (80)) / 2
        var centerHeight = paddingPerHeight + RADIUS
        var centerY = (self.previewBox?.position.y)!
        
        for i in 0..<6 {
            var curDot = upcomingDots[i]
            curDot.setScale(0)
            curDot.position = CGPoint(x: self.frame.minX + (center * CGFloat(i) * 2) + center, y: centerY)
            
            if(curDot.name == "dot"){
                curDot.run(SKAction.scale(to: 0.5, duration: 0.5))
                
            }
            
            if(curDot.name == "explosion"){
                curDot.run(SKAction.scale(to: 1, duration: 0.5))
                
            }
            if(curDot.name == "implosion"){
                curDot.run(SKAction.scale(to: 0.75, duration: 0.5))
                
            }
            self.addChild(curDot)
        }
    }
    
    
    func shiftPreviewDots(){
        
        var widthPerBox = self.frame.width / 5
        var paddingPerbox = (widthPerBox - (80)) / 2
        var center = paddingPerbox + RADIUS
        
        
        var heightPerBox = self.previewBox?.frame.height
        var paddingPerHeight = (heightPerBox! - (80)) / 2
        var centerHeight = paddingPerHeight + RADIUS
        var centerY = (self.previewBox?.position.y)!
        
        
        
        var d = upcomingDots[5]
        
        d.position = CGPoint(x: self.frame.minX + center + (center * CGFloat(5) * 2 ) , y: centerY)
        self.addChild(d)
        for i in 0..<5 {
            upcomingDots[i].run(SKAction.moveBy(x: -1 * (   (center * CGFloat(1) * 2 )), y: 0, duration: 1))
        }
    }
    /*
     func fillScreen(){
     var toAdd = 120;
     for i in 0..<toAdd {
     
     var d = SKShapeNode.init(circleOfRadius: RADIUS)
     print("adding")
     d.position = getRandomPos()
     d.fillColor = getRandomColor()
     dots.append(d)
     self.addChild(d)
     
     }
     
     }
     */
    
    /*
     func getRandomPos() -> CGPoint {
     
     //add random coordiantes lol
     return CGPoint(x: x, y: y)
     
     }*/
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    func changeColorRandom(){
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        var c =  UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
        for dot in dots {
            dot.fillColor = c
        }
        
        
    }
    func checkTouching(){
        
        if (dots.count > 0){
            
            var lastDot = dots[dots.count - 1]
            var toDelete : [SKShapeNode] = []
            var cleared = false;
            
            for i in 0..<(dots.count - 1){
                
                
                
                
                if (dots[i].intersects(lastDot)){
                    
                    
                    var possibleIntersect = dots[i]
                    var distanceY = (possibleIntersect.position.y - lastDot.position.y)
                    var distanceX = ( possibleIntersect.position.x - lastDot.position.x)
                    var distance = ( (distanceX * distanceX) + ( distanceY * distanceY)).squareRoot()
                    
                    print("y2: \(possibleIntersect.position.y)")
                    print("y1: \(lastDot.position.y)")
                    
                    print("x2: \(possibleIntersect.position.x)")
                    print("x1: \(lastDot.position.x)")
                    
                    
                    print("possible hit: checking distance of between radius and pos")
                    print(distance)
                    if (distance < (getRadius(d: possibleIntersect) + getRadius(d: lastDot)) ){
                        
                        if(possibleIntersect.zRotation != 1 ){
                            
                            if(lastDot.name == "implosion" || possibleIntersect.alpha == 0.99){
                                
                                lastDot.run(SKAction.scale(to: 0, duration: 0.5))
                                lastDot.zRotation = 1
                                // possibleIntersect.run(SKAction.scale(to: 0, duration: 0.5))
                                possibleIntersect.alpha = 0.99
                                toDelete.append(possibleIntersect)
                                toDelete.append(lastDot)
                                cleared = true
                            }else{
                                
                                lastDot.fillColor = SKColor.yellow
                                gameOver = true
                                break
                            }
                        }
                    }
                    
                    
                }
                
                
            }
            
            var deleted = (toDelete.count / 2) + 1
            if (!cleared) {
                
            }
            print("TO DELETE \(deleted)")
            for t in toDelete {
                
                t.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.5), SKAction.run {
                    t.removeAllActions()
                    t.removeFromParent()
                    }]))
            }
            toDelete.removeAll()
            
            if (gameOver){
                lose()
            }else{
                var scoreToAdd = Double(maxScorePerTouch) - (timeSinceTouch * 10)
                if(scoreToAdd < 0){
                    scoreToAdd = 0
                }
                
                addToScore(score: Int(deleted))
                
                timeSinceTouch = 0.0
                
            }
            
            
        }
        
    }
    
    func changeAllTo(color: SKColor){
        for d in dots {
            d.fillColor = color
        }
    }
    
    
    func saveHighscore(){
        
        if(score > highscore) {
            let defaults = UserDefaults.standard
            defaults.set(score, forKey: "highscore")
            highscore = score
        }
        
        
    }
    
    func loadHighscore(){
        let defaults = UserDefaults.standard
        
        highscore = defaults.integer(forKey: "highscore")
        
        
        
    }
    func lose(){
        mainMenuLabel?.run(SKAction.playSoundFileNamed("roundEnd.mp3", waitForCompletion: true))
        
        gameOver = true;
        gameEndLabel.isHidden = false;
        statBox?.isHidden = false
        
        saveHighscore()
        
        gameEndLabel.text = "Score: \(score)\t Highscore: \(highscore)"
        gameEndLabel.color = SKColor.black
        
        //gameEndLabel.setScale(0)
        //gameEndLabel.run(SKAction.scale(to: 1, duration: 2))
        //  gameEndLabel.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        
        mainMenuButton?.isHidden = false
        mainMenuButton?.setScale(0)
        mainMenuButton?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        
        mainMenuLabel?.isHidden = false
        playAgainLabel?.isHidden = false
        
        for d in self.dots {
            //d.run(SKAction.rotate(byAngle: 3.14, duration: 3))
            //d.run(SKAction.scale(to: 0, duration: 3))
            //d.run(SKAction.fadeOut(withDuration: 2))
            d.alpha = 0.4
        }
        
        
        
        print(gameOver)
    }
    
    func showStart(){
        if(!tapped) {
            tapToStart?.isHidden = false
        }
    }
    
    func newRound(){
        showStart()
        randomChance()
        firstDot = true
        timeSinceTouch = 0.0
        self.removeChildren(in: self.dots)
        self.removeChildren(in: self.upcomingDots)
        self.dots.removeAll()
        
        self.score = 0
        self.scoreLabel.text = "\(Int(self.score))"
        self.gameEndLabel.isHidden = true
        self.mainMenuButton?.isHidden = true
        self.mainMenuLabel?.isHidden = true
        self.playAgainLabel?.isHidden = true
        self.statBox?.isHidden = true
        self.dots.removeAll()
        self.gameOver = false
        
        upcomingDots.removeAll()
        populateDots()
        showUpcomingDots()
    }
    
    func getRadius(d : SKShapeNode) -> CGFloat{
        var rad : CGFloat = 0
        if(d.name == "dot"){
            rad =  40
        }else if (d.name == "explosion"){
            rad = 80
        }else if (d.name == "implosion"){
            rad = 60
        }
        return rad
    }
    
    func adjustSize(nextDot : SKShapeNode){
        if(nextDot.name == "dot"){
            nextDot.setScale(1)
        }else if(nextDot.name == "explosion"){
            nextDot.setScale(2)
        }else if (nextDot.name == "implosion"){
            nextDot.setScale(1.5)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        if (!gameOver){
            print("TAPPING")
            print(self.previewBox?.position.y)
            print(self.frame.minY)
            
            
            var minYDraw = self.frame.minY + (self.previewBox?.frame.height)!
            
            var nextDot = upcomingDots[0]
            
            
            if(pos.y - (getRadius(d: nextDot)) > minYDraw){
                if(tapped == false) {
                    tapped == true
                    tapToStart?.isHidden = true
                }
                
                adjustSize(nextDot : nextDot)
                
                nextDot.removeAllActions()
                nextDot.position = pos
                nextDot.run(SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: true))
                nextDot.lineWidth = 1
                dots.append(nextDot)
                print(dots.count)
                checkTouching()
                
                upcomingDots.remove(at: 0)
                shiftPreviewDots()
                generateDot()
                //showUpcomingDots()
            }
            
            
        }else if (mainMenuLabel?.contains(pos))!{
            
            if let view = self.view as! SKView? {
                self.run(SKAction.playSoundFileNamed("blop.mp3", waitForCompletion: true))
                
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "Menu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    print("SHOWING SCENE")
                    // Present the scene
                    view.presentScene(scene)
                }
            }
        }else{
            print("ELSE")
            newRound()
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //  for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
