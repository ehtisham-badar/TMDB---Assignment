//
//  SearchViewController.swift
//  TMDB
//
//  Created by Ehtisham Badar on 07/03/2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblSearchResults: UILabel!
    
    var searchMoviesList = [WatchMovies]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        lblSearchResults.text = "\(searchMoviesList.count) Results Found"
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    func registerNib(){
        collectionView.register(UINib(nibName: String(describing: PopularMoviesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularMoviesCollectionViewCell.self))
    }
    @IBAction func didClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            if popularMoviesList.count == 0{
        return searchMoviesList.count
//            }else{
//                return popularMoviesList.count
//            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularMoviesCollectionViewCell.self), for: indexPath) as! PopularMoviesCollectionViewCell
            if searchMoviesList.count > 0{
                cell.populateData(data: searchMoviesList[indexPath.item])
            }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        vc.modalPresentationStyle = .fullScreen
        if searchMoviesList.count > 0{
            vc.movieList = searchMoviesList[indexPath.item]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
