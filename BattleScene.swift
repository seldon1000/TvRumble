//
//  BattleScene.swift
//  TVRumbleTest1
//
//  Created by Nicolas Mariniello && Fabio Friano on 05/04/2020.
//

import SpriteKit
import AVFoundation

class BattleScene: SKScene, SKPhysicsContactDelegate {
    private var waitToJump = false
    private var waitToShoot = false
    private var waitToShooten = false
    private var waitToShootenCrouch = false
    private var waitToWalken = false
    private var waitToCrouchen = false
    var audioPlayer = AVAudioPlayer()
    var mute = false
    private var soundbutton = SKSpriteNode()
    
    private var player = SKSpriteNode()
    private var jumpbutton = SKSpriteNode()
    private var crouchbutton = SKSpriteNode()
    private var shootbutton = SKSpriteNode()
    private var item = SKSpriteNode()
    private var enemy = SKSpriteNode()
    private var enemyitem = SKSpriteNode()
    private var healthbar = SKSpriteNode()
    private var healthbaren = SKSpriteNode()
    private var coefimpulse = CGVector(dx: 0, dy: 0)
    private var encoefimpulse = CGVector(dx: 0, dy: 0)
    private var hp = 1000
    private var enhp = 1000
    var p = ""
    var e = ""
    private var phis = SKPhysicsBody()
    private var phisen = SKPhysicsBody()
    private var phisdefault = SKPhysicsBody()
    private var phisendefault = SKPhysicsBody()
    private var characterName = SKLabelNode()
    private var opponentName = SKLabelNode()
    private var blink = SKAction ()
    private var sec = Calendar.current.component(.second, from: Date())
    private var min = Calendar.current.component(.minute, from: Date())
    
    private var actions = [SKAction()]
    private var enemyactions = [SKAction()]
    
    private var impactp = SKAction()
    private var impacte = SKAction()
    private var scream = SKAction()
    private var explosion = SKEmitterNode()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        soundbutton = childNode(withName: "soundbutton") as! SKSpriteNode
        
        healthbar = childNode(withName: "healthbar")! as! SKSpriteNode
        healthbaren = childNode(withName: "healthbaren") as! SKSpriteNode
        jumpbutton = childNode(withName: "jumpbutton") as! SKSpriteNode
        crouchbutton = childNode(withName: "crouchbutton") as! SKSpriteNode
        shootbutton = childNode(withName: "shootbutton") as! SKSpriteNode
        
        characterName = childNode(withName: "characterName") as! SKLabelNode
        opponentName = childNode(withName: "opponentName") as! SKLabelNode
        
        player = SKSpriteNode(imageNamed: "\(p)standard")
        player.position = CGPoint(x: size.width * 0.3, y: size.height * 0.3)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.mass = 4
        player.physicsBody?.categoryBitMask = 4
        player.physicsBody?.collisionBitMask = 56
        player.physicsBody?.contactTestBitMask = 8
        addChild(player)
        phisdefault = player.physicsBody!
        
        enemy = SKSpriteNode(imageNamed: "\(e)enstandard")
        enemy.position = CGPoint(x: size.width * 0.8, y: size.height * 0.3)
        enemy.zPosition = 1
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.restitution = 0.0
        enemy.physicsBody?.mass = 4
        enemy.physicsBody?.categoryBitMask = 2
        enemy.physicsBody?.collisionBitMask = 49
        enemy.physicsBody?.contactTestBitMask = 1
        addChild(enemy)
        phisendefault = enemy.physicsBody!
        
        actions.append(SKAction(named: "\(p)back")!)
        actions.append(SKAction(named: "\(p)jump")!)
        actions.append(SKAction(named: "\(p)crouch")!)
        actions.append(SKAction(named: "\(p)shoot")!)
        actions.append(SKAction(named: "\(p)forward")!)
        
        enemyactions.append(SKAction(named: "\(e)enback")!)
        enemyactions.append(SKAction(named: "\(e)enforward")!)
        enemyactions.append(SKAction(named: "\(e)encrouch")!)
        enemyactions.append(SKAction(named: "\(e)enshoot")!)
        enemyactions.append(SKAction(named: "\(e)enjump")!)
        blink = SKAction.sequence([SKAction.fadeAlpha(to: 1, duration: 0.1),SKAction.fadeAlpha(to: 0, duration: 0.1)])
        
        switch p {
            case "ww":
                characterName.text = "The Chemist"
                item = SKSpriteNode(imageNamed: "chem")
                item.physicsBody = SKPhysicsBody(rectangleOf: item.size)
//                item.physicsBody = SKPhysicsBody(texture: item.texture!, size: item.size) //usare rettangoli come alternativa per risolvere "could not create phisics body
//                coefimpulse = CGVector(dx: 150, dy: 200)
                coefimpulse = CGVector(dx: 80, dy: 130)
                item.physicsBody?.mass = 0.1
                phis = SKPhysicsBody(rectangleOf: SKSpriteNode(texture: SKTexture(imageNamed: "\(p)difesafix1")).size)
                
            case "pablo":
                characterName.text = "Pablo"
                item = SKSpriteNode(imageNamed: "bullet")
                item.physicsBody = SKPhysicsBody(rectangleOf: item.size)
//                item.physicsBody = SKPhysicsBody(texture: item.texture!, size: item.size)
                item.physicsBody?.affectedByGravity = false
                item.physicsBody?.allowsRotation = false
                coefimpulse = CGVector(dx: 180, dy: 0)
                phis = SKPhysicsBody(texture: SKTexture(imageNamed: "\(p)difesa"), size: SKSpriteNode(texture: SKTexture(imageNamed: "\(p)standard")).size)
         
            default:
                break
        }
        
        switch e {
            case "ww":
                opponentName.text = "The Chemist"
                enemyitem = SKSpriteNode(imageNamed: "chem")
                enemyitem.physicsBody = SKPhysicsBody(rectangleOf: enemyitem.size)
//                enemyitem.physicsBody = SKPhysicsBody(texture: enemyitem.texture!, size: enemyitem.size)
//                encoefimpulse = CGVector (dx: -150, dy: 1300)
                encoefimpulse = CGVector (dx: -80, dy: 130)
                enemyitem.physicsBody?.mass = 0.1
                phisen = SKPhysicsBody(rectangleOf: SKSpriteNode(texture: SKTexture(imageNamed: "\(e)endifesafix1")).size)
            
            case "pablo":
                opponentName.text = "Pablo"
                enemyitem = SKSpriteNode(imageNamed: "enbullet")
                enemyitem.physicsBody = SKPhysicsBody(rectangleOf: enemyitem.size)
//                enemyitem.physicsBody = SKPhysicsBody(texture: enemyitem.texture!, size: enemyitem.size)
                enemyitem.physicsBody?.affectedByGravity = false
                enemyitem.physicsBody?.allowsRotation = false
                encoefimpulse = CGVector (dx: -180, dy: 0)
                phisen = SKPhysicsBody(texture: SKTexture(imageNamed: "\(e)endifesa"), size: SKSpriteNode(texture: SKTexture(imageNamed: "\(e)enstandard")).size)
            
            default:
                break
        }
        
        item.zPosition = 1
        item.physicsBody?.categoryBitMask = 1
        item.physicsBody?.collisionBitMask = 2
        item.physicsBody?.contactTestBitMask = 34
        
        enemyitem.zPosition = 1
        enemyitem.physicsBody?.categoryBitMask = 8
        enemyitem.physicsBody?.collisionBitMask = 4
        enemyitem.physicsBody?.contactTestBitMask = 36
        
        phis.allowsRotation = false
        phis.restitution = 0
        phis.mass = 4
        
        phisen.allowsRotation = false
        phisen.restitution = 0
        phisen.mass = 4
        
        impactp = SKAction.playSoundFileNamed("Sounds/\(p)ImpactSound", waitForCompletion: false)
        impacte = SKAction.playSoundFileNamed("Sounds/\(e)ImpactSound", waitForCompletion: false)
        scream = SKAction.playSoundFileNamed("Sounds/painSoundMan", waitForCompletion: false)
        
        if mute {
            soundbutton.texture = SKTexture(imageNamed: "soundbuttonmuted")
        }
    }
        
    func shootfun(){
        item.position = CGPoint(x: player.position.x * 1.1, y: player.position.y * 1.2)
        addChild(item)
        item.physicsBody?.applyImpulse(coefimpulse)
        
        run(SKAction.playSoundFileNamed("Sounds/\(p)throw", waitForCompletion: false))
        player.texture = SKTexture(imageNamed: "\(p)standard")

        if (Int.random(in: 0..<2)) == 1 {
            waitToShootenCrouch = true
            waitToWalken = true
            
            enemy.physicsBody = phisen
            if e == "ww" {
                enemy.position.y *= 0.2
            }
            enemy.run(enemyactions[3], completion:{
                self.enemy.texture = SKTexture (imageNamed: "\(self.e)enstandard")
                self.enemy.physicsBody = self.phisendefault
                self.waitToWalken = false
                self.waitToShootenCrouch = false
            })
        }
    }
    
    func enshootfun() {
        enemyitem.position = CGPoint(x: enemy.position.x, y: enemy.position.y * 1.2)
        addChild(enemyitem)
        enemyitem.physicsBody?.applyImpulse(encoefimpulse)
        
        run(SKAction.playSoundFileNamed("Sounds/\(e)throw", waitForCompletion: false))
        enemy.texture = SKTexture(imageNamed: "\(e)enstandard")
        
        waitToCrouchen = false
    }
    
    func enshootanimation() {
        if !waitToShootenCrouch && !waitToShooten && enemyitem.parent == nil {
            waitToShooten = true
            waitToCrouchen = true
            enemy.removeAllActions()
            enemy.run(enemyactions[4], completion: enshootfun)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if jumpbutton.contains(touchLocation) && !waitToJump {
            waitToJump = true
            player.run(actions[2], completion: {
                self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 4000))
            })
        } else if shootbutton.contains(touchLocation) && !waitToShoot{
            waitToShoot = true
            player.run(actions[4], completion: shootfun)
        } else if crouchbutton.contains(touchLocation) {
            player.physicsBody = phis
            if p == "ww" {
                player.position.y *= 0.5
            }
            player.run(actions[3], withKey: "crouch")
        } else if (soundbutton.contains(touchLocation)){
            if mute{
                mute = false
                audioPlayer.volume = 0.3
                soundbutton.texture = SKTexture(imageNamed: "soundbutton")
            } else{
                mute = true
                audioPlayer.volume = 0
                soundbutton.texture = SKTexture(imageNamed: "soundbuttonmuted")
            }
        } else if touchLocation.x > player.position.x {
            player.physicsBody = phisdefault
            player.run(actions[5], withKey: "forward")
        } else if touchLocation.x <= player.position.x {
            player.physicsBody = phisdefault
            player.run(actions[1], withKey: "back")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        player.texture = SKTexture(imageNamed: "\(p)standard")
        player.physicsBody = phisdefault
        player.removeAction(forKey: "crouch")
        player.removeAction(forKey: "back")
        player.removeAction(forKey: "forward")
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node == enemy && contact.bodyB.node == item) || (contact.bodyA.node == item && contact.bodyB.node == enemy) {
            waitToShooten = true
            waitToWalken = true
            
            if p == "ww" {
                explosion = SKEmitterNode(fileNamed: "Effects/explosion")!
                explosion.position = item.position
                addChild(explosion)
            }
            item.removeFromParent()
            
            enemy.physicsBody = phisendefault
            enemy.removeAllActions()
            run(impactp)
            run(scream)
            enemy.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(e)enpain"), SKTexture(imageNamed: "\(e)enstandard")], timePerFrame: 0.1), count: 2))
            enhp -= 75
            print("hp nemico= \(enhp)")
            healthbaren.size.width -= 75
            
            if enhp < 0 {
                healthbaren.removeFromParent()
                enemy.texture = SKTexture(imageNamed: "\(e)enpain")
                
                let endScene = EndScene(fileNamed: "EndScene")
                endScene?.winnername = p
                endScene?.hp = hp
                endScene?.mute = mute
                audioPlayer.stop()
                try! endScene?.audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Sounds/winMusic", ofType: "mp3")!))
                endScene?.scaleMode = .aspectFit
                
                self.view?.presentScene(endScene!, transition: SKTransition.push(with: .left, duration: 1))
            } else if enhp <= 500 && enhp > 250 {
                healthbaren.texture = SKTexture(imageNamed: "healthbaryellow")
            } else if enhp <= 250 {
                healthbaren.texture = SKTexture(imageNamed: "healthbarred")
                healthbaren.run(SKAction.repeatForever(blink))
            }
            
            waitToWalken = false
            waitToShoot = false
            waitToShooten = false
        } else if (contact.bodyA.node == item && contact.bodyB.node?.name == "rwall") || (contact.bodyA.node?.name == "rwall" && contact.bodyB.node == item) {
            item.removeFromParent()
            waitToShoot = false
            run(impactp)
        } else if (contact.bodyA.node == item && contact.bodyB.node?.name == "floor") || (contact.bodyA.node?.name == "floor" && contact.bodyB.node == item) {
            item.removeFromParent()
            waitToShoot = false
            run(impactp)
        }
        
        if (contact.bodyA.node == player && contact.bodyB.node == enemyitem) || (contact.bodyA.node == enemyitem && contact.bodyB.node == player) {
            waitToShoot = true
            
            if e == "ww" {
                explosion = SKEmitterNode(fileNamed: "Effects/explosion")!
                explosion.position = enemyitem.position
                addChild(explosion)
            }
            enemyitem.removeFromParent()
            
            player.removeAllActions()
            player.physicsBody = phisdefault
            run(impacte)
            run(scream)
            player.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(p)pain"), SKTexture(imageNamed: "\(p)standard")], timePerFrame: 0.1), count: 2))
            hp -= 75
            healthbar.size.width -= 75
            print("hp player= \(hp)")
            if hp < 0 {
                healthbar.removeFromParent()
                player.texture = SKTexture(imageNamed: "\(p)pain")
                
                let endScene = EndScene(fileNamed: "EndScene")
                endScene?.winnername = e
                endScene?.hp = hp
                endScene?.mute = mute
                audioPlayer.stop()
                try! endScene?.audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Sounds/loseMusic", ofType: "wav")!))
                endScene?.scaleMode = .aspectFit
                
                self.view?.presentScene(endScene!, transition: SKTransition.push(with: .left, duration: 1))
            } else if hp <= 500 && hp > 250 {
                healthbar.texture = SKTexture(imageNamed: "healthbaryellow")
            } else if hp <= 250 {
                healthbar.texture = SKTexture(imageNamed: "healthbarred")
                  healthbar.run(SKAction.repeatForever(blink))
            }
            
            waitToShooten = false
            waitToShoot = false
            waitToJump = false
        } else if (contact.bodyA.node == enemyitem && contact.bodyB.node?.name == "lwall") || (contact.bodyA.node?.name == "lwall" && contact.bodyB.node == enemyitem) {
            enemyitem.removeFromParent()
            waitToShooten = false
            run(impacte)
        } else if (contact.bodyA.node == enemyitem && contact.bodyB.node?.name == "floor") || (contact.bodyA.node?.name == "floor" && contact.bodyB.node == enemyitem) {
            enemyitem.removeFromParent()
            waitToShooten = false
            run(impacte)
        }
        
        if ((contact.bodyA.node == player && contact.bodyB.node?.name == "floor") || (contact.bodyA.node?.name == "floor" && contact.bodyB.node == player)) && waitToJump {
            waitToJump = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if Calendar.current.component(.second, from: Date()) - sec >= 1 {
            sec = Calendar.current.component(.second, from: Date())

            if !waitToWalken {
                if enemy.position.x >= size.width - enemy.size.width {
                    enemy.run(enemyactions[2],completion: enshootanimation)
                }
                else if enemy.position.x <= size.width / 2 + enemy.size.width {
                    enemy.run(enemyactions[1],completion: enshootanimation)
                }
                else {
                    enemy.run(enemyactions[Int.random(in: 1..<3)], completion: enshootanimation)
                }
            }
        }
        else if Calendar.current.component(.minute, from: Date()) > min {
            sec = Calendar.current.component(.second, from: Date())
            min = Calendar.current.component(.minute, from: Date())
        }
        
        if !audioPlayer.isPlaying && !mute {
            audioPlayer.play()
        }
    }
}
