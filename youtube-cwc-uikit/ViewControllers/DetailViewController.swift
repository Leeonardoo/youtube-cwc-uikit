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
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = .preferredFont(forTextStyle: .body)
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, dayLabel, webView, textView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        
        return view
    }()
    
    private var video: Video?
    
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
}
