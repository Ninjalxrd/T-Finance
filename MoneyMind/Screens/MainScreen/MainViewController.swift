//
//  MainViewController.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    private let mainView: MainView = .init(frame: .zero)
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
