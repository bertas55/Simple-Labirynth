//
//  GameViewController.swift
//  SimpleLabirynth
//
//  Created by Hubert on 22.06.2016.
//  Copyright (c) 2016 Hubert. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView

        skView.ignoresSiblingOrder = true

        let scene = Scene(size: skView.bounds.size)
        scene.scaleMode = .AspectFit
        skView.presentScene(scene)

    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}
