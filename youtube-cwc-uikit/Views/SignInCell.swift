//
//  SignInCell.swift
//  youtube-cwc-uikit
//
//  Created by Leonardo de Oliveira on 04/07/23.
//

import UIKit
import GoogleSignIn

class SignInCell: UITableViewCell {
    
    private var signInButton: GIDSignInButton = {
        let view = GIDSignInButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    weak var delegate: SignInDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.setupViews()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(signInButton)
        
        signInButton.addAction(
            UIAction { _ in
                self.delegate?.onTapSignIn()
            },
            for: .touchUpInside
        )
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            signInButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            signInButton.bottomAnchor.constraint(greaterThanOrEqualTo: self.contentView.bottomAnchor)
        ])
    }
}
