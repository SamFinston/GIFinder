//
//  ViewController.swift
//  GIFinder
//
//  Created by Sam Finston on 7/11/22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = true
        search.searchBar.placeholder = "search"
        return search
    }()
    
    private var collectionView: UICollectionView?
    
    private var messageView = MessageView(frame: .zero)

    private var viewModels = [GifCellViewModel]()
    
    private let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //page setup
        title = "GIFinder"
        view.backgroundColor = .systemBackground
        
        // search setup
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        // collection view setup
        setupCollectionView()
        
        // message view setup
        messageView.apply(type: .welcome)
        showMessage(type: .welcome)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView?.frame = view.bounds
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        // enforces rows of two square cells each
        layout.itemSize = CGSize(width: view.frame.size.width / 2, height: view.frame.size.width / 2)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }

        collectionView.register(GifCell.self, forCellWithReuseIdentifier: GifCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func openWebView(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let webView = SFSafariViewController(url: url, configuration: config)
        present(webView, animated: true)
    }
}

// Message View functions
extension ViewController {
    func showMessage(type: MessageType) {
        messageView.apply(type: type)
        
        messageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageView)
        
        NSLayoutConstraint.activate([
            messageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            messageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func hideMessage() {
        messageView.removeFromSuperview()
    }
}
// Collection View functions
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GifCell.identifier,
            for: indexPath
        ) as? GifCell else {
            fatalError()
        }
        cell.apply(viewModel: viewModels[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openWebView(urlString: viewModels[indexPath.item].giphyUrl)
    }
    
}

// Search Bar functions
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        
        searchController.dismiss(animated: true)
        
        interactor.fetchGifs(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                let gifs = response.data
                
                if gifs.isEmpty {
                    DispatchQueue.main.async {
                        strongSelf.showMessage(type: .noResults)
                    }
                } else {
                    DispatchQueue.main.async {
                        strongSelf.hideMessage()
                    }
                }
                
                strongSelf.viewModels = gifs.map {
                    GifCellViewModel(title: $0.title,
                                     giphyUrl: $0.url,
                                     imageUrl: $0.images.downsized.url)
                }
                
                DispatchQueue.main.async {
                    strongSelf.collectionView?.reloadData()
                }
                break
            case .failure(let error):
                print(error)
                self?.viewModels = []
                self?.showMessage(type: .error)
            }
        }
    }
}
