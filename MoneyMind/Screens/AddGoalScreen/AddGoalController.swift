//
//  AddGoalController.swift
//  MoneyMind
//
//  Created by Павел on 06.06.2025.
//

import UIKit
import SnapKit
import Combine

enum GoalViewMode {
    case create
    case edit
}

final class AddGoalController: UIViewController {
    private var bag: Set<AnyCancellable> = []
    private let addGoalView: AddGoalView
    private let viewModel: AddGoalViewModel
    private let goal: Goal?
    private let mode: GoalViewMode
    
    // MARK: - Lifecycle
    
    init(mode: GoalViewMode, viewModel: AddGoalViewModel, goal: Goal?) {
        self.addGoalView = AddGoalView(mode: mode)
        self.mode = mode
        self.viewModel = viewModel
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = addGoalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        bindViewModel()
        setupNavigationBar()
        if mode == .edit {
            setupEditUI()
        }
    }
    
    private func setupCallbacks() {
        addGoalView.deadlinePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.openDatePicker()
            }
            .store(in: &bag)
        
        addGoalView.addPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.saveGoal()
            }
            .store(in: &bag)
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupEditUI() {
        guard let goal else { return }
        addGoalView.setupEditView(goal: goal)
        viewModel.nameText = goal.name
        viewModel.descriptionText = goal.description
        viewModel.amountText = Int(goal.amount).description
        viewModel.dateWasPicked = true
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ru_RU")

        if let parsedDate = formatter.date(from: goal.term) {
            viewModel.date = parsedDate
            viewModel.dateSubject.send(parsedDate)
        } else {
            print("fail to parse date from string: \(goal.term)")
        }
    }
    
    private func bindViewModel() {
        addGoalView.namePublisher
            .assign(to: \.nameText, on: viewModel)
            .store(in: &bag)
        
        addGoalView.descriptionPublisher
            .assign(to: \.descriptionText, on: viewModel)
            .store(in: &bag)
        
        addGoalView.amountPublisher
            .assign(to: \.amountText, on: viewModel)
            .store(in: &bag)
        
        viewModel.isFormValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.addGoalView.setSaveButtonEnabled(isValid)
            }
            .store(in: &bag)
        
        viewModel.dateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self else { return }
                if self.viewModel.dateWasPicked {
                    viewModel.date = date
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ru_RU")
                    formatter.dateStyle = .long
                    formatter.timeStyle = .none

                    let dateString = formatter.string(from: date)
                    self.addGoalView.setDeadlineTitle(dateString)
                }
            }
            .store(in: &bag)
    }
}
