import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var websiteButtons: [UIButton] = []
    var backButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        addWebsiteButtons()
        setupBackButton()
        performLongTask()
    }
    
    func performLongTask() {
            DispatchQueue.global().async {
                // Perform time-consuming task here

                // Simulate a delay
                sleep(3) // This is just an example, replace this with your actual task

                DispatchQueue.main.async {
                    // Update UI on the main thread if needed after the task is done
                    print("Long task completed, updating UI")
                    // For example, show the website buttons after the task is done
                    self.websiteButtons.forEach { $0.isHidden = false }
                }
            }
        }

    func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self
        view.addSubview(webView)
    }

    func addWebsiteButtons() {
        let buttonNames = ["Google", "Google Maps", "YouTube", "Netflix", "Gmail", "Facebook", "Instagram", "Messenger", "Telegram", "TikTok"]

        let numberOfRows = 5
        let numberOfColumns = (buttonNames.count + numberOfRows - 1) / numberOfRows
        let buttonWidth: CGFloat = 120
        let buttonHeight: CGFloat = 60
        let horizontalSpacing: CGFloat = 20
        let verticalSpacing: CGFloat = 20

        // Calculate horizontal and vertical offsets for centering
        let totalButtonWidth = CGFloat(numberOfColumns) * buttonWidth + CGFloat(numberOfColumns - 1) * horizontalSpacing
        let totalButtonHeight = CGFloat(numberOfRows) * buttonHeight + CGFloat(numberOfRows - 1) * verticalSpacing
        let startX = (view.bounds.width - totalButtonWidth) / 2
        let startY = (view.bounds.height - totalButtonHeight) / 2

        for (index, name) in buttonNames.enumerated() {
            let column = index / numberOfRows
            let row = index % numberOfRows
            let x = startX + CGFloat(column) * (buttonWidth + horizontalSpacing)
            let y = startY + CGFloat(row) * (buttonHeight + verticalSpacing)
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.frame = CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)
            button.addTarget(self, action: #selector(didTapWebsiteButton(_:)), for: .touchUpInside)
            view.addSubview(button)
            websiteButtons.append(button)
        }
    }

    func setupBackButton() {
        backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        backButton.isEnabled = false
    }

    @objc func didTapWebsiteButton(_ sender: UIButton) {
        guard let websiteIndex = websiteButtons.firstIndex(of: sender), let website = getWebsiteURL(index: websiteIndex) else {
            return
        }
        let request = URLRequest(url: website)
        webView.load(request)

        // Hide the website buttons and show the back button
        websiteButtons.forEach { $0.isHidden = true }
        backButton.isEnabled = true
    }

    func getWebsiteURL(index: Int) -> URL? {
        let websites = [
            "https://www.google.com",
            "https://www.google.com/maps",
            "https://www.youtube.com",
            "https://www.netflix.com",
            "https://mail.google.com",
            "https://www.facebook.com",
            "https://www.instagram.com",
            "https://www.messenger.com",
            "https://www.telegram.org", // Updated URL for Telegram
            "https://www.tiktok.com"
        ]
        guard index >= 0, index < websites.count else {
            return nil
        }
        return URL(string: websites[index])
    }

    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            backButton.isEnabled = false
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

