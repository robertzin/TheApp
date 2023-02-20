//
//  LoadingViewController.swift
//  theApp
//
//  Created by Robert Zinyatullin on 20.02.2023.
//

import UIKit

final class LoadingViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loadingLogo") ?? UIImage()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.showInitialView()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = Constants.Colors.backgroundColor
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(150)
            make.center.equalToSuperview()
        }
    }
    
    private func showInitialView() {
        self.dismiss(animated: true)
        PresenterManager.shared.show(vc: .login)
    }
}
