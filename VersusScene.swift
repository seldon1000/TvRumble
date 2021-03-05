//
//  VersusScreen.swift
//  TVRumbleTest1
//
//  Created by Nicolas Mariniello && Fabio Friano on 03/04/2020.
//  Copyright © 2020 Cinemofili. All rights reserved.
//

import SpriteKit
import AVFoundation

class VersusScene: SKScene {
    var audioPlayer = AVAudioPlayer()
    var label1 = ""
    var label2 = ""
    
    private var selectedCharacter = SKSpriteNode()
    private var selectedName = SKLabelNode()
    private var opponent = SKSpriteNode()
    private var opponentName = SKLabelNode()
    
    override func didMove(to view: SKView) {
        selectedCharacter = childNode(withName: "selectedCharacter") as! SKSpriteNode
        selectedName = childNode(withName: "selectedName") as! SKLabelNode
        opponent = childNode(withName: "opponent") as! SKSpriteNode
        opponentName = childNode(withName: "opponentName") as! SKLabelNode
        
        selectedCharacter.texture = SKTexture(imageNamed: label1)
        selectedName.text = label1
        opponent.texture = SKTexture(imageNamed: label2)
        opponentName.text = label2
        
        selectedCharacter.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(label1)1"), SKTexture(imageNamed: label1)], timePerFrame: 0.4), count: 20))
        opponent.run(SKAction.repeat(SKAction.animate(with: [SKTexture(imageNamed: "\(label2)1"), SKTexture(imageNamed: label2)], timePerFrame: 0.4), count: 20))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let battleScene = BattleScene(fileNamed: "BattleScene")
        battleScene?.p = label1
        battleScene?.e = label2
        battleScene?.audioPlayer = audioPlayer
        battleScene?.scaleMode = .aspectFit
        
        self.view?.presentScene(battleScene!, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !audioPlayer.isPlaying {
            audioPlayer.play()
        }
    }
}
