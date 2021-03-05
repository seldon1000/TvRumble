//
//  GameViewController.swift
//  TVRumbleTest1
//
//  Created by Nicolas Mariniello && Fabio Friano on 02/04/2020.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    private var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Sounds/backgroundMusic", ofType: "mp3")!)
        try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        audioPlayer.volume = 0.4
        
        if let view = self.view as! SKView? {
            if let scene = MainScene(fileNamed: "MainScene") {
                scene.scaleMode = .aspectFit
                scene.audioPlayer = audioPlayer
                
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true

//            view.showsPhysics = true
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
