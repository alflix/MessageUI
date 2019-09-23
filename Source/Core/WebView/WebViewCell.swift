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
        webView.isUserInteractionEnabled = false
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

    /// 加载 html 字符串
    /// - Parameter htmlString: html 字符串
    /// - Parameter appendingHtmlFormat: 是否拼接上 htlm 的基本格式
    /// - Parameter delegate: 代理，监听网页高度
    public func setupHtmlString(_ htmlString: String?, appendingHtmlFormat: Bool = false, delegate: WebViewCellDelegate?) {
        if appendingHtmlFormat, let htmlString = htmlString {
            //swiftlint:disable line_length
            let appendingHtml = "<!doctype html><html class=\"no-js\" lang=\"\"><head><meta charset=\"utf-8\"><style>img {max-width:100%;width: 100%;height:auto;padding:0;border:0;margin:0;vertical-align:bottom;}</style></head><body><p><div>\(htmlString.replacingOccurrences(of: "\n", with: ""))</div></p><br></body></html>"
            self.htmlString = appendingHtml
        } else {
            self.htmlString = htmlString
        }
        self.delegate = delegate
    }

    /// 加载 url
    /// - Parameter urlString: url 字符串
    /// - Parameter delegate: 代理，监听网页高度
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
