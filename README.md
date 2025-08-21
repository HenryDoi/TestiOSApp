# iOS GitHub Actions 测试项目

这是一个使用 GitHub Actions 自动构建 iOS 应用并生成 IPA 文件的示例项目。

## 项目结构

```
TestiOSApp/
├── TestiOSApp.xcodeproj/          # Xcode项目文件
├── TestiOSApp/                    # 应用源代码
│   ├── AppDelegate.swift          # 应用代理
│   ├── SceneDelegate.swift        # 场景代理
│   ├── ViewController.swift       # 主视图控制器
│   ├── Main.storyboard           # 主界面
│   ├── LaunchScreen.storyboard   # 启动屏幕
│   ├── Assets.xcassets/          # 应用资源
│   └── Info.plist                # 应用配置
└── .github/workflows/            # GitHub Actions配置
    └── ios-build.yml             # iOS构建工作流
```

## GitHub Actions 构建流程

该项目配置了自动化的 iOS 构建流程：

1. **触发条件**：
   - 推送到 `main` 或 `develop` 分支
   - 创建针对 `main` 分支的 Pull Request

2. **构建步骤**：
   - 检出代码
   - 设置最新稳定版 Xcode
   - 清理构建文件夹
   - 在 iOS 模拟器上构建应用
   - 创建应用存档
   - 导出 IPA 文件（无签名版本）
   - 上传 IPA 作为构建产物

3. **输出**：
   - 生成的 IPA 文件会作为 artifact 保存 30 天
   - 可从 Actions 页面下载

## 使用方法

1. **推送代码到 GitHub**：
   ```bash
   git init
   git add .
   git commit -m "Initial iOS project"
   git branch -M main
   git remote add origin <your-repo-url>
   git push -u origin main
   ```

2. **查看构建结果**：
   - 访问 GitHub 仓库的 Actions 页面
   - 等待构建完成（通常需要 5-10 分钟）
   - 下载生成的 IPA 文件

## 注意事项

- 此项目生成的是**无签名的 IPA 文件**，仅用于测试目的
- 要在真实设备上运行，需要添加 Apple Developer 证书和配置文件
- 构建在 macOS runner 上运行，每月有免费的构建时间限制

## 本地开发

如果你有 Mac 和 Xcode：
1. 打开 `TestiOSApp/TestiOSApp.xcodeproj`
2. 选择模拟器设备
3. 点击运行按钮

## 技术特点

- 使用最新的 iOS 开发技术栈
- 支持 iOS 14.0+（兼容iOS 16及以上版本）
- UIKit + 纯代码界面
- 自动布局约束
- GitHub Actions 云端构建