import UIKit

final class MainTabBarController: UITabBarController {
    private let firstCoordinator = RandomLoadCoordinator(navigationController: UINavigationController())
    private let secondVC = AllLoadCoordinator(navigationController: UINavigationController())
    private let thirdCoordinator = ListDataCoordinator(navigationController: UINavigationController())

    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
    }

    func setController() {
        viewControllers = [
            firstCoordinator.navigationController,
            secondVC.navigationController,
            thirdCoordinator.navigationController,
        ]

        // Вызываем метод start() для начала координаторов
        firstCoordinator.start()
        secondVC.start()
        thirdCoordinator.start()
    }
}
