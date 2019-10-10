//
//  WebViewController.swift
//  GGUI
//
//  Created by John on 2018/12/28.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

open class WebViewController: UIViewController {
    /// 加载 html 字符串
    /// - Parameter htmlString: html 字符串
    /// - Parameter appendingHtmlFormat: 是否拼接上 htlm 的基本格式
    /// - Parameter delegate: 代理，监听网页高度
    public func setupHtmlString(_ htmlString: String?, appendingHtmlFormat: Bool = false) {
        if appendingHtmlFormat, let htmlString = htmlString {
            // 和计算高度有关
            let html = """
            <html>
            <head>
            <meta name="viewport", content="width=\(view.width), initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no\">
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

    /// 访问 url
    public var urlString: String? {
        didSet {
            guard let urlString = urlString, let url = URL(string: urlString) else {
                fatalError("URL 为空 ")
            }
            var request = URLRequest(url: url)
            request.addValue("skey=skeyValue", forHTTPHeaderField: "Cookie")
            webView.load(request)
        }
    }

    /// html string
    public var htmlString: String? {
        didSet {
            guard let htmlString = htmlString else {
                fatalError("htmlString 为空 ")
            }
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }

    /// urlRequest
    public var urlRequest: URLRequest? {
        didSet {
            guard let urlRequest = urlRequest else {
                fatalError("urlRequest 为空 ")
            }
            webView.load(urlRequest)
        }
    }

    open var isShowProgressView: Bool {
        return true
    }

    open var isShowTitle: Bool {
        return true
    }

    /// 进度条底色
    public var progressTintColor: UIColor = GGUI.WebViewConfig.progressTintColor
    /// 进度条颜色
    public var progressTrackTintColor: UIColor = GGUI.WebViewConfig.progressTrackTintColor
    /// 弹窗确定按钮的文字，默认 "OK"，可在 GGUI.WebViewConfig.alertConfirmTitle 设置
    public var alertConfirmTitle: String = GGUI.WebViewConfig.alertConfirmTitle
    /// 弹窗取消按钮的文字，默认 "Cancel"，可在 GGUI.WebViewConfig.alertCancelTitle 设置
    public var alertCancelTitle: String = GGUI.WebViewConfig.alertCancelTitle

    /// WKWebView
    public lazy private(set) var webView: WKWebView = {
        let userContentController = WKUserContentController()
        let cookieScript = WKUserScript(source: "document.cookie = 'skey=skeyValue';", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)

        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 1
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsInlineMediaPlayback = true
        configuration.userContentController = userContentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        
        webView.uiDelegate = self
        webView.navigationDelegate = self

        return webView
    }()

    /// 进度条
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = progressTrackTintColor
        progressView.tintColor = progressTintColor
        return progressView
    }()

    private var loadingObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    private var progressObservation: NSKeyValueObservation?

    deinit {
        loadingObservation = nil
        titleObservation = nil
        progressObservation = nil
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        if isShowProgressView {
            addProgressView()
        }
        addWebView()
        addObservers()
    }
}

// MARK: - UI
private extension WebViewController {
    private func addWebView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            if self.isShowProgressView {
                make.top.equalTo(progressView.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
        }
    }

    private func addProgressView() {
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.leading.trailing.top.equalToSuperview()
        }
    }

    func showProgressView() {
        progressView.isHidden = false
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
    }

    func hideProgressView() {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
}

// MARK: - Action
private extension WebViewController {
    /// 返回上一页
    ///
    /// - Parameter completion: 包含是否可以返回上一页的 Bool 值的回调，用于执行 goBack 后根据该状态更新相关按钮的 enable
    func goBack(completion: BoolBlock? = nil) {
        if webView.canGoBack {
            webView.goBack()
            completion?(webView.canGoBack)
        }
        completion?(false)
    }

    /// 前进一页
    ///
    /// - Parameter completion: 包含是否可以前进一页的 Bool 值的回调，用于执行 goBack 后根据该状态更新相关按钮的 enable
    func goForward(completion: BoolBlock? = nil) {
        if webView.canGoForward {
            webView.goForward()
            completion?(webView.canGoForward)
        }
        completion?(false)
    }

    func reload() {
        webView.reload()
    }
}

// MARK: - Function
private extension WebViewController {
    func addObservers() {
        loadingObservation = webView.observe(\WKWebView.isLoading) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            if !strongSelf.webView.isLoading {
                strongSelf.hideProgressView()
            }
        }
        titleObservation = webView.observe(\WKWebView.title) { [weak self] (webView, _) in
            guard let strongSelf = self, strongSelf.isShowTitle else { return }
            strongSelf.title = strongSelf.webView.title
        }
        progressObservation = webView.observe(\WKWebView.estimatedProgress) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            strongSelf.showProgressView()
        }
    }
}

// MARK: - WKUIDelegate
extension WebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        runJavaScriptAlertPanelWithMessage message: String,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertConfirmTitle, style: .default, handler: { (_) in
            completionHandler()
        }))
        present(alert, animated: false, completion: nil)
    }

    public func webView(_ webView: WKWebView,
                        runJavaScriptConfirmPanelWithMessage message: String,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertConfirmTitle, style: .default, handler: { (_) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: alertCancelTitle, style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        present(alert, animated: false, completion: nil)
    }

    public func webView(_ webView: WKWebView,
                        runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?,
                        initiatedByFrame frame: WKFrameInfo,
                        completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .alert)
        alert.addTextField { (textFiled) in
            textFiled.textColor = .red
        }
        alert.addAction(UIAlertAction(title: alertConfirmTitle, style: .default, handler: { (_) in
            completionHandler(alert.textFields![0].text!)
        }))
        present(alert, animated: false, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

public extension UIViewController {
    func pushToWebByLoadingURL(_ url: String) {
        let webViewController = WebViewController()
        webViewController.urlString = url
        navigationController?.pushViewController(webViewController, animated: true)
    }

    func pushToWebByHTMLString(_ html: String, title: String? = nil) {
        let webViewController = WebViewController()
        webViewController.title = title
        webViewController.setupHtmlString(html, appendingHtmlFormat: true)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
