//
//  TrailerListViewController.swift
//  TMDB
//
//  Created by Ehtisham Badar on 05/03/2022.
//

import UIKit

class TrailerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var movieList: WatchMovies!
    var trailerList = [Trailer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        Constants.tabbarController?.tabBarView.isHidden = true
        Constants.tabbarController?.tabBarSeperatorVieww.isHidden = true
        registerCell()
        if Reachability.shared.isInternetAvailable(){
            getTrailers()
        }else{
            self.showAlert()
        }
        
    }
    func registerCell(){
        tableView.register(UINib(nibName: String(describing: TrailerTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TrailerTableViewCell.self))
    }
    @IBAction func didSelectBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func getTrailers(){
        APIHandler.shared.getTrailers(movieId: "\(movieList.id)") { response in
            print(response)
            guard let responseDic = response as? Dictionary<String, Any>,
                  let items = responseDic[APIKey.results] as? Array<Dictionary<String, Any>> else{
                      return
                  }
            items.forEach({ (item) in
                self.trailerList.append(Trailer(item))
            })
            self.tableView.reloadData()
        } onError: { message, code, response in
            print(message,code, response)
        }

    }
}
extension TrailerListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trailerList.count == 0{
            return 10
        }else{
            return trailerList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrailerTableViewCell.self)) as! TrailerTableViewCell
        cell.selectionStyle = .none
        if trailerList.count == 0{
            cell.lblName.isHidden = true
        }else{
            cell.lblName.isHidden = false
            cell.populateTrailers(data: trailerList[indexPath.row])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
}
