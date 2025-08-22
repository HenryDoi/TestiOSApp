import UIKit

class ViewController: UIViewController {
    
    private var label: UILabel!
    private var versionLabel: UILabel!
    private var updateButton: UIButton!
    private var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController: viewDidLoad called")
        
        view.backgroundColor = .systemBackground
        setupUI()
        checkForUpdates()
        
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
        versionLabel.text = "当前版本: \(getCurrentBuildTime())"
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont.systemFont(ofSize: 14)
        versionLabel.textColor = .systemGray
        versionLabel.numberOfLines = 0
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 更新按钮
        updateButton = UIButton(type: .system)
        updateButton.setTitle("🔄 检查更新", for: .normal)
        updateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        updateButton.backgroundColor = .systemBlue
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.layer.cornerRadius = 10
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.addTarget(self, action: #selector(checkForUpdatesButtonTapped), for: .touchUpInside)
        
        // 状态标签
        statusLabel = UILabel()
        statusLabel.text = "点击检查更新"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = .systemGray2
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refreshContent))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(label)
        view.addSubview(versionLabel)
        view.addSubview(updateButton)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 30),
            updateButton.widthAnchor.constraint(equalToConstant: 200),
            updateButton.heightAnchor.constraint(equalToConstant: 44),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 15),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func refreshContent() {
        versionLabel.text = "当前版本: \(getCurrentBuildTime())"
        
        UIView.animate(withDuration: 0.3) {
            self.label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.label.transform = .identity
            }
        }
    }
    
    @objc private func checkForUpdatesButtonTapped() {
        checkForUpdates()
    }
    
    private func checkForUpdates() {
        statusLabel.text = "正在检查更新..."
        updateButton.isEnabled = false
        
        // 检查GitHub Actions最新构建
        guard let url = URL(string: "https://api.github.com/repos/HenryDoi/TestiOSApp/actions/runs?status=success&per_page=1") else {
            updateStatus("检查失败: 无效URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.updateButton.isEnabled = true
                
                if let error = error {
                    self?.updateStatus("检查失败: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self?.updateStatus("检查失败: 无数据")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let workflowRuns = json["workflow_runs"] as? [[String: Any]],
                       let latestRun = workflowRuns.first,
                       let updatedAt = latestRun["updated_at"] as? String,
                       let htmlUrl = latestRun["html_url"] as? String {
                        
                        self?.handleUpdateCheck(latestBuildTime: updatedAt, buildUrl: htmlUrl)
                    } else {
                        self?.updateStatus("解析数据失败")
                    }
                } catch {
                    self?.updateStatus("解析JSON失败: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func handleUpdateCheck(latestBuildTime: String, buildUrl: String) {
        // 简单的时间比较（实际项目中应该存储构建时间戳）
        let formatter = ISO8601DateFormatter()
        if let buildDate = formatter.date(from: latestBuildTime) {
            let timeAgo = Date().timeIntervalSince(buildDate)
            
            if timeAgo < 300 { // 5分钟内的构建认为是新的
                showUpdateAvailable(buildUrl: buildUrl)
            } else {
                updateStatus("当前是最新版本 ✅")
            }
        } else {
            updateStatus("时间解析失败")
        }
    }
    
    private func showUpdateAvailable(buildUrl: String) {
        updateStatus("发现新版本! 🎉")
        
        let alert = UIAlertController(title: "发现新版本", message: "检测到新的构建版本，是否前往下载？\n\n提示：下载的是zip文件，需要解压后获取IPA", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "前往下载", style: .default) { _ in
            if let url = URL(string: "https://github.com/HenryDoi/TestiOSApp/actions") {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
    
    private func updateStatus(_ message: String) {
        statusLabel.text = message
    }
    
    private func getCurrentBuildTime() -> String {
        // 这里可以设置构建时的时间戳
        // 实际项目中可以在构建时写入Info.plist
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: Date())
    }
}