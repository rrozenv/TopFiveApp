
import Foundation
import UIKit

enum ScrollDirection {
    case horizontal, vertical
}

extension UIStackView {
    convenience init(views: [CategoryView], spacing: CGFloat, axis: ScrollDirection) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        switch axis {
        case .horizontal:
            self.axis = .horizontal
        default:
            self.axis = .vertical
        }
        self.spacing = spacing
        self.distribution = .fillEqually
        
        for view in views {
            addArrangedSubview(view)
        }
    }
}

extension UIView {
    func constrainEdges(to view: UIView) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func constrainToBottom(of view: UIView, with height: CGFloat) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    enum DeviceFrame {
        case width
        case height
    }
    
    func constrainEqual(_ side: DeviceFrame, to view: UIView) {
        switch side {
        case .width:
            self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        case .height:
            self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        }
    }
    
    func center(in view: UIView) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
