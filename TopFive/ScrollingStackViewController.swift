
import Foundation
import UIKit

final class CategoriesStackView: UIView {
    var scrollView: UIScrollView
    let stackView: UIStackView
    let categoryViews: [CategoryView]
    let stackSpacing: CGFloat
    let scrollDirection: ScrollDirection
  
    init(categoryViews: [CategoryView], stackSpacing: CGFloat, itemWidth: Int, axis: ScrollDirection) {
        self.categoryViews = categoryViews
        self.stackSpacing = stackSpacing
        self.scrollDirection = axis
        self.stackView = UIStackView(views: categoryViews, spacing: stackSpacing, axis: axis)
        scrollView = UIScrollView()
        super.init(frame: .zero)
        setupScrollView()
        setupStackViewWith(itemWidth: itemWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        scrollView.constrainEdges(to: self)
    }
    
    func setupStackViewWith(itemWidth: Int) {
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        switch scrollDirection {
        case .horizontal:
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            let stackWidth = CGFloat(categoryViews.count * itemWidth) + (stackSpacing * CGFloat(categoryViews.count-1))
            stackView.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        default:
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            let stackHeight = CGFloat(categoryViews.count * itemWidth) + (stackSpacing * CGFloat(categoryViews.count-1))
            stackView.heightAnchor.constraint(equalToConstant: stackHeight).isActive = true
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        
    }
    
}

