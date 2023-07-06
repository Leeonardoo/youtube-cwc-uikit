//
//  ViewController.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 28/06/23.
//

import UIKit
import GoogleSignIn

class ListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let model = Model()
    private var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupConstraints()
        
        self.loadData()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .systemBackground
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(VideoCell.self, forCellReuseIdentifier: Constants.videoCellId)
        self.tableView.register(SignInCell.self, forCellReuseIdentifier: Constants.signInCellId)
        self.view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        Task {
            do {
                self.videos = try await model.getVideos().items ?? []
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

//MARK: - DataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard videos.count > 0 else { return 0 }
        
        let hasPreviousSignIn = GIDSignIn.sharedInstance.hasPreviousSignIn()
        
        return videos.count + (!hasPreviousSignIn ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < videos.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.videoCellId, for: indexPath) as! VideoCell
            
            let video = self.videos[indexPath.row]
            cell.video = video
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.signInCellId, for: indexPath) as! SignInCell
            cell.delegate = self
            
            return cell
        }
    }
}

//MARK: - TableView
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < videos.count else { return }
        
        let video = self.videos[indexPath.row]
        let viewController = DetailViewController(video)
        
        self.present(viewController, animated: true)
    }
}

//MARK: - SignIn
extension ListViewController: SignInDelegate {
    
    func onTapSignIn() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self, hint: nil, additionalScopes: ["https://www.googleapis.com/auth/youtube"]) { signInResult, error in
            guard error == nil else {
                print(String(describing: error))
                return
            }
            
            token = signInResult?.user.accessToken.tokenString ?? ""
            print("Token: \(token)")
            self.tableView.reloadData()
        }
    }
}
