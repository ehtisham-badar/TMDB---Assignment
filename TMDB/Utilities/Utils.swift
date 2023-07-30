//
//  Utils.swift
//  Routecab-Passenger
//
//  Created by Ehtisham Badar on 18/12/2021.
//

import UIKit
import SDWebImage


enum DefaultValue{
    static let string = ""
    static let float: Float = 0.0
    static let double:Double = 0.0
    static let bool: Bool = false
    static let int: Int = 0
    static let space = " "
    static let comma = ", "
    static let date : Date = Date()
    static let dateFormat = "MM/dd/yyyy"
    
}

class Utils: NSObject{
    static let shared = Utils()

    var isiPhone: Bool{
        return (UIDevice.current.userInterfaceIdiom == .phone)
    }
    static func loadImage(imageView: UIImageView, urlString: String, placeHolderImageString: String?)->Swift.Void{
        let placeHolder = UIImage(named: placeHolderImageString ?? "")
        imageView.image = placeHolder
        let encodedString:String = urlString.replacingOccurrences(of: " ", with: "%20")
        
        imageView.sd_setImage(with: URL(string: encodedString), placeholderImage: placeHolder)
    }
    
    static func loadImage(imageView: UIImageView, urlString: String, placeHolder: UIImage?)->Swift.Void{
        imageView.image = placeHolder
        let encodedString:String = urlString.replacingOccurrences(of: " ", with: "%20")
        
        imageView.sd_setImage(with: URL(string: encodedString), placeholderImage: placeHolder)
    }
    
    static func loadImageAndRender(imageView: UIImageView, urlString: String, placeHolderImageString: String?)->UIImage?{
        var img: UIImage?
        let stringInUrlFormat = URL.init(string: urlString)
        
        SDWebImageDownloader.self().downloadImage(with: stringInUrlFormat, options: SDWebImageDownloaderOptions.useNSURLCache, progress: { (receivedSize, expectedSize, stringInUrlFormat) in
            //code here
        }) { (image, data, error, finished)  in
            if ((image != nil) && finished){
                imageView.image = image?.withRenderingMode(.alwaysOriginal)
            }
             img = image
        }
        return img
    }
    
    static func loadImageWithRender(imageView: UIImageView, urlString: String, placeHolderImageString: String?)->Swift.Void{
        let placeHolder = UIImage(named: placeHolderImageString ?? "")?.withRenderingMode(.alwaysTemplate)
        imageView.image = placeHolder
        let encodedString:String = urlString.replacingOccurrences(of: " ", with: "%20")
        
        imageView.sd_setImage(with: URL(string: encodedString), placeholderImage: placeHolder)
        //imageView.image?.withRenderingMode(.alwaysTemplate)
    
    }
}


