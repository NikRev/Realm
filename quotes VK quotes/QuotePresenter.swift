import UIKit
import RealmSwift

protocol QuotePresenterDelegate: AnyObject {
    func didAddQuote(_ quote: String, categoryName: String?)
}

class QuotePresenter: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var quotes: [QuoteObject] = []
    var categoryName: String?
    weak var delegate: QuotePresenterDelegate?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var addButton: UIBarButtonItem?
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
        loadQuotesFromRealm()
    }

    func loadQuotesFromRealm() {
        let realm = try! Realm()
        self.quotes = Array(realm.objects(QuoteObject.self))
        tableView.reloadData()
    }

    func setupNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func setupTableView() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter a new quote"
        textField.borderStyle = .roundedRect

        view.addSubview(tableView)
        view.addSubview(textField)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            textField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        addButton?.target = self
        addButton?.action = #selector(addButtonTapped)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = quote.text
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuote = quotes[indexPath.row]

        // Add the selected quote to the category in QuotesViewController
        delegate?.didAddQuote(selectedQuote.text, categoryName: categoryName)

        // Dismiss the QuotePresenter
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Actions

    @objc func addButtonTapped() {
        if let quoteText = textField.text, !quoteText.isEmpty {
            let newQuote = QuoteObject()
            newQuote.text = quoteText

            let realm = try! Realm()
            try! realm.write {
                realm.add(newQuote)
            }

            loadQuotesFromRealm()
            textField.text = ""
        }
    }
}
