//
//  WebViewCell.swift
//  GGUI
//
//  Created by John on 10/14/18.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import WebKit
import GGUI

public protocol WebViewCellDelegate: NSObjectProtocol {
    func heightChangeObserve(in cell: UITableViewCell, contentHeight: CGFloat)
}

public class WebViewCell: UITableViewCell {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
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
        self.delegate = delegate
        if appendingHtmlFormat, let htmlString = htmlString {
            // 和计算高度有关
            let html = """
            <html>
            <head>
            <meta name="viewport", content="width=\(width), initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no\">
            <style>
            body { font-size: 100%; text-align: justify;}
            img { max-width:100%; width: 100%; height:auto; padding:0; border:0; margin:0; vertical-align:bottom;}
            </style>
            </head>
            <body>
            \(htmlString)
            </body>
            </html>
            """
            self.htmlString = html
        } else {
            self.htmlString = htmlString
        }
    }

    /// 加载 url
    /// - Parameter urlString: url 字符串
    /// - Parameter delegate: 代理，监听网页高度
    public func setupURLString(_ urlString: String?, delegate: WebViewCellDelegate?) {
        self.delegate = delegate
        // 如果 url 有问题，可能需要注入 js 或修改 html（）https://blog.csdn.net/GYMotgm/article/details/77944163
        self.urlString = urlString
    }

    var htmlString: String? {
        didSet {
            guard let htmlString = htmlString, hasLoad == false else { return }
            let basePath = Bundle.main.bundlePath
            let baseURL = NSURL.fileURL(withPath: basePath)
            DispatchQueue.main.async {
                self.webView.loadHTMLString(htmlString, baseURL: baseURL)
            }
            hasLoad = true
        }
    }

    var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else { return }
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url))
            }
            hasLoad = true
        }
    }
}

private extension WebViewCell {
    func setupUI() {
        contentView.addSubview(webView)
    }

    func addObservers() {
        // 如果 html 正确的话，例如有添加了<meta>，document.body.scrollHeight 获取的高度是正确的，
        // 不需要 addObservers，而且发现 iOS12 以上，使用这个方法高度反而会异常（在添加了<meta>之后）
        observation = webView.observe(\WKWebView.scrollView.contentSize) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            let height = strongSelf.webView.scrollView.contentSize.height
            strongSelf.contentSizeChange(height: height)
        }
    }

    func contentSizeChange(height: CGFloat) {
        if webViewHeight == height { return }
        delegate?.heightChangeObserve(in: self, contentHeight: height)
        webViewHeight = height
        webView.setNeedsLayout()
    }
}

extension WebViewCell: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 偶现这个方法不调用 (可能是因为设置 delegate 在 设置 url 之后，继续观察)
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (result, _) in
            guard let strongSelf = self, let result = result as? Double else { return }
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
