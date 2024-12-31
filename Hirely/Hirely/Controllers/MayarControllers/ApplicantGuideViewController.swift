//
//  ApplicantGuideViewController.swift
//  Hirely
//
//  Created by Manar Alsatrawi on 30/12/2024.
//

import UIKit
import AVKit
import AVFoundation

class ApplicantGuideViewController: UIViewController {

    @IBOutlet weak var viewToDisplayVideo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskPath = UIBezierPath(roundedRect: self.viewToDisplayVideo.bounds,
                                    byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 30, height: 30))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        self.viewToDisplayVideo.layer.mask = shapeLayer
        
        playVideo()
    }
    
    func playVideo(){
        guard let videoLink = URL(string: "https://res.cloudinary.com/drkt3vace/video/upload/v1735576168/qsnqlsxvtnz7qoxcdi1a.mp4") else { return }
        
        let player = AVPlayer(url: videoLink)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = viewToDisplayVideo.bounds
        playerLayer.videoGravity = .resizeAspect
        
        viewToDisplayVideo.layer.addSublayer(playerLayer)
        
        player.play()
    }
}
