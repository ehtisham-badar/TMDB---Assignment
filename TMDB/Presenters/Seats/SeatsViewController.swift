//
//  SeatsViewController.swift
//  TMDB
//
//  Created by Ehtisham Badar on 07/03/2022.
//

import UIKit

class SeatsViewController: UIViewController {

    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    @IBOutlet weak var seatsCollectionView: UICollectionView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblMovieTitle: UILabel!
    var selectedDateIndex: Int = 0
    var selectedSeatIndex: Int = 0
    var movieList: WatchMovies!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMovieTitle.text = movieList.original_title
        lblDate.text = "In Theatres \(movieList.release_date)"
        registerNib()
    }
    func registerNib(){
        seatsCollectionView.register(UINib(nibName: String(describing: SeatsSelectionCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SeatsSelectionCollectionViewCell.self))
    }
    @IBAction func didSelectBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SeatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dateCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DatesCollectionViewCell.self), for: indexPath) as! DatesCollectionViewCell
            if selectedDateIndex == indexPath.item{
                cell.lblDate.textColor = UIColor.white
                cell.mainView.backgroundColor = UIColor.dateBG
            }else{
                cell.lblDate.textColor = UIColor.black
                cell.mainView.backgroundColor = UIColor.dateBGGrey
            }
            cell.lblDate.text = "\(indexPath.item+1) Mar"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SeatsSelectionCollectionViewCell.self), for: indexPath) as! SeatsSelectionCollectionViewCell
            if selectedSeatIndex == indexPath.item{
                cell.mainView.borderColor = UIColor.dateBG
            }else{
                cell.mainView.borderColor = UIColor.dateBGGrey
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == dateCollectionView{
            return CGSize(width: 67.0, height: 32.0)
        }else{
            return CGSize(width: 250.0, height: 200.0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dateCollectionView{
            selectedDateIndex = indexPath.item
            dateCollectionView.reloadData()
        }else{
            selectedSeatIndex = indexPath.item
            seatsCollectionView.reloadData()
        }
    }
    
}
