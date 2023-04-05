//
//  ViewExtension.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit

extension UIView {
    /// Convenience function to ease creating new views.
    ///
    /// Calling this function creates a new view with `translatesAutoresizingMaskIntoConstraints`
    /// set to false. Passing in an optional closure to do further configuration of the view.
    ///
    /// - Parameter builder: A function that takes the newly created view.
    ///
    /// Usage:
    /// ```
    ///    private let button: UIButton = .build { button in
    ///        button.setTitle("Tap me!", for state: .normal)
    ///        button.backgroundColor = .systemPink
    ///    }
    /// ```
    static func build<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        builder?(view)

        return view
    }

    /// Convenience function to add multiple subviews
    /// - Parameter views: A variadic parameter taking in a list of views to be added.
    ///
    /// Usage:
    /// ```
    ///    view.addSubviews(headerView, contentView, footerView)
    /// ```
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}

extension UILabel {
    func setMargins(margin: CGFloat = 10) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

extension UIScrollView {
    func fitSizeOfContent() {
        let sumHeight = self.subviews.map({$0.frame.size.height}).reduce(0, {x, y in x + y})
        self.contentSize = CGSize(width: self.frame.width, height: sumHeight)
    }
}
