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

    private lazy var topLineView: SingleLineView = {
        let view = SingleLineView(frame: .zero)
        return view
    }()

    private lazy var leftLineView: SingleLineView = {
        let view = SingleLineView(frame: .zero)
        return view
    }()

    private lazy var bottomLineView: SingleLineView = {
        let view = SingleLineView(frame: .zero)
        return view
    }()

    private lazy var rightLineView: SingleLineView = {
        let view = SingleLineView(frame: .zero)
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        if top > 0 {
            addSubview(topLineView)
            topLineView.snp.makeConstraints { (make) in
                make.height.equalTo(top)
                make.leading.trailing.top.equalToSuperview()
            }
        }
        if left > 0 {
            addSubview(leftLineView)
            leftLineView.snp.makeConstraints { (make) in
                make.width.equalTo(left)
                make.leading.top.bottom.equalToSuperview()
            }
        }
        if bottom > 0 {
            addSubview(bottomLineView)
            bottomLineView.snp.makeConstraints { (make) in
                make.height.equalTo(bottom)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
        if right > 0 {
            addSubview(rightLineView)
            rightLineView.snp.makeConstraints { (make) in
                make.width.equalTo(right)
                make.trailing.bottom.top.equalToSuperview()
            }
        }
    }
}
