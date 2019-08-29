//
//  WKWebViewCell.swift
//  GGUI
//
//  Created by John on 10/14/18.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import WebKit
import GGUI

public protocol WKWebViewCellDelegate: NSObjectProtocol {
    func heightChangeObserve(in cell: UITableViewCell, webView: WKWebView, contentHeight: CGFloat)
}

public class WKWebViewCell: UITableViewCell {
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.minimumFontSize = 1
        configuration.preferences.javaScriptEnabled = true
        configuration.allowsInlineMediaPlayback = true
        configuration.userContentController = WKUserContentController()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.delegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self        
        return webView
    }()
    
    private var webViewHeight: CGFloat = 0
    private var observation: NSKeyValueObservation?
    private var hasLoad: Bool = false
    weak var delegate: WKWebViewCellDelegate?    
    
    deinit {
        observation = nil
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
    
    public func setupHtmlString(_ htmlString: String?, delegate: WKWebViewCellDelegate?) {
        self.htmlString = htmlString
        self.delegate = delegate
    }
    
    public func setupURLString(_ urlString: String?, delegate: WKWebViewCellDelegate?) {
        self.urlString = urlString
        self.delegate = delegate
    }
    
    var htmlString: String? {
        didSet {
            guard let htmlString = htmlString, hasLoad == false else { return }
            webView.loadHTMLString(htmlString, baseURL: nil)
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

private extension WKWebViewCell {
    func setupUI() {        
        contentView.addSubview(webView)
        webView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func addObservers() {
        observation = webView.observe(\WKWebView.scrollView.contentSize) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            let height = strongSelf.webView.scrollView.contentSize.height
            strongSelf.contentSizeChange(height: height)
        }
    }
    
    func contentSizeChange(height: CGFloat) {
        if webViewHeight == height { return }            
        webViewHeight = height
        delegate?.heightChangeObserve(in: self,
                                      webView: webView, 
                                      contentHeight: height)
        webView.setNeedsLayout()
    }
}

extension WKWebViewCell: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (result, error) in
            guard error == nil, let strongSelf = self, let result = result as? Double else { return }
            strongSelf.contentSizeChange(height: result.cgFloat)
        }
    }
}

extension WKWebViewCell: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
    }
}
