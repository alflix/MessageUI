//
//  SendCodeButton.swift
//  GGUI
//
//  Created by John on 2019/3/12.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import SwiftTimer

@IBDesignable
open class CountdownButton: CustomButton {
    private var timer: SwiftCountDownTimer?
    /// 未倒数时文字
    private var normalTitle: String?
    /// 倒数结束后显示的文字，nil 时显示倒数前的文字
    @IBInspectable open dynamic var finishNormalTitle: String? = GGUI.CountdownButton.finishNormalTitle
    /// xxx秒，「秒」这个文字的设置
    @IBInspectable open dynamic var secondsTitle = GGUI.CountdownButton.secondsTitle
    /// 总秒数
    @IBInspectable open dynamic var seconds = GGUI.CountdownButton.seconds
    /// 倒数时显示的文字（不包含「xxx秒」部分的文字）
    @IBInspectable open dynamic var disableTitle: String = GGUI.CountdownButton.disableTitle
    /// 是否正在倒计时
    private(set) public var isCountdowning: Bool = false

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required public init(frame: CGRect) {
        super.init(frame: frame)
    }

    override open dynamic var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            if self.isEnabled == isEnabled { return }
            if isEnabled {
                layer.borderColor = titleColor(for: .normal)?.cgColor
            } else {
                layer.borderColor = titleColor(for: .disabled)?.cgColor
            }
        }
    }

    /// 开始倒计时
    open func startTimer() {
        normalTitle = title(for: .normal)
        guard isEnabled else { return }
        timer = SwiftCountDownTimer(interval: .fromSeconds(1), times: seconds, handler: { [weak self] (_, seconds) in
            guard let strongSelf = self else { return }
            if seconds > 0 {
                strongSelf.isCountdowning = true
                strongSelf.setupDisableCodeTitle(left: seconds)
            } else {
                strongSelf.isCountdowning = false
                strongSelf.setupNormalCodeTitle()
            }
        })
        timer?.start()
    }

    /// 结束倒计时
    open func invalidateTimer() {
        timer = nil
        setupNormalCodeTitle()
    }

    private func setupNormalCodeTitle() {
        isEnabled = true
        if let finishNormalTitle = finishNormalTitle {
            setTitleForAllStates(finishNormalTitle)
        } else if let normalTitle = normalTitle {
            setTitleForAllStates(normalTitle)
        }
    }

    private func setupDisableCodeTitle(left: Int) {
        isEnabled = false
        let disableTitlePrex = self.disableTitle.count > 0 ? (self.disableTitle + "") : ""
        let disableTitle = disableTitlePrex + "\(left)" + secondsTitle
        setTitleForAllStates(disableTitle)
    }
}
