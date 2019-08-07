//
//  SingleLineButton.swift
//  GGUI
//
//  Created by John on 2019/5/21.
//

import UIKit

/// 可以方便的对 Button 的上下左右设置横线
class SingleLineButton: UIButton {
    /// 上横线
    @IBInspectable public var top: CGFloat = 0
    /// 左横线
    @IBInspectable public var left: CGFloat = 0
    /// 下横线
    @IBInspectable public var bottom: CGFloat = 0
    /// 右横线
    @IBInspectable public var right: CGFloat = 0
    /// 上横线左右 Offset
    @IBInspectable public var topOffset: CGFloat = 0
    /// 左横线上下 Offset
    @IBInspectable public var leftOffset: CGFloat = 0
    /// 下横线左右 Offset
    @IBInspectable public var bottomOffset: CGFloat = 0
    /// 右横线上下 Offset
    @IBInspectable public var rightOffset: CGFloat = 0

    private lazy var topLineView: SingleLineView = SingleLineView(frame: .zero)
    private lazy var leftLineView: SingleLineView = SingleLineView(frame: .zero)
    private lazy var bottomLineView: SingleLineView = SingleLineView(frame: .zero)
    private lazy var rightLineView: SingleLineView = SingleLineView(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        if top > 0 {
            addSubview(topLineView)
            topLineView.snp.makeConstraints { (make) in
                make.height.equalTo(top)
                make.top.equalToSuperview().offset(topOffset)
                make.leading.trailing.equalToSuperview().offset(topOffset)
            }
        }
        if left > 0 {
            addSubview(leftLineView)
            leftLineView.snp.makeConstraints { (make) in
                make.width.equalTo(left)
                make.leading.equalToSuperview()
                make.top.equalToSuperview().offset(leftOffset)
                make.bottom.equalToSuperview().offset(-leftOffset)
            }
        }
        if bottom > 0 {
            addSubview(bottomLineView)
            bottomLineView.snp.makeConstraints { (make) in
                make.height.equalTo(bottom)
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview().offset(bottomOffset)
            }
        }
        if right > 0 {
            addSubview(rightLineView)
            rightLineView.snp.makeConstraints { (make) in
                make.width.equalTo(right)
                make.trailing.equalToSuperview()
                make.top.equalToSuperview().offset(rightOffset)
                make.bottom.equalToSuperview().offset(-rightOffset)
            }
        }
    }
}
