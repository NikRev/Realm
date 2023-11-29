import UIKit
import RealmSwift



class RandomLoad: UIViewController {
    
    var listDataController: ListData?
    weak var delegate: RandomLoadDelegate?
    let realm: Realm
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Set up the configuration with the latest schema version
        let config = Realm.Configuration(schemaVersion: 6, migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 6 {
                // Perform your migration here if needed
                migration.enumerateObjects(ofType: QuoteObject.className()) { oldObject, newObject in
                    // Ensure the primary key is unique
                    let newID = UUID().uuidString
                    newObject!["id"] = newID
                }
            }
        })
        
        self.realm = try! Realm(configuration: config)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let jokeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Press the button to load a joke"
        return label
    }()

    let loadJokeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load Joke", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Показываем кнопку при загрузке
        loadJokeButton.isHidden = false
       

        setupUI()
    }

    func setupUI() {
        view.addSubview(jokeLabel)
        view.addSubview(loadJokeButton)

        NSLayoutConstraint.activate([
            jokeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jokeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            jokeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            jokeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            loadJokeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadJokeButton.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor, constant: 20),
        ])

        loadJokeButton.addTarget(self, action: #selector(loadJokeButtonTapped), for: .touchUpInside)
    }

    @objc func loadJokeButtonTapped() {
        // Скрываем кнопку перед загрузкой
        loadJokeButton.isHidden = true
        fetchJoke()
    }

    // Добавление цитаты в Realm
    func addQuoteToRealm(text: String) {
        let quote = QuoteObject()
        quote.text = text
        do{
            try realm.write {
                realm.add(quote)
            }
        } catch{
            print(error)
        }
       
    }

    
    func fetchJoke() {
        JsonCodableDataTask().fetchJoke { [weak self] result in
            switch result {
            case .success(let jsonModel):
                DispatchQueue.main.async {
                    self?.jokeLabel.text = jsonModel.value
                    self?.addQuoteToRealm(text: jsonModel.value)
                    // Добавление цитаты с категорией в базу данных
                  //  self?.addQuoteToRealmWithCategory(text: jsonModel.value, category: "Шутки номер 1")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.jokeLabel.text = "Failed to load joke. Error: \(error.localizedDescription)"
                }
            }

            // Показываем кнопку после получения ответа
            self?.loadJokeButton.isHidden = false
        }
    }

}
