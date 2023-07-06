//
//  VideoCell.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 03/07/23.
//

import UIKit

class VideoCell: UITableViewCell {
    
    private lazy var thumbImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .headline, weight: .bold)
        view.numberOfLines = 0
        
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        let view = UILabel()
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [thumbImage, titleLabel, dayLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 8
        
        return view
    }()
    
    var video: Video? {
        didSet {
            if let video {
                updateCell(video)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
        
        thumbImage.heightAnchor.constraint(equalTo: thumbImage.widthAnchor, multiplier: 9/16).isActive = true
        
        dayLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        dayLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        thumbImage.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        thumbImage.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func updateCell(_ video: Video) {
        titleLabel.text = video.title
        
        dayLabel.text = video.publishedAt.formatted(date: .complete, time: .omitted)
        
        if let cachedData = CacheManager.getVideoCache(video.thumbUrl) {
            self.thumbImage.image = UIImage(data: cachedData)
            return
        }
        
        // Download the thumbnail
        let url = URL(string: video.thumbUrl)!
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            if let data, error == nil {
                // Make sure the image corresponds to the one currently displayed by the cell
                guard url.absoluteString == self.video?.thumbUrl else { return }
                
                CacheManager.setVideoCache(video.thumbUrl, data: data)
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.thumbImage.image = image
                }
            }
        }
        
        dataTask.resume()
        
    }
}
