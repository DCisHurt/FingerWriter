//
//  FingerWriterApp.swift
//  FingerWriter
//
//  Created by test on 1/7/23.
//

import SwiftUI

@main
struct FingerWriterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modifier(LightModeViewModifier())
        }
    }
}

public struct LightModeViewModifier: ViewModifier {
@AppStorage("isDarkMode") var isDarkMode: Bool = false
public func body(content: Content) -> some View {
    content
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
