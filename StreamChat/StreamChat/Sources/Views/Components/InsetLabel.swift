//
//  InsetLabel.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/12.
//

import UIKit

final class InsetLabel: UILabel {

    // MARK: Properties

    private var topInset: CGFloat = .zero
    private var leftInset: CGFloat = .zero
    private var bottomInset: CGFloat = .zero
    private var rightInset: CGFloat = .zero

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += topInset + bottomInset
        contentSize.width += leftInset + rightInset
        return contentSize
    }

    // MARK: Initializers

    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        topInset = top
        leftInset = left
        bottomInset = bottom
        rightInset = right
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Drawing

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
}
