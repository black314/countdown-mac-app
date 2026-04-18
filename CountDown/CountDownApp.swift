import SwiftUI
import ServiceManagement

// 🌟 新增：强制修改软件在系统中的“身份属性”
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // .regular 表示将其设置为标准的普通应用程序（会在Dock栏显示图标，也能被腾讯会议抓取）
        NSApp.setActivationPolicy(.regular)
        // 启动后自动将其激活到最前
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct CountDownApp: App {
    // 🌟 新增：让上面的身份设置生效
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var timerModel = TimerModel()
    
    var body: some Scene {
        WindowGroup {
            CountdownTimerView()
                .environment(timerModel)
                .preferredColorScheme(.none) // Supports both light and dark mode
        }
        .commands {
            // Add keyboard commands
            CommandGroup(after: .newItem) {
                Button("Reset Timer") {
                    timerModel.resetTimer()
                }
                .keyboardShortcut("r", modifiers: .command)
                
                Divider()
                
                Button("Toggle Play/Pause") {
                    timerModel.toggleTimer()
                }
                .keyboardShortcut(.space, modifiers: [])
            }
            
            // Add a custom settings menu
            CommandGroup(replacing: .appSettings) {
                Button("Settings...") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}
