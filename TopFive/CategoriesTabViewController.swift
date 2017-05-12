
import Foundation
import UIKit

class CategoriesViewController: UIViewController {
    
    var categoriesStackView: CategoriesStackView!
    var viewModel: OnboardingViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        viewModel = OnboardingViewModel()
        setupCategoriesStackView()
    }
    
    func setupCategoriesStackView() {
        categoriesStackView = CategoriesStackView.init(categoryViews: viewModel.createCategories(),
                                                       stackSpacing: 25,
                                                       itemWidth: 100,
                                                       axis: .vertical)
        view.addSubview(categoriesStackView)
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        categoriesStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        categoriesStackView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        categoriesStackView.center(in: view)
    }

}