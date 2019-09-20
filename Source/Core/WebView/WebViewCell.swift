//
//  WebViewCell.swift
//  GGUI
//
//  Created by John on 10/14/18.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import WebKit

public protocol WebViewCellDelegate: NSObjectProtocol {
    func heightChangeObserve(in cell: UITableViewCell, webView: WKWebView, contentHeight: CGFloat)
}

public class WebViewCell: UITableViewCell {
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 1
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsInlineMediaPlayback = true
        configuration.userContentController = WKUserContentController()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        // MARK: 找了好久的问题
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webView.navigationDelegate = self
        return webView
    }()

    private var webViewHeight: CGFloat = 0
    private var observation: NSKeyValueObservation?
    private var hasLoad: Bool = false
    weak var delegate: WebViewCellDelegate?
    var isAutoHeight: Bool = true

    deinit {
        if isAutoHeight { observation = nil }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        addObservers()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = bounds
    }

    public func setupHtmlString(_ htmlString: String?, delegate: WebViewCellDelegate?) {
        self.htmlString = htmlString
        self.delegate = delegate
    }

    public func setupURLString(_ urlString: String?, delegate: WebViewCellDelegate?) {
        self.urlString = urlString
        self.delegate = delegate
    }

    var htmlString: String? {
        didSet {
            guard let htmlString = htmlString, hasLoad == false else { return }
            let basePath = Bundle.main.bundlePath
            let baseURL = NSURL.fileURL(withPath: basePath)
            webView.loadHTMLString(htmlString, baseURL: baseURL)
            hasLoad = true
        }
    }

    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else { return }
            webView.load(URLRequest(url: url))
            hasLoad = true
        }
    }
}

private extension WebViewCell {
    func setupUI() {
        contentView.addSubview(webView)
    }

    func addObservers() {
        guard isAutoHeight else { return }
        observation = webView.observe(\WKWebView.scrollView.contentSize) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            let height = strongSelf.webView.scrollView.contentSize.height
            strongSelf.contentSizeChange(height: height)
        }
    }

    func contentSizeChange(height: CGFloat) {
        if webViewHeight == height { return }
        webViewHeight = height
        delegate?.heightChangeObserve(in: self, webView: webView, contentHeight: height)
        webView.setNeedsLayout()
    }
}

extension WebViewCell: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isAutoHeight && SYSTEM_VERSION_GREATER_THAN(version: "11") { return }
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (result, error) in
            guard error == nil, let strongSelf = self, let result = result as? Double else { return }
            strongSelf.contentSizeChange(height: result.cgFloat)
        }
    }
}

public extension UITableView {
    /// 处理 ios10 webview 白屏 scrollViewDidScroll 中调用
    /// https://stackoverflow.com/questions/39549103/wkwebview-not-rendering-correctly-in-ios-10
    func fixWebViewCellRenderingWhite() {
        guard SYSTEM_VERSION_LESS_THAN(version: "11") else { return }
        for cell in visibleCells where cell is WebViewCell {
            if let webView = cell.contentView.recursiveFindSubview(of: "WKWebView") {
                webView.setNeedsLayout()
            }
        }
    }
}
