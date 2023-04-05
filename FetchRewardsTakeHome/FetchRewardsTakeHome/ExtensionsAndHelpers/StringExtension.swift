//
//  StringExtension.swift
//  FetchRewardsTakeHome
//
//  Created by Delstun McCray on 4/5/23.
//

import Foundation
import UIKit
extension String {

   func removingAllWhitespaces() -> String {
       return removingCharacters(from: .whitespaces)
   }

   func removingCharacters(from set: CharacterSet) -> String {
       var newString = self
       newString.removeAll { char -> Bool in
           guard let scalar = char.unicodeScalars.first else { return false }
           return set.contains(scalar)
       }
       return newString
   }
}

class PaddingLabel: UILabel {

    var edgeInset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: edgeInset.top, left: edgeInset.left, bottom: edgeInset.bottom, right: edgeInset.right)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInset.left + edgeInset.right, height: size.height + edgeInset.top + edgeInset.bottom)
    }
}
