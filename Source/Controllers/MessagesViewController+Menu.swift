//
//  MessagesViewController+Menu.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import Foundation

extension MessagesViewController {
    // MARK: - Register / Unregister Observers

    func addMenuControllerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.menuControllerWillShow(_:)),
                                               name: UIMenuController.willShowMenuNotification, object: nil)
    }

    func removeMenuControllerObservers() {
        NotificationCenter.default.removeObserver(self, name: UIMenuController.willShowMenuNotification, object: nil)
    }

    // MARK: - Notification Handlers

    /// Show menuController and set target rect to selected bubble
    @objc
    private func menuControllerWillShow(_ notification: Notification) {

        guard let currentMenuController = notification.object as? UIMenuController,
            let selectedIndexPath = selectedIndexPathForMenu else { return }

        NotificationCenter.default.removeObserver(self, name: UIMenuController.willShowMenuNotification, object: nil)
        defer {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(MessagesViewController.menuControllerWillShow(_:)),
                                                   name: UIMenuController.willShowMenuNotification, object: nil)
            selectedIndexPathForMenu = nil
        }

        currentMenuController.setMenuVisible(false, animated: false)

        guard let selectedCell = messagesCollectionView.cellForItem(at: selectedIndexPath) as? MessageContentCell else { return }
        let selectedCellMessageBubbleFrame = selectedCell.convert(selectedCell.messageContainerView.frame, to: view)

        var messageInputBarFrame: CGRect = .zero
        if let messageInputBarSuperview = messageInputBar.superview {
            messageInputBarFrame = view.convert(messageInputBar.frame, from: messageInputBarSuperview)
        }

        var topNavigationBarFrame: CGRect = navigationBarFrame
        if navigationBarFrame != .zero, let navigationBarSuperview = navigationController?.navigationBar.superview {
            topNavigationBarFrame = view.convert(navigationController!.navigationBar.frame, from: navigationBarSuperview)
        }

        let menuHeight = currentMenuController.menuFrame.height

        let selectedCellMessageBubblePlusMenuFrame = CGRect(selectedCellMessageBubbleFrame.origin.x,
                                                            selectedCellMessageBubbleFrame.origin.y - menuHeight,
                                                            selectedCellMessageBubbleFrame.size.width,
                                                            selectedCellMessageBubbleFrame.size.height + 2 * menuHeight)

        var targetRect: CGRect = selectedCellMessageBubbleFrame
        currentMenuController.arrowDirection = .default

        /// Message bubble intersects with navigationBar and keyboard
        if selectedCellMessageBubblePlusMenuFrame.intersects(topNavigationBarFrame) && selectedCellMessageBubblePlusMenuFrame.intersects(messageInputBarFrame) {
            let centerY = (selectedCellMessageBubblePlusMenuFrame.intersection(messageInputBarFrame).minY
                + selectedCellMessageBubblePlusMenuFrame.intersection(topNavigationBarFrame).maxY) / 2
            targetRect = CGRect(selectedCellMessageBubblePlusMenuFrame.midX, centerY, 1, 1)
        } /// Message bubble only intersects with navigationBar
        else if selectedCellMessageBubblePlusMenuFrame.intersects(topNavigationBarFrame) {
            currentMenuController.arrowDirection = .up
        }

        currentMenuController.setTargetRect(targetRect, in: view)
        currentMenuController.setMenuVisible(true, animated: true)
    }

    // MARK: - Helpers

    private var navigationBarFrame: CGRect {
        guard let navigationController = navigationController, !navigationController.navigationBar.isHidden else {
            return .zero
        }
        return navigationController.navigationBar.frame
    }
}
