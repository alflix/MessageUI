//
//  UITableView+.swift
//  GGUI
//
//  Created by John on 2018/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UITableView {
    func cancelEstimatedHeight() {
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
    }

    func cancelHeaderAndFooter() {
        cancelHeader()
        cancelFooter()
    }

    func cancelHeader() {
        setHeader(height: CGFloat.leastNonzeroMagnitude)
    }

    func cancelFooter() {
        setFooter(height: CGFloat.leastNonzeroMagnitude)
    }

    func setHeader(height: CGFloat) {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }

    func setFooter(height: CGFloat) {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    }

    func cancelSectionHeaderAndFooter() {
        cancelSectionHeader()
        cancelSectionFooter()
    }

    func cancelSectionHeader() {
        sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
    }

    func cancelSectionFooter() {
        sectionFooterHeight = CGFloat.leastNonzeroMagnitude
    }

    /// Set table header view & add Auto layout.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        self.tableHeaderView = headerView

        // Then setup AutoLayout.
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        updateHeaderViewFrame()
    }

    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = self.tableHeaderView else { return }

        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }

    func setTableFooterView(footerView: UIView) {
        footerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        self.tableFooterView = footerView

        // Then setup AutoLayout.
        footerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        footerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        updateFooterViewFrame()
    }

    /// Update header view's frame.
    func updateFooterViewFrame() {
        guard let footerView = self.tableFooterView else { return }

        // Update the size of the header based on its internal content.
        footerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let footer = self.tableFooterView
        self.tableFooterView = footer
    }

    /// 滑动到底部(比 SwifterSwift 中的 scrollToBottom 更好用，因此称为 smartScrollToBottom)
    ///
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - excludeHeight: 不用于计算的高度，例如键盘弹起时的键盘高度
    func smartScrollToBottom(animated: Bool = true, excludeHeight: CGFloat = 0) {
        guard contentSize.height > bounds.size.height else { return }
        let offsetY = max(0, contentSize.height - bounds.size.height - (contentInset.top + contentInset.bottom) + excludeHeight)
        let bottomOffset = CGPoint(x: 0, y: offsetY)
        setContentOffset(bottomOffset, animated: animated)
    }
}
