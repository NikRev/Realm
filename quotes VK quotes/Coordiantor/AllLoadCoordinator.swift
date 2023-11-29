import UIKit

class AllLoadCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let allLoad = AllLoad()
        allLoad.title = "Сортировка загрузок"
        let allPhoto = UIImage(systemName: "square.and.pencil.circle.fill")
        allLoad.tabBarItem = UITabBarItem(title: "Сортировка загрузок", image: allPhoto, tag: 2)
        navigationController.setViewControllers([allLoad], animated: true)
    }
}
