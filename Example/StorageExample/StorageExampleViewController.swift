//
//  StorageExampleViewController.swift
//  MultiProgressViewExample
//
//  Created by Mac Gallagher on 7/7/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit
import MultiProgressView

class StorageExampleViewController: UIViewController {
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.StorageExample.borderColor.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    private lazy var progressView: MultiProgressView = {
        let progress = MultiProgressView()
        progress.trackBackgroundColor = UIColor.StorageExample.progressBackground
        progress.lineCap = .round
        progress.cornerRadius = progressViewHeight / 4
        return progress
    }()
    
    private let animateButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.tag = 1
        button.setTitle("Animate", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.tag = 2
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .equalSpacing
        sv.alignment = .center
        return sv
    }()
    
    private let iPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "iPhone"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let dataUsedLabel: UILabel = {
        let label = UILabel()
        label.text = "0 GB of 64 GB Used"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let padding: CGFloat = 15
    private let progressViewHeight: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.StorageExample.backgroundGray
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.safeAreaLayoutGuide.leftAnchor,
                              right: view.safeAreaLayoutGuide.rightAnchor,
                              paddingTop: 50)
        
        setupLabels()
        setupProgressBar()
        setupStackView()
        setupButtons()
    }
    
    private func setupLabels() {
        backgroundView.addSubview(iPhoneLabel)
        iPhoneLabel.anchor(top: backgroundView.topAnchor,
                           left: backgroundView.leftAnchor,
                           paddingTop: padding,
                           paddingLeft: padding)

        backgroundView.addSubview(dataUsedLabel)
        dataUsedLabel.anchor(top: backgroundView.topAnchor,
                             right: backgroundView.rightAnchor,
                             paddingTop: padding,
                             paddingRight: padding)
    }
    
    private func setupProgressBar() {
        backgroundView.addSubview(progressView)
        progressView.anchor(top: iPhoneLabel.bottomAnchor,
                            left: backgroundView.leftAnchor,
                            right: backgroundView.rightAnchor,
                            paddingTop: padding,
                            paddingLeft: padding,
                            paddingRight: padding,
                            height: progressViewHeight)
        progressView.dataSource = self
    }
    
    private func setupStackView() {
        backgroundView.addSubview(stackView)
        stackView.anchor(top: progressView.bottomAnchor,
                         left: backgroundView.leftAnchor,
                         bottom: backgroundView.bottomAnchor,
                         right: backgroundView.rightAnchor,
                         paddingTop: padding,
                         paddingLeft: padding,
                         paddingBottom: padding,
                         paddingRight: padding)
        
        for type in StorageType.allTypes {
            if type != .unknown {
                stackView.addArrangedSubview(StorageStackView(storageType: type))
            }
        }
        stackView.addArrangedSubview(UIView())
    }
    
    private func setupButtons() {
        view.addSubview(resetButton)
        resetButton.anchor(top: backgroundView.bottomAnchor,
                           paddingTop: 50)
        NSLayoutConstraint(item: resetButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 0.5,
                           constant: 0).isActive = true
        
        view.addSubview(animateButton)
        animateButton.anchor(top: backgroundView.bottomAnchor,
                           paddingTop: 50)
        NSLayoutConstraint(item: animateButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1.5,
                           constant: 0).isActive = true
    }
    
    @objc private func handleTap(_ button: UIButton) {
        switch button.tag {
        case 1:
            animateProgress()
        case 2:
            resetProgress()
        default:
            break
        }
    }
    
    private func animateProgress() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: .curveLinear,
                       animations: {
            self.progressView.setProgress(section: 0, to: 0.4)
            self.progressView.setProgress(section: 1, to: 0.15)
            self.progressView.setProgress(section: 2, to: 0.1)
            self.progressView.setProgress(section: 3, to: 0.1)
            self.progressView.setProgress(section: 4, to: 0.05)
            self.progressView.setProgress(section: 5, to: 0.03)
            self.progressView.setProgress(section: 6, to: 0.03)
        })
        dataUsedLabel.text = "56.5 GB of 64 GB Used"
    }
    
    private func resetProgress() {
        UIView.animate(withDuration: 0.1) {
            self.progressView.resetProgress()
        }
        dataUsedLabel.text = "0 GB of 64 GB Used"
    }
}

//MARK: - Data Source

extension StorageExampleViewController: MultiProgressViewDataSource {
    public func numberOfSections(in progressBar: MultiProgressView) -> Int {
        return 7
    }
    
    public func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let bar = StorageProgressSection()
        bar.configure(withStorageType: StorageType(rawValue: section) ?? .other)
        return bar
    }
}
