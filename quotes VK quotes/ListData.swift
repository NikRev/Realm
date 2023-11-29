import UIKit
import RealmSwift

class ListData:UIViewController, UITableViewDataSource, UITableViewDelegate{

    var quotes: Results<QuoteObject>!
    let realm: Realm

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadQuotes()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
           // Set up the configuration
           let config = Realm.Configuration(schemaVersion: 6)
           // Use the configuration to initialize the realm
           self.realm = try! Realm(configuration: config)
           
           super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
           
        setupTableView()
        loadQuotes()
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

    func loadQuotes() {
        // Загрузка цитат из Realm, отсортированных по дате
        quotes = realm.objects(QuoteObject.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
   
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return quotes.count
      }

    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let quote = quotes[indexPath.row]

        // Установите numberOfLines для textLabel
        cell.textLabel?.numberOfLines = 0

        // Установите текст с учетом шутки и даты
        cell.textLabel?.text = "\(quote.text) (\(formattedDate(quote.date)))"

        return cell
    }

    // В этом методе вы можете рассчитать и установить высоту строки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // высота содержимого в ячейке (шутки и даты)
        let quote = quotes[indexPath.row]
        let text = "\(quote.text) (\(formattedDate(quote.date)))"

        // Установите желаемую высоту строки, например, основываясь на высоте текста
        let textHeight = text.height(withConstrainedWidth: tableView.frame.width, font: UIFont.systemFont(ofSize: 17))
        // Добавьте какую-то дополнительную высоту (если нужно)
        let additionalHeight: CGFloat = 35

        return textHeight + additionalHeight
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

      // MARK: - Helper Methods

      func formattedDate(_ date: Date) -> String {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
          return formatter.string(from: date)
      }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
