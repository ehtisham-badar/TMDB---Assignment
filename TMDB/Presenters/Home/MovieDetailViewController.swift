//
//  MovieDetailViewController.swift
//  TMDB
//
//  Created by Ehtisham Badar on 05/03/2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var detailImageView: UIImageView!
    var movieList: WatchMovies!
    var genreList = [Genres]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.tabbarController?.tabBarView.isHidden = true
        Constants.tabbarController?.tabBarSeperatorVieww.isHidden = true
        if Reachability.shared.isInternetAvailable(){
            getMovieDetail()
        }else{
            self.showAlert()
        }
        
        addSpacing()
        lblOverview.text = movieList.overview
        Utils.loadImage(imageView: detailImageView, urlString: Constants.API_IMAGE_URL + movieList.poster_path, placeHolder: UIImage(named: "placeholder"))
    }
    func getMovieDetail(){
        APIHandler.shared.showMovieDetail(movieId: "\(movieList.id)") { response in
            guard let responseDic = response as? Dictionary<String, Any>,
                  let items = responseDic[APIKey.genres] as? Array<Dictionary<String, Any>> else{
                      return
                  }
            items.forEach({ (item) in
                self.genreList.append(Genres(item))
            })
            self.genreCollectionView.reloadData()
        } onError: { message, code, response in
            
        }
        
    }
    func addSpacing(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        layout.minimumInteritemSpacing = 2.5
        layout.minimumLineSpacing = 0
        genreCollectionView!.collectionViewLayout = layout
    }
    @IBAction func didSelectBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didSelectWatchTrailer(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: TrailerListViewController.self)) as! TrailerListViewController
        vc.modalPresentationStyle = .fullScreen
        vc.movieList = self.movieList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didClickGetTickers(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: SeatsViewController.self)) as! SeatsViewController
        vc.movieList = self.movieList
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenreCollectionViewCell.self), for: indexPath) as! GenreCollectionViewCell
        cell.populateCell(data: genreList[indexPath.item])
        switch indexPath.item{
        case 0:
            cell.genreView.backgroundColor = UIColor.hexStringToUIColor(hex: "15D2BC")
        case 1:
            cell.genreView.backgroundColor = UIColor.hexStringToUIColor(hex: "E26CA5")
        case 2:
            cell.genreView.backgroundColor = UIColor.hexStringToUIColor(hex: "564CA3")
        case 3:
            cell.genreView.backgroundColor = UIColor.hexStringToUIColor(hex: "CD9D0F")
        default:
            cell.genreView.backgroundColor = UIColor.hexStringToUIColor(hex: "15D2BC")
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60.0, height: 24.0)
    }
}
