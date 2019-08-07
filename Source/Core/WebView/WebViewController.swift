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
    /// 访问链接
    public var urlString: String? {
        didSet {
            loadURL()
        }
    }

    /// html 的文本内容
    public var htmlString: String? {
        didSet {
            guard let htmlString = htmlString else {
                DPrint("💣 htmlString 为空 ")
                return
            }
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
    }

    /// 访问 Request
    public var urlRequest: URLRequest? {
        didSet {
            guard let urlRequest = urlRequest else {
                DPrint("💣 非法的 urlRequest！")
                return
            }
            webView.load(urlRequest)
        }
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
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 1
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsInlineMediaPlayback = true
        configuration.userContentController = WKUserContentController()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
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
        addProgressView()
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
            make.top.equalTo(progressView.snp.bottom)
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
    /// 开始刷新
    func loadURL() {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            DPrint("💣 非法的 URL！")
            return
        }
        webView.load(URLRequest(url: url))
    }

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

    func stopLoading() {
        webView.stopLoading()
        hideProgressView()
    }
}

// MARK: - Function
private extension WebViewController {
    func addObservers() {
        loadingObservation = webView.observe(\WKWebView.isLoading) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            if !strongSelf.webView.isLoading {
                strongSelf.stopLoading()
            }
        }
        titleObservation = webView.observe(\WKWebView.title) { [weak self] (webView, _) in
            guard let strongSelf = self else { return }
            strongSelf.title = strongSelf.webView.title
        }
        progressObservation = webView.observe(\WKWebView.estimatedProgress) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            strongSelf.showProgressView()
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
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

public extension UIViewController {
    func pushToWebByLoadingURL(_ url: String) {
        let webViewController = WebViewController()
        webViewController.urlString = url
        navigationController?.pushViewController(webViewController, animated: true)
    }

    func pushToWebByHTMLString(_ html: String) {
        let webViewController = WebViewController()
        webViewController.htmlString = html
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
