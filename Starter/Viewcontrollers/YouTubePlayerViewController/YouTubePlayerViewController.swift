//
//  YouTubePlayerViewController.swift
//  Starter
//
//  Created by KC on 15/03/2022.
//

import UIKit
import YouTubePlayer

class YouTubePlayerViewController: UIViewController {
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    
    var youtubeId: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = youtubeId{
            videoPlayer.loadVideoID(id)
            videoPlayer.play()

        }else{
            print ("Invalid YouTubeID")
        }
    }

    @IBAction func onClickDismiss( _ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }

   
}
