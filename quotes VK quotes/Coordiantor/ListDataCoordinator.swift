import UIKit

class ListDataCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let listData = ListData()
        listData.title = "База Шуток"
        let listPhoto = UIImage(systemName: "square.and.pencil.circle")
        listData.tabBarItem = UITabBarItem(title: "База Шуток", image: listPhoto, tag: 1)
        navigationController.setViewControllers([listData], animated: true)
    }
}
