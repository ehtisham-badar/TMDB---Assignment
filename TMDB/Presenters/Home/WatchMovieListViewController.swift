//
//  WatchMovieListViewController.swift
//  TMDB
//
//  Created by Ehtisham Badar on 05/03/2022.
//

import UIKit

class WatchMovieListViewController: UIViewController {

    @IBOutlet weak var watchView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var watchMoviesView: UIView!
    @IBOutlet weak var searchMoviesView: UIView!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    
    var moviesList = [WatchMovies]()
    var popularMoviesList = [WatchMovies]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        if Reachability.shared.isInternetAvailable(){
            getUpcomingMovies()
        }else{
            self.showAlert()
        }
        
        addSpacing()
        searchTF.delegate = self
        searchMoviesView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.tabbarController?.tabBarSeperatorVieww.isHidden = false
        Constants.tabbarController?.tabBarView.isHidden = false
    }
    func registerNib(){
        collectionView.register(UINib(nibName: String(describing: WatchMovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: WatchMovieCollectionViewCell.self))
        searchCollectionView.register(UINib(nibName: String(describing: PopularMoviesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularMoviesCollectionViewCell.self))
    }
    func addSpacing(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView!.collectionViewLayout = layout
        searchCollectionView!.collectionViewLayout = layout
    }
    func getUpcomingMovies(){
        APIHandler.shared.showUpcomingMovies { response in
            print(response)
            guard let responseDic = response as? Dictionary<String, Any>,
                  let items = responseDic[APIKey.results] as? Array<Dictionary<String, Any>> else{
                      return
                  }
            items.forEach({ (item) in
                self.moviesList.append(WatchMovies(item))
            })
            self.collectionView.reloadData()
            
        } onError: { message, code, response in
            print(message,code, response)
        }

    }
    func getPopularMovies(searchText: String){
        APIHandler.shared.searchMovies(query: searchText) { response in
            print(response)
            guard let responseDic = response as? Dictionary<String, Any>,
                  let items = responseDic[APIKey.results] as? Array<Dictionary<String, Any>> else{
                      return
                  }
            self.popularMoviesList.removeAll()
            items.forEach({ (item) in
                self.popularMoviesList.append(WatchMovies(item))
            })
            self.searchCollectionView.reloadData()
            
        } onError: { message, code, response in
            print(message,code, response)
        }
    }
    @IBAction func didClickSearchBtn(_ sender: Any) {
        searchTF.becomeFirstResponder()
        watchView.isHidden = true
        watchMoviesView.isHidden = true
        UIView.animate(withDuration: 0.5) {[self] in
            searchView.isHidden = false
//            searchMoviesView.isHidden = false
        }
    }
    @IBAction func didClickCancelSearchBtn(_ sender: Any) {
        searchTF.text = ""
        searchTF.endEditing(true)
        searchView.isHidden = true
        searchMoviesView.isHidden = true
        UIView.animate(withDuration: 0.5) {[self] in
            watchView.isHidden = false
            watchMoviesView.isHidden = false
        }
    }
}
extension WatchMovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            if moviesList.count == 0{
                return 10
            }else{
                return moviesList.count
            }
        }else{
            if popularMoviesList.count == 0{
                return 10
            }else{
                return popularMoviesList.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WatchMovieCollectionViewCell.self), for: indexPath) as! WatchMovieCollectionViewCell
            if moviesList.count > 0{
                cell.populateData(data: moviesList[indexPath.item])
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularMoviesCollectionViewCell.self), for: indexPath) as! PopularMoviesCollectionViewCell
            if popularMoviesList.count > 0{
                cell.populateData(data: popularMoviesList[indexPath.item])
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if searchMoviesView.isHidden{
            return CGSize(width: collectionView.frame.width, height: 180)
        }else {
            return CGSize(width: collectionView.frame.width, height: 120)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
            vc.modalPresentationStyle = .fullScreen
            if moviesList.count > 0{
                vc.movieList = moviesList[indexPath.item]
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            //function
        }
    }
}
extension WatchMovieListViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchTF.text == ""{
            searchMoviesView.isHidden = true
        }else{
            searchMoviesView.isHidden = false
//            getPopularMovies(searchText: textField.text ?? "")
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Reachability.shared.isInternetAvailable(){
            getPopularMovies(searchText: string.trimmingCharacters(in: .whitespaces))
        }else{
            self.showAlert()
        }
        
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as! SearchViewController
        vc.modalPresentationStyle = .fullScreen
        vc.searchMoviesList = popularMoviesList
        self.navigationController?.pushViewController(vc, animated: true)
        return true
    }
}
