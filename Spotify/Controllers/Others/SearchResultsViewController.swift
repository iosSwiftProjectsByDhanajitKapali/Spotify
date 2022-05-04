//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit

struct SearchResultWithSection {
    let title : String
    let items : [SearchResult]
}

protocol SearchResultsViewControllerDelegate : AnyObject{
    func didTapResult(_ result : SearchResult)
    //func showResult(_ controller : UIViewController)
}

class SearchResultsViewController: UIViewController {

    weak var delegate : SearchResultsViewControllerDelegate?
    
    private var resultsWithSections : [SearchResultWithSection] = []
    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func update(with results : [SearchResult]){
        let artists = results.filter {
            switch $0{
            case .artist: return true
            default : return false
            }
        }
        
        let albums = results.filter {
            switch $0{
            case .album: return true
            default : return false
            }
        }
        
        let playlists = results.filter {
            switch $0{
            case .playlist: return true
            default : return false
            }
        }
        
        let tracks = results.filter {
            switch $0{
            case .track: return true
            default : return false
            }
        }
        
        self.resultsWithSections = [
            SearchResultWithSection(title: "Songs", items: tracks),
            SearchResultWithSection(title: "Artits", items: artists),
            SearchResultWithSection(title: "Playlists", items: playlists),
            SearchResultWithSection(title: "Albums", items: albums)
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
}


// MARK: - UITableViewDelegate & UITableViewDataSource Methods
extension SearchResultsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = resultsWithSections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch result {
        case .artist(let model) :
            cell.textLabel?.text = model.name
        case .track(let model) :
            cell.textLabel?.text = model.name
        case .album(let model) :
            cell.textLabel?.text = model.name
        case .playlist(let model) :
            cell.textLabel?.text = model.name
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsWithSections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        resultsWithSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return resultsWithSections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Open the corresponding screen for the type of item selected from the search result
        let result = resultsWithSections[indexPath.section].items[indexPath.row]
        delegate?.didTapResult(result)
    }
}
