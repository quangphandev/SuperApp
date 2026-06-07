//
//  BaseWebVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import WebKit

/// Base ViewController for WKWebView-based screens within mini-apps.
///
/// Provides:
/// - WKWebView with a native thin progress bar
/// - Back / Forward navigation buttons in the nav bar
/// - Error state view when load fails
/// - JS → Native message bridge (WKScriptMessageHandler)
///
/// Usage:
/// ```swift
/// class PolicyWebVC: BaseWebVC<PolicyVM> {
///
///     override func viewDidLoad() {
///         super.viewDidLoad()
///         loadURL(URL(string: "https://example.com/policy")!)
///     }
///
///     // Optional: handle JS messages
///     override func didReceiveMessage(_ name: String, body: Any) {
///         if name == "close" { coordinator?.dismiss() }
///     }
/// }
/// ```
class BaseWebVC<VM: BaseVM>: BaseVC<VM>, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    // MARK: - Constants

    private enum Bridge {
        static var channelName: String { "native" }
    }

    // MARK: - UI

    private lazy var progressView: UIProgressView = {
        let pv          = UIProgressView(progressViewStyle: .bar)
        pv.tintColor    = AppColor.accent
        pv.trackTintColor = .clear
        return pv
    }()

    private(set) lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let controller = WKUserContentController()
        controller.add(WeakScriptHandler(self), name: Bridge.channelName)
        config.userContentController = controller
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.navigationDelegate = self
        wv.uiDelegate         = self
        wv.allowsBackForwardNavigationGestures = true
        return wv
    }()

    private lazy var errorView: UIView = buildErrorView()

    private var backButton:    UIBarButtonItem?
    private var forwardButton: UIBarButtonItem?

    private var progressObservation: NSKeyValueObservation?

    // MARK: - Setup

    override func setupViews() {
        super.setupViews()
        view.backgroundColor = AppColor.background

        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(errorView)
        errorView.isHidden = true

        setupNavButtons()
        observeProgress()
    }

    override func setupConstraints() {
        super.setupConstraints()

        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        errorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }
    }

    deinit {
        progressObservation?.invalidate()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: Bridge.channelName)
    }

    // MARK: - Public API

    /// Loads a URL into the web view.
    func loadURL(_ url: URL) {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        webView.load(request)
    }

    /// Loads an HTML string directly.
    func loadHTML(_ html: String, baseURL: URL? = nil) {
        webView.loadHTMLString(html, baseURL: baseURL)
    }

    /// Called when a JavaScript message is received via `window.webkit.messageHandlers.native.postMessage({...})`.
    /// Override in subclass to handle bridge events.
    func didReceiveMessage(_ name: String, body: Any) {}

    // MARK: - Private

    private func setupNavButtons() {
        let backImage    = UIImage(systemName: "chevron.backward")
        let forwardImage = UIImage(systemName: "chevron.forward")

        backButton    = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(_goBack))
        forwardButton = UIBarButtonItem(image: forwardImage, style: .plain, target: self, action: #selector(_goForward))

        backButton?.isEnabled    = false
        forwardButton?.isEnabled = false

        navigationItem.leftBarButtonItems = [backButton, forwardButton].compactMap { $0 }
    }

    private func observeProgress() {
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, change in
            guard let self, let progress = change.newValue else { return }
            DispatchQueue.main.async {
                let floatProgress = Float(progress)
                self.progressView.setProgress(floatProgress, animated: true)
                UIView.animate(withDuration: 0.3, delay: 0.5) {
                    self.progressView.alpha = floatProgress >= 1.0 ? 0 : 1
                }
            }
        }
    }

    private func updateNavButtons() {
        backButton?.isEnabled    = webView.canGoBack
        forwardButton?.isEnabled = webView.canGoForward
    }

    @objc private func _goBack() {
        webView.goBack()
    }

    @objc private func _goForward() {
        webView.goForward()
    }

    private func buildErrorView() -> UIView {
        let stack       = UIStackView()
        stack.axis      = .vertical
        stack.spacing   = AppSpacing.medium
        stack.alignment = .center

        let icon        = UIImageView(image: UIImage(systemName: "wifi.slash"))
        icon.tintColor  = AppColor.textSecondary
        icon.contentMode = .scaleAspectFit
        icon.snp.makeConstraints { make in make.size.equalTo(44) }

        let label       = UILabel()
        label.text      = "Không thể tải trang.\nVui lòng kiểm tra kết nối mạng."
        label.font      = AppFont.body
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0

        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Thử lại", for: .normal)
        retryButton.setTitleColor(AppColor.accent, for: .normal)
        retryButton.titleLabel?.font = AppFont.headline
        retryButton.addTarget(self, action: #selector(_retry), for: .touchUpInside)

        [icon, label, retryButton].forEach { stack.addArrangedSubview($0) }
        return stack
    }

    @objc private func _retry() {
        webView.reload()
    }

    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        errorView.isHidden = true
        webView.isHidden   = false
        updateNavButtons()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateNavButtons()
        title = webView.title
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleWebError(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleWebError(error)
    }

    private func handleWebError(_ error: Error) {
        let nsError = error as NSError
        // Ignore cancellation (user navigated away)
        guard nsError.code != NSURLErrorCancelled else { return }
        webView.isHidden   = true
        errorView.isHidden = false
        Logger.error("WebView error: \(error.localizedDescription)", category: .network)
    }

    // MARK: - WKUIDelegate
    
    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler() })
        present(alert, animated: true)
    }

    // MARK: - WKScriptMessageHandler
    
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        didReceiveMessage(message.name, body: message.body)
    }
}

// MARK: - Weak Script Handler (prevent retain cycle)

/// Wraps the WKScriptMessageHandler to avoid a strong reference cycle
/// between WKWebView and the ViewController.
private final class WeakScriptHandler: NSObject, WKScriptMessageHandler {

    weak var delegate: WKScriptMessageHandler?

    init(_ delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
