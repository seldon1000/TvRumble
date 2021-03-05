//
//  EndScene.swift
//  TVRumbleTest1
//
//  Created by Nicolas Mariniello && Fabio Friano on 08/04/2020.
//

import SpriteKit
import AVFoundation

class EndScene: SKScene {
    var audioPlayer = AVAudioPlayer()
    var mute = false
    var hp = 0
    var winnername = ""
    
    private var winner = SKSpriteNode()
    private var label = SKLabelNode()
    
    override func didMove(to view: SKView) {
        label = childNode(withName: "label") as! SKLabelNode
        winner = childNode(withName: "winner") as! SKSpriteNode
        
        if hp > 0 {
            label.text = "You Win!"
        } else {
            label.text = "You Lose!"
        }
        
        if !mute {
            audioPlayer.play()
        }
        
        winner.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(winnername)1"), SKTexture(imageNamed: winnername)], timePerFrame: 0.4), count: 20))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let mainScene = MainScene(fileNamed: "MainScene")
        mainScene?.mute = mute
        try! mainScene?.audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "Sounds/backgroundMusic", ofType: "mp3")!))
        mainScene?.audioPlayer.volume = 0.4
        mainScene?.scaleMode = .aspectFit
        audioPlayer.stop()
        
        self.view?.presentScene(mainScene!, transition: SKTransition.push(with: .right, duration: 1))
    }
}
