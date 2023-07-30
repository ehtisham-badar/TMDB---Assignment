//
//  WatchMovieCollectionViewCell.swift
//  TMDB
//
//  Created by Ehtisham Badar on 05/03/2022.
//

import UIKit

class WatchMovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func populateData(data: WatchMovies){
        Utils.loadImage(imageView: posterImageView, urlString: Constants.API_IMAGE_URL + data.backdrop_path, placeHolder: UIImage(named: "placeholder"))
        lblMovieTitle.text = data.original_title
    }

}
