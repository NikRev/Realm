import UIKit

class QuotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var quotes: [QuoteObject] = []
    var categoryName: String?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var addButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func addButtonTapped() {
        let presenter = QuotePresenter()
        presenter.delegate = self
        presenter.categoryName = categoryName // Set the category name
        present(presenter, animated: true, completion: nil)
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

        navigationItem.title = categoryName
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = quote.text
        cell.textLabel?.numberOfLines = 0 // Allow multiple lines
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension QuotesViewController: QuotePresenterDelegate {
    func didAddQuote(_ quote: String, categoryName: String?) {
        // Check if the category name matches the current category
        if self.categoryName == categoryName {
            // Add the new quote to the quotes array
            let newQuote = QuoteObject()
            newQuote.text = quote
            quotes.append(newQuote)

            // Reload the table view to display the new quote
            tableView.reloadData()
        }
    }
}
