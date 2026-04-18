import SwiftUI
import AppKit

// 我们把那些强制置顶、穿透桌面的底层调用全部删掉，只保留空壳
struct WindowLevelModifier: ViewModifier {
    @Binding var alwaysOnTop: Bool
    
    func body(content: Content) -> some View {
        // 什么都不做，直接返回内容，让它做一个本分的普通窗口
        content 
    }
}

// Extension 必须保留，因为其他界面代码里调用了它，不保留会导致编译失败
extension View {
    func windowLevel(alwaysOnTop: Binding<Bool>) -> some View {
        self.modifier(WindowLevelModifier(alwaysOnTop: alwaysOnTop))
    }
}
