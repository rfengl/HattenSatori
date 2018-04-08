//
//  SplashScreenController.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 08/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class VideoController: AVPlayerViewController, AVPlayerViewControllerDelegate {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playVideo()
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "video", ofType:"mp4") else {
            debugPrint("video.mp4 not found")
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        self.player = player
        player.play()
        
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        performSegue(withIdentifier: Segue.segueHome.rawValue, sender: self)
    }
}
