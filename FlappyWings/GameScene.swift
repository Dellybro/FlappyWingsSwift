//
//  GameScene.swift
//  FlappyWings
//
//  Created by Travis Delly on 9/19/15.
//  Copyright (c) 2015 Travis Delly. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode();
    var bg = SKSpriteNode();
    var ground = SKNode();
    var score = 0;
    var ScoreLabel = SKLabelNode();
    var RestartLabel = SKLabelNode();
    
    var labelHolder = SKSpriteNode();
    
    let birdGroup:UInt32 = 1;
    let objGroup:UInt32 = 2;
    let gapGroup:UInt32 = 0 << 3;
    
    var movingObjects = SKNode();
    
    var gameOver = 0;
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self;
        self.addChild(movingObjects);
        //Gravity level of -5;
        //self.physicsWorld.gravity = CGVectorMake(0, -5);
        makeBackground();
        self.addChild(labelHolder);
        //Score Label:
        ScoreLabel.fontName = "Helvitica";
        ScoreLabel.fontSize = 60;
        ScoreLabel.zPosition = 11;
        ScoreLabel.text = "0";
        ScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70);
        
        
        //Skin textures
        var birdFlap = SKTexture(imageNamed: "flappy2");
        var birdTexture = SKTexture(imageNamed:"flappy1");
        
        //Animate the bird and sec an action to repeat forver
        var animation = SKAction.animateWithTextures([birdTexture, birdFlap], timePerFrame: 0.1);
        var makeBirdFlap = SKAction.repeatActionForever(animation);
        
        //Bird on middle of screen and using run action to run the SKAction.
        bird = SKSpriteNode(texture: birdTexture);
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
        bird.zPosition = 10;
        bird.runAction(makeBirdFlap);
        bird.physicsBody?.categoryBitMask = birdGroup;
        bird.physicsBody?.collisionBitMask = gapGroup;
        
        //Gravity
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2);
        bird.physicsBody?.dynamic = true;
        bird.physicsBody?.allowsRotation = true;
        
        
        //PipeStuff
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: ("makePipes"), userInfo: nil, repeats: true);
        
        
        //ground node.
        ground.position = CGPointMake(0, 0);
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width, 1));
        ground.physicsBody?.dynamic = false;
        ground.physicsBody?.categoryBitMask = objGroup;
        ground.physicsBody?.collisionBitMask = birdGroup;
        ground.physicsBody?.contactTestBitMask = birdGroup;
        
        
        self.addChild(ScoreLabel);
        self.addChild(ground);
        self.addChild(bird);
        
        
        
    }
    func makePipes(){
        
        if(gameOver == 0){
            //Pipe Math Logic
            let gapHeight = bird.size.height*4
            var movementAmmount = arc4random() % UInt32(self.frame.size.height / 2);
            var pipeOffset = CGFloat(movementAmmount) - self.frame.size.height / 4;
            //Pipe Movement
            var movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100));
            var removePipes = SKAction.removeFromParent();
            var moveAndRemovePipes = SKAction.sequence([movePipes, removePipes]);
            
            //Pipe creation
            //Pipeup
            var pipeUpTexture = SKTexture(imageNamed: "pipe1");
            var pipeUp = SKSpriteNode(texture: pipeUpTexture);
            pipeUp.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeUp.size.height/2 + gapHeight/2 + pipeOffset);
            pipeUp.runAction(moveAndRemovePipes);
            pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size);
            pipeUp.physicsBody?.dynamic = false;
            pipeUp.physicsBody?.categoryBitMask = objGroup;
            pipeUp.physicsBody?.collisionBitMask = birdGroup;
            pipeUp.physicsBody?.contactTestBitMask = birdGroup;
            //PipeDown
            var pipeDownTexture = SKTexture(imageNamed: "pipe2");
            var pipeDown = SKSpriteNode(texture: pipeDownTexture);
            pipeDown.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipeDown.size.height/2 - gapHeight / 2 + pipeOffset);
            pipeDown.runAction(moveAndRemovePipes);
            pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize: pipeDown.size);
            pipeDown.physicsBody?.dynamic = false;
            pipeDown.physicsBody?.categoryBitMask = objGroup;
            pipeDown.physicsBody?.collisionBitMask = birdGroup;
            pipeDown.physicsBody?.contactTestBitMask = birdGroup;
            
            var gap = SKNode();
            gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset);
            gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipeUp.size.width, gapHeight));
            gap.runAction(moveAndRemovePipes);
            gap.physicsBody?.dynamic = false;
            gap.physicsBody?.collisionBitMask = gapGroup;
            gap.physicsBody?.categoryBitMask = gapGroup;
            gap.physicsBody?.contactTestBitMask = birdGroup;
            
            
            //Add to moving Objects
            movingObjects.addChild(gap);
            movingObjects.addChild(pipeUp)
            movingObjects.addChild(pipeDown);
        }
    }
    func makeBackground(){
        //Add background texture
        var background = SKTexture(imageNamed: "bg");
        
        var moveBG = SKAction.moveByX(-background.size().width, y: 0, duration: 9);
        var repeatBackground = SKAction.moveByX(background.size().width, y: 0, duration: 0);
        var moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBG, repeatBackground]));
        
        for var i:CGFloat = 0 ; i < 3 ; i++ {
            //Loop Background
            bg = SKSpriteNode(texture: background);
            bg.position = CGPoint(x: background.size().width/2 + background.size().width * i, y: CGRectGetMidY(self.frame));
            bg.size.height = self.frame.height;
            
            
            bg.runAction(moveBackgroundForever);
            
            self.addChild(bg);
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if(gameOver == 0){
            bird.physicsBody?.velocity = CGVectorMake(0, 0);
            bird.physicsBody?.applyImpulse(CGVectorMake(0, 50));
        } else {
            score = 0;
            ScoreLabel.text = "0";
            
            movingObjects.removeAllChildren();
            makeBackground();
            gameOver = 0;
            labelHolder.removeAllChildren();
            bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
            movingObjects.speed = 1;
        }
        
        
        /* Called when a touch begins */
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if(contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup){
            
            score++;
            ScoreLabel.text = "\(score)";
        } else if(gameOver == 0){
            
            gameOver = 1;
            movingObjects.speed = 0;
            
            RestartLabel.fontName = "Helvitica";
            RestartLabel.fontSize = 30;
            RestartLabel.zPosition = 11;
            RestartLabel.text = "Game Over! Tap to play again.";
            RestartLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            RestartLabel.removeFromParent();
            labelHolder.addChild(RestartLabel);
            bird.physicsBody?.velocity = CGVectorMake(0, 0);
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
