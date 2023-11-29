import UIKit

class RandomLoadCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let randomLoad = RandomLoad()
        randomLoad.title = "Загрузка цитаты"
        let randomPhoto = UIImage(systemName: "square.and.arrow.down")
        randomLoad.tabBarItem = UITabBarItem(title: "Загрузка цитаты", image: randomPhoto, tag: 0)
        navigationController.setViewControllers([randomLoad], animated: true)
    }
}
