//
//  LocationMessageCell.swift
//  MessageUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 MessageUI. All rights reserved.
//

import UIKit
import MapKit

/// A subclass of `MessageContentCell` used to display location messages.
open class LocationMessageCell: MessageContentCell {
    // 标题
    public lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    // 子标题
    public lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()

    /// 地图加载时的 activityIndicator
    public lazy var activityIndicator = UIActivityIndicatorView(style: .gray)

    /// 显示地图截图的 UIImageView
    public lazy var mapSnapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private weak var snapShotter: MKMapSnapshotter?

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(titleLabel)
        messageContainerView.addSubview(subtitleLabel)
        messageContainerView.addSubview(mapSnapImageView)
        messageContainerView.addSubview(activityIndicator)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        mapSnapImageView.image = nil
        snapShotter?.cancel()
    }

    open override func configure(with message: Message, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard case let .location(locationItem) = message.kind else { fatalError("") }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }

        let titleAttributes = displayDelegate.titleAttributesLocation(message: message, at: indexPath, in: messagesCollectionView)
        titleLabel.attributedText = NSAttributedString(string: locationItem.title, attributes: titleAttributes)
        titleLabel.sizeToFit()

        let subtitleAttributes = displayDelegate.subtitleAttributesForLocation(message: message, at: indexPath, in: messagesCollectionView)
        subtitleLabel.attributedText = NSAttributedString(string: locationItem.subtitle, attributes: subtitleAttributes)
        subtitleLabel.sizeToFit()

        let edgeInsets = layoutDelegate.locationCellPadding(for: message, at: indexPath, in: messagesCollectionView)

        titleLabel.frame = CGRect(x: edgeInsets.left, y: edgeInsets.top,
                                  width: messageContainerView.bounds.width - edgeInsets.left - edgeInsets.right,
                                  height: titleLabel.bounds.height)

        subtitleLabel.frame = CGRect(x: edgeInsets.left, y: titleLabel.frame.maxY + 2,
                                     width: messageContainerView.bounds.width - edgeInsets.left - edgeInsets.right,
                                     height: subtitleLabel.bounds.height)

        mapSnapImageView.frame = CGRect(x: edgeInsets.left, y: subtitleLabel.frame.maxY + 5,
                                        width: messageContainerView.bounds.width - edgeInsets.left - edgeInsets.right,
                                        height: messageContainerView.bounds.height - subtitleLabel.frame.maxY - 5 - edgeInsets.bottom)

        if let cacheImage = LocationMessageCache.image(by: locationItem.location.coordinate) {
            self.mapSnapImageView.image = cacheImage
            return
        }
        activityIndicator.center = mapSnapImageView.center
        configureMapView(with: message, at: indexPath, and: messagesCollectionView)
    }

    func configureMapView(with message: Message, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        guard case let .location(locationItem) = message.kind else { fatalError("") }
        let options = displayDelegate.snapshotOptionsForLocation(message: message, at: indexPath, in: messagesCollectionView)
        let annotationView = displayDelegate.annotationViewForLocation(message: message, at: indexPath, in: messagesCollectionView)

        activityIndicator.startAnimating()

        let snapshotOptions = MKMapSnapshotter.Options()
        snapshotOptions.region = MKCoordinateRegion(center: locationItem.location.coordinate, span: options.span)
        snapshotOptions.showsBuildings = options.showsBuildings
        snapshotOptions.showsPointsOfInterest = options.showsPointsOfInterest

        let snapShotter = MKMapSnapshotter(options: snapshotOptions)
        self.snapShotter = snapShotter
        snapShotter.start { (snapshot, error) in
            defer {
                self.activityIndicator.stopAnimating()
            }
            guard let snapshot = snapshot, error == nil else { return }

            guard let annotationView = annotationView else {
                self.mapSnapImageView.image = snapshot.image
                return
            }

            UIGraphicsBeginImageContextWithOptions(snapshotOptions.size, true, 0)
            snapshot.image.draw(at: .zero)
            var point = snapshot.point(for: locationItem.location.coordinate)
            //Move point to reflect annotation anchor
            point.x -= annotationView.bounds.size.width / 2
            point.y -= annotationView.bounds.size.height / 2
            point.x += annotationView.centerOffset.x
            point.y += annotationView.centerOffset.y

            annotationView.image?.draw(at: point)
            let composedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            LocationMessageCache.cache(image: composedImage!, center: locationItem.location.coordinate)
            self.mapSnapImageView.image = composedImage
        }
    }
}
