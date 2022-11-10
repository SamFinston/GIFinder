//
//  GifCell.swift
//  GIFinder
//
//  Created by Sam Finston on 7/11/22.
//

import UIKit
import SwiftyGif

// UICollectionViewCell that displays a single gif
class GifCell: UICollectionViewCell {
    static let identifier = "GifCell"
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func apply(viewModel: GifCellViewModel) {
        let imageUrl = URL(string: viewModel.imageUrl)
        
        applyImage(from: imageUrl)
    }
    
    private func applyImage(from url: URL?) {
        guard let url = url else {
            return
        }
        
        let loader = UIActivityIndicatorView(style: .medium)
        imageView.setGifFromURL(url, customLoader: loader)
    }
}

struct GifCellViewModel {
    let title: String
    let giphyUrl: String
    let imageUrl: String
}
