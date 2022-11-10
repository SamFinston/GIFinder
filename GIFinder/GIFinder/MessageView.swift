//
//  MessageView.swift
//  GIFinder
//
//  Created by Sam Finston on 7/13/22.
//

import Foundation
import UIKit

enum MessageType {
    case welcome
    case error
    case noResults
}

class MessageView: UIView {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let textView: UILabel = {
        let view = UILabel()
        return view
    }()
    
    struct Constants {
        static let imageConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .regular, scale: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(textView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            textView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ])
    }
    
    public func apply(type: MessageType) {
        switch type {
        case .welcome:
            let icon = UIImage(systemName: "sparkle.magnifyingglass", withConfiguration: Constants.imageConfig)
            imageView.image = icon
            textView.text = "Welcome to GIFinder!"
            break
        case .error:
            let icon = UIImage(systemName: "gear.badge.xmark", withConfiguration: Constants.imageConfig)
            imageView.image = icon
            textView.text = "Something went wrong!"
            break
        case .noResults:
            let icon = UIImage(systemName: "exclamationmark.icloud", withConfiguration: Constants.imageConfig)
            imageView.image = icon
            textView.text = "Couldn't find anything!"
            break
        }
        
    }
}
