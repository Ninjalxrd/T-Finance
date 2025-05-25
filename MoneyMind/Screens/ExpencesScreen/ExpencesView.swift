//
//  ExpencesView.swift
//  MoneyMind
//
//  Created by Павел on 26.04.2025.
//

import UIKit

final class ExpencesView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = DefaultLabel(numberOfLines: 1, text: "Расходы")
        return label
    }()
    
    private lazy var dateSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["День", "Неделя", "Месяц", "Год"])
        
        return segmentControl
    }()
    
    private lazy var expencesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }
    
}
