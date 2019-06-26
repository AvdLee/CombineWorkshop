//
//  RoundedButton.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 20/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit

final class RoundedButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            updateForEnabled()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = 10
        updateForEnabled()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        layer.cornerRadius = frame.size.height / 2
    }

    private func updateForEnabled() {
        layer.opacity = isEnabled ? 1.0 : 0.5
    }

}
