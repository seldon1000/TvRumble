//
//  GameScene.swift
//  TVRumbleTest1
//
//  Created by Nicolas Mariniello on 02/04/2020.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var mute = false
    var audioPlayer = AVAudioPlayer()
    
    var singleMatchButton = SKSpriteNode()
    var soundButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        singleMatchButton = childNode(withName: "singleMatchButton") as! SKSpriteNode
        soundButton = childNode(withName: "soundButton") as! SKSpriteNode
        
        if (mute){
            soundButton.texture = SKTexture(imageNamed: "speakerMuted")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if (singleMatchButton.contains(touchLocation)) {
            let characterSelection = CharacterSelectionScene(fileNamed: "CharacterSelectionScene")
            characterSelection?.scaleMode = .aspectFit
            characterSelection?.mute = mute
            characterSelection?.audioPlayer = audioPlayer
                
            self.view?.presentScene(characterSelection!, transition: SKTransition.push(with: .left, duration: 1))
        } else if (soundButton.contains(touchLocation)){
            if mute{
                mute = false
                audioPlayer.volume = 1
                
                soundButton.texture = SKTexture.init(imageNamed: "speaker")
            } else{
                mute = true
                audioPlayer.volume = 0

                soundButton.texture = SKTexture.init(imageNamed: "speakerMuted")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (!audioPlayer.isPlaying && !mute){
            audioPlayer.play()
        }
    }
}
