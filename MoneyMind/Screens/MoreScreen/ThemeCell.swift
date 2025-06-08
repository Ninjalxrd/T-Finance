import UIKit
import SnapKit
import Combine

final class ThemeCell: UITableViewCell {
    // MARK: - Publishers
    
    private let systemThemeSubject = PassthroughSubject<Void, Never>()
    var systemThemePublisher: AnyPublisher<Void, Never> {
        systemThemeSubject.eraseToAnyPublisher()
    }
    private let lightThemeSubject = PassthroughSubject<Void, Never>()
    var lightThemePublisher: AnyPublisher<Void, Never> {
        lightThemeSubject.eraseToAnyPublisher()
    }
    private let darkThemeSubject = PassthroughSubject<Void, Never>()
    var darkThemePublisher: AnyPublisher<Void, Never> {
        darkThemeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    
    private var selectedThemeButton: UIButton?
    private var bag: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .component
        view.layer.cornerRadius = Size.cornerRadius
        return view
    }()
    
    private lazy var systemAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.systemThemeSubject.send()
        self.selectTheme(button: self.systemThemeButton)
    }
    private lazy var lightAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.lightThemeSubject.send()
        self.selectTheme(button: self.lightThemeButton)
    }
    private lazy var darkAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.darkThemeSubject.send()
        self.selectTheme(button: self.darkThemeButton)
    }
    
    private lazy var systemThemeButton: UIButton = {
        let button = createThemeButton(
            title: "Системная",
            subtitle: "Такая же,\nкак на устройстве",
            image: nil,
            action: systemAction
        )
        return button
    }()
    
    private lazy var lightThemeButton: UIButton = {
        let button = createThemeButton(
            title: "Светлая",
            subtitle: nil,
            image: UIImage(systemName: "sun.max"),
            action: lightAction
        )
        return button
    }()
    
    private lazy var darkThemeButton: UIButton = {
        let button = createThemeButton(
            title: "Тёмная",
            subtitle: nil,
            image: UIImage(systemName: "moon.stars"),
            action: darkAction
        )
        return button
    }()
    
    private lazy var themeButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            systemThemeButton,
            lightThemeButton,
            darkThemeButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = Spacing.smallest
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        applySavedThemeSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(themeButtonsStackView)
        
        backgroundContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Spacing.small)
        }
        
        themeButtonsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Spacing.small)
        }
    }
    
    // MARK: - Button Creation
    
    private func createThemeButton(title: String, subtitle: String?, image: UIImage?, action: UIAction) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .background
        configuration.baseForegroundColor = .text
        configuration.cornerStyle = .large
        configuration.title = title
        configuration.subtitle = subtitle
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = Spacing.smallest
        
        let button = UIButton(configuration: configuration)
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    // MARK: - Selection Logic
    
    private func applySavedThemeSelection() {
        switch UserManager.shared.theme.getUserInterfaceStyle() {
        case .unspecified:
            selectTheme(button: systemThemeButton)
        case .light:
            selectTheme(button: lightThemeButton)
        case .dark:
            selectTheme(button: darkThemeButton)
        @unknown default:
            selectTheme(button: systemThemeButton)
        }
    }
    
    private func selectTheme(button: UIButton?) {
        selectedThemeButton?.layer.borderWidth = 0
        guard let button else { return }
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.brand.cgColor
        button.layer.cornerRadius = Size.cornerRadius
        selectedThemeButton = button
    }
    
    // MARK: - Identifier
    
    static var identifier: String {
        String(describing: self)
    }
}
