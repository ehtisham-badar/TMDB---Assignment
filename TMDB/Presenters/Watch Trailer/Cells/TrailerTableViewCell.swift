//
//  TrailerTableViewCell.swift
//  TMDB
//
//  Created by Ehtisham Badar on 06/03/2022.
//

import UIKit
import AVKit
import AVFoundation
import YouTubePlayer

class TrailerTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var trailerImage: UIImageView!
    @IBOutlet weak var videoView: YouTubePlayerView!
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func populateTrailers(data: Trailer){
        videoView.loadVideoID(data.key)
        lblName.text = data.name
    }
    func createThumbnailOfVideoFromFileURL(videoURL: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: videoURL)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            return UIImage(named: "ico_placeholder")
        }
    }
    func getYouTubeUrl(data: Trailer) -> String{
        //https://www.youtube.com/watch?v=Jtdh0Tkqfdw
        let url = "https://www.youtube.com/watch?v=\(data.key)"
        return url
    }
    func playTrailer(url: String){
        let url = URL(string: url)
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.view.frame.size.height = videoView.frame.size.height
        avpController.view.frame.size.width = videoView.frame.size.width
        self.videoView.addSubview(avpController.view)
        self.player.play()
    }
    
}
