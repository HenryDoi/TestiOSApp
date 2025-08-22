import UIKit

class ViewController: UIViewController {
    
    private var label: UILabel!
    private var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController: viewDidLoad called")
        
        view.backgroundColor = .systemBackground
        setupUI()
        
        print("ViewController: viewDidLoad completed")
    }
    
    private func setupUI() {
        // 主标题
        label = UILabel()
        label.text = "Hello iOS from GitHub Actions! 🚀"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 版本信息
        versionLabel = UILabel()
        versionLabel.text = "Version: \(getCurrentTime())\nTap to refresh"
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textColor = .systemGray
        versionLabel.numberOfLines = 0
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refreshContent))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(label)
        view.addSubview(versionLabel)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30)
        ])
    }
    
    @objc private func refreshContent() {
        // 刷新内容和时间戳
        versionLabel.text = "Version: \(getCurrentTime())\nTap to refresh"
        
        // 添加简单动画
        UIView.animate(withDuration: 0.3) {
            self.label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.label.transform = .identity
            }
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}