//
//  CharacterSelectionScene.swift
//  TVRumbleTest1
//
//  Created by Nicolas Mariniello && Fabio Friano on 02/04/2020.
//

import SpriteKit
import AVFoundation

class CharacterSelectionScene: SKScene {
    var mute = false
    var audioPlayer = AVAudioPlayer()
    private var characters = [String]()
    
    private var characterPreview = SKSpriteNode()
    private var selectedName = SKLabelNode()
    private var selectedIndex = 0

    private var nextCharacter = SKSpriteNode()
    private var previousCharacter = SKSpriteNode()
    private var backButton = SKSpriteNode()
    private var soundButton = SKSpriteNode()
    private var nextButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        characters.append("pablo")
        characters.append("ww")
        
        characterPreview = childNode(withName: "characterPreview") as! SKSpriteNode
        selectedName = childNode(withName: "selectedName") as! SKLabelNode

        nextCharacter = childNode(withName: "nextCharacter") as! SKSpriteNode
        previousCharacter = childNode(withName: "previousCharacter") as! SKSpriteNode
        backButton = childNode(withName: "backButton") as! SKSpriteNode
        soundButton = childNode(withName: "soundButton") as! SKSpriteNode
        nextButton = childNode(withName: "nextButton") as! SKSpriteNode
        
        if mute {
            soundButton.texture = SKTexture(imageNamed: "soundbuttonmuted")
        } else {
            run(SKAction.playSoundFileNamed("Sounds/\(characters[selectedIndex])go", waitForCompletion: true), withKey: "go")
        }
        
        characterPreview.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(characters[selectedIndex])1"), SKTexture(imageNamed: characters[selectedIndex])], timePerFrame: 0.4), count: 10))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if previousCharacter.contains(touchLocation) {
            removeAction(forKey: "go")
            selectedIndex -= 1
            
            if selectedIndex < 0 {
                selectedIndex = characters.count - 1
            }
            
            selectedName.text = characters[selectedIndex]
            characterPreview.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(characters[selectedIndex])1"), SKTexture(imageNamed: characters[selectedIndex])], timePerFrame: 0.4), count: 10))
            if !mute {
                run(SKAction.playSoundFileNamed("Sounds/\(characters[selectedIndex])go", waitForCompletion: true), withKey: "go")
            }
        } else if nextCharacter.contains(touchLocation){
            removeAction(forKey: "go")
            selectedIndex += 1
            
            if selectedIndex > characters.count - 1 {
                selectedIndex = 0
            }
            
            selectedName.text = characters[selectedIndex]
            characterPreview.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(characters[selectedIndex])1"), SKTexture(imageNamed: characters[selectedIndex])], timePerFrame: 0.4), count: 10))
            if !mute {
                run(SKAction.playSoundFileNamed("Sounds/\(characters[selectedIndex])go", waitForCompletion: true), withKey: "go")
            }
        } else if nextButton.contains(touchLocation) {
            removeAction(forKey: "go")
            
            let opponentSelectionScene = OpponentSelectionScene(fileNamed: "CharacterSelectionScene")
            opponentSelectionScene?.scaleMode = .aspectFit
            opponentSelectionScene?.characters = characters
            opponentSelectionScene?.selection = characters[selectedIndex]
            opponentSelectionScene?.mute = mute
            opponentSelectionScene?.audioPlayer = audioPlayer
            
            self.view?.presentScene(opponentSelectionScene!, transition: SKTransition.push(with: .left, duration: 1))
        } else if soundButton.contains(touchLocation) {
            if mute {
                mute = false
                audioPlayer.volume = 0.4
                soundButton.texture = SKTexture(imageNamed: "soundbutton")
            } else {
                mute = true
                removeAction(forKey: "go")
                audioPlayer.volume = 0
                soundButton.texture = SKTexture(imageNamed: "soundbuttonmuted")
            }
        } else if backButton.contains(touchLocation) {
            removeAction(forKey: "go")
            
            let mainScene = MainScene(fileNamed: "MainScene")
            mainScene?.scaleMode = .aspectFit
            mainScene?.mute = mute
            mainScene?.audioPlayer = audioPlayer
            
            self.view?.presentScene(mainScene!, transition: SKTransition.push(with: .right, duration: 1))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !audioPlayer.isPlaying && !mute {
            audioPlayer.play()
        }
    }
}
