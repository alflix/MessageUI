//
//  TransparentSlideViewController.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

///
/// Set the navigationBar property in viewWillAppear
///
/// Why do you set properties in viewWillAppear instead of viewDidLoad?
/// - When enter to TransparentSlideViewController(B) from TransparentSlideViewController(A),
/// - viewDidLoad in B will take precedence over viewWillDisappear in A, so that it cannot recover state before displaying B.
///
/// Modifying the titleTextAttributes of navigationBar does not necessarily take effect immediately, so adjust the attributedText of the custom titleView instead.
///
open class TransparentSlideViewController: SegementSlideViewController {
    public typealias DisplayEmbed<T> = (display: T, embed: T)

    private weak var parentScrollView: UIScrollView?
    private var titleLabel: UILabel!
    private var hasEmbed: Bool = false
    private var hasDisplay: Bool = false

    public weak var storedNavigationController: UINavigationController?
    public var storedNavigationBarIsTranslucent: Bool?
    public var storedNavigationBarBarStyle: UIBarStyle?
    public var storedNavigationBarBarTintColor: UIColor?
    public var storedNavigationBarTintColor: UIColor?
    public var storedNavigationBarShadowImage: UIImage?
    public var storedNavigationBarBackgroundImage: UIImage?

    open override var headerView: UIView {
        #if DEBUG
        assert(false, "must override this variable")
        #endif
        return UIView()
    }

    open var attributedTexts: DisplayEmbed<NSAttributedString?> {
        return (nil, nil)
    }

    open override var bouncesType: BouncesType {
        return .child
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTitleLabel()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
        navigationAppearance.backgroundAlpha = 0
        setupTitleLabel()
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        layoutTitleLabel()
        navigationItem.titleView = titleLabel
    }

    private func layoutTitleLabel() {
        let titleSize: CGSize
        if let navigationController = navigationController {
            titleSize = CGSize(width: navigationController.navigationBar.bounds.width*3/5,
                               height: navigationController.navigationBar.bounds.height)
        } else {
            titleSize = CGSize(width: view.bounds.width*3/5, height: 44)
        }
        if #available(iOS 11, *) {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.widthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: titleSize.width)
            titleLabel.heightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: titleSize.height)
        } else {
            titleLabel.bounds = CGRect(origin: .zero, size: titleSize)
        }
    }

    public override func reloadData() {
        super.reloadData()
        reloadTitleLabel()
    }

    public override func reloadHeader() {
        super.reloadHeader()
        reloadTitleLabel()
    }

    open override func scrollViewDidScroll(_ scrollView: UIScrollView, isParent: Bool) {
        guard isParent else { return }
        if parentScrollView == nil {
            parentScrollView = scrollView
            return
        }
        navigationAppearance.backgroundAlpha = max(0, scrollView.contentOffset.y/headerStickyHeight)
        if scrollView.contentOffset.y >= headerStickyHeight {
            if hasEmbed { return }
            hasEmbed = true
            hasDisplay = false
            updateTitleLabel(scrollView)
        } else {
            if hasDisplay { return }
            hasDisplay = true
            hasEmbed = false
            updateTitleLabel(scrollView)
        }
    }

    func reloadTitleLabel() {
        guard let parentScrollView = parentScrollView else { return }
        hasDisplay = false
        hasEmbed = false
        updateTitleLabel(parentScrollView)
    }
}

extension TransparentSlideViewController {
    private func updateTitleLabel(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= headerStickyHeight {
            titleLabel.attributedText = attributedTexts.embed
            titleLabel.layer.add(generateFadeAnimation(), forKey: "reloadTitleLabel")
        } else {
            titleLabel.attributedText = attributedTexts.display
            titleLabel.layer.add(generateFadeAnimation(), forKey: "reloadTitleLabel")
        }
    }

    private func generateFadeAnimation() -> CATransition {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.25
        fadeTextAnimation.type = .fade
        return fadeTextAnimation
    }
}
