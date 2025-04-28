//
//  EnterNameViewController.swift
//  MoneyMind
//
//  Created by Павел on 25.04.2025.
//

import UIKit

final class EnterNameViewController: UIViewController {
    // MARK: - Properties
    private let enterNameView: EnterNameView = .init()
    private let viewModel: EnterNameViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: EnterNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = enterNameView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(123)
    }
}
