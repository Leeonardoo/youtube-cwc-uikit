//
//  DetailViewController.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 04/07/23.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
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
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Like", for: .normal)
        
        return view
    }()
    
    private lazy var subscribeButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Subscribe", for: .normal)
        
        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [likeButton, subscribeButton])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        
        return view
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = .preferredFont(forTextStyle: .body)
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, dayLabel, webView, buttonsStackView, textView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        
        return view
    }()
    
    private let model = Model()
    private var video: Video?
    
    private var likedVideo = false
    
    init(_ video: Video) {
        super.init(nibName: nil, bundle: nil)
        self.video = video
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupConstraints()
        self.setupActions()
        
        self.setLikeButtonText()
        self.setSubscribeButtonText()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        self.sheetPresentationController?.prefersGrabberVisible = true
        
        self.view.addSubview(stackView)
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        guard let video else { return }
        
        // Load the embed into the WKWebView
        let embedUrl = URL(string: Constants.ytEmbedUrl + video.videoId)!
        webView.load(URLRequest(url: embedUrl))
        
        titleLabel.text = video.title
        dayLabel.text = video.publishedAt.formatted(date: .complete, time: .omitted)
        
        textView.text = video.description
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 9/16).isActive = true
        
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private func setupActions() {
        guard let video else { return }
        
        likeButton.addAction(
            UIAction(handler: { action in
                let rating = self.likedVideo ? "none" : "like"
                
                Task {
                    do {
                        try await self.model.rate(videoId: video.videoId, rating: rating)
                        self.setLikeButtonText()
                    } catch {
                        print(error)
                    }
                }
                
            }), for: .touchUpInside)
        
        subscribeButton.addAction(
            UIAction(handler: { action in
                let rating = self.likedVideo ? "none" : "like"
                
                Task {
                    do {
                        try await self.model.setSubscription(channelId: Constants.channelId)
                        self.subscribeButton.setTitle("Subscribed!", for: .normal)
                    } catch {
                        print(error)
                    }
                }
            }), for: .touchUpInside)
    }
    
    func setLikeButtonText() {
        guard let video else { return }
        
        Task {
            do {
                let rating = try await model.getVideoRating(videoId: video.videoId).items?.rating
                
                if rating == "dislike" || rating == "none" {
                    self.likeButton.setTitle("Like", for: .normal)
                    self.likedVideo = false
                } else {
                    self.likeButton.setTitle("Unlike", for: .normal)
                    self.likedVideo = true
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    func setSubscribeButtonText() {
        Task {
            do {
                let isSubscribed = try await model.getSubscription(channelId: Constants.channelId).items?.id != nil
                
                if isSubscribed {
                    self.subscribeButton.setTitle("Subscribed!", for: .normal)
                } else {
                    self.subscribeButton.setTitle("Subscribe", for: .normal)
                }
                
            } catch {
                print(error)
            }
        }
    }
}
