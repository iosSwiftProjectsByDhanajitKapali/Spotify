//
//  SearchViewController.swift
//  Spotify
//
//  Created by unthinkable-mac-0025 on 08/02/22.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController{
    
    // MARK: - Private Data Members
    private let searchController : UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    private let collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: {
            _,_ -> NSCollectionLayoutSection? in
            
            //Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(150)
                ),
                subitem : item,
                count : 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 2, bottom: 10, trailing: 2)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
//            section.boundarySupplementaryItems = [
//                NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: NSCollectionLayoutSize(
//                        widthDimension: .fractionalWidth(1),
//                        heightDimension: .fractionalHeight(0.4)
//                    ),
//                    elementKind: UICollectionView.elementKindSectionHeader,
//                    alignment: .top
//                )
//            ]
            return section
        })
    )
    private var categories = [Category]()
    
}

// MARK: - LifeCycle Methods
extension SearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        view.addSubview(collectionView)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        APICaller.shared.getCategories {  result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - Private Methods
private extension SearchViewController{
    
}


// MARK: - UISearchBarDelegate & UISearchResultsUpdating Methods
extension SearchViewController : UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,  let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return }
        
        resultsController.delegate = self
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async { [weak self] in
                switch result{
                case .success(let results):
                    resultsController.update(with : results)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

    }
}

    
// MARK: - UICollectionViewDataSource & UICollectionViewDelegate Methods
extension SearchViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else{
            return UICollectionViewCell()
        }
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(title: category.name, artworkURL: URL(string:  category.icons.first?.url ?? "")))
        //cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - SearchResultsViewControllerDelegate Methods
extension SearchViewController : SearchResultsViewControllerDelegate {
    func didTapResult(_ result: SearchResult) {
        switch result {
        case .artist(let model) :
            //Open the Artist Page(External URL), within the app
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {return}
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
            
        case .track(let model) :
            PlayBackPresenter.shared.startPlayback(from: self, track: model)
        case .album(let model) :
            let vc = AlbumViewController(album: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)

        case .playlist(let model) :
            let vc = PlaylistViewController(playlist: model)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
}
