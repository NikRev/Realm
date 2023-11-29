import UIKit
import RealmSwift

class AllLoad: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var categoriesWithQuotes: [CategoryWithQuotes] = []
    let realm: Realm

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let config = Realm.Configuration(schemaVersion: 4)
        self.realm = try! Realm(configuration: config)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        loadCategoriesWithQuotes()
        setupUI()
    }

    func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func loadCategoriesWithQuotes() {
        self.categoriesWithQuotes = loadCategoriesWithQuotesFromRealm()
        tableView.reloadData()
    }

    func loadCategoriesWithQuotesFromRealm() -> [CategoryWithQuotes] {
        let allCategories = realm.objects(CategoryObject.self)
        var categoriesWithQuotes: [CategoryWithQuotes] = []

        for category in allCategories {
            let quotesForCategory = Array(category.quotes)
            let categoryWithQuotes = CategoryWithQuotes(category: category, quotes: quotesForCategory)
            categoriesWithQuotes.append(categoryWithQuotes)
        }

        return categoriesWithQuotes
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesWithQuotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let categoryWithQuotes = categoriesWithQuotes[indexPath.row]
        cell.textLabel?.text = categoryWithQuotes.category.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategoryWithQuotes = categoriesWithQuotes[indexPath.row]
        let quotesForCategory = selectedCategoryWithQuotes.quotes

        // Создаем новый контроллер для отображения цитат выбранной категории
        let quotesViewController = QuotesViewController()
        quotesViewController.quotes = quotesForCategory
        quotesViewController.categoryName = selectedCategoryWithQuotes.category.name

        // Переходим к новому контроллеру
        navigationController?.pushViewController(quotesViewController, animated: true)
    }


    func addCategoryToRealm(name: String) {
        let newCategory = CategoryObject()
        newCategory.name = name

        do {
            try realm.write {
                realm.add(newCategory)
            }
        } catch {
            print(error)
        }

        loadCategoriesWithQuotes()
    }

    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Новая категория", message: "Введите название категории", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Название"
        }

        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            if let categoryName = alertController.textFields?.first?.text {
                self?.addCategoryToRealm(name: categoryName)
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func setupUI() {
        // Добавление кнопки для добавления новой категории
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
}
