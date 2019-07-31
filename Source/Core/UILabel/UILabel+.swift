//
//  UILabel+Extension.swift
//  GGUI
//
//  Created by John on 2019/2/18.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 设置富文本并对其中某些文字添加点击事件
    ///
    /// - Parameters:
    ///   - attrText: 富文本
    ///   - patterns: 需要响应点击事件的文字数组
    ///   - tapAction: 点击事件
    func addClickAction(by attrText: NSAttributedString, toRangesMatching patterns: [String], tapAction: StringBlock?) {
        attributedText = attrText
        isUserInteractionEnabled = true
        guard patterns.count > 0 else { return }
        var matches: [NSTextCheckingResult] = []

        patterns.forEach { (pattern) in
            do {
                let pattern = try NSRegularExpression(pattern: "\\Q\(pattern)\\E")
                let patternMatches = pattern.matches(in: attrText.string,
                                                     range: NSRange(attrText.string.startIndex..., in: attrText.string))
                matches.append(contentsOf: patternMatches)
            } catch let error {
                DPrint("invalid regex: \(error.localizedDescription)")
            }
        }

        onTap { [weak self] (tap) in
            guard let strongSelf = self else { return }
            for match in matches where strongSelf.didTap(in: match.range, tap: tap) {
                let text = attrText.attributedSubstring(from: match.range)
                tapAction?(text.string)
            }
        }
    }

    private func didTap(in targetRange: NSRange, tap: UITapGestureRecognizer) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        let labelSize = bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = tap.location(in: self)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)

        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
