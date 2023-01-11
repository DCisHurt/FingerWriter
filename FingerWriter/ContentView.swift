//
//  ContentView.swift
//  ui
//
//  Created by test on 12/29/22.
//

import SwiftUI
import Controls

struct ContentView: View {
    @StateObject var generator = MelodyGen()
    var body: some View {
        VStack{
            if generator.isRecording {
                RecordingView().transition(.fadeInRight)
            }

            else if generator.isSetting {
                SettingView().transition(.fadeInRight)
            }
            
            else {
                if generator.isHelp {
                    HelpView().transition(.fadeInLeft)
                }
                else {
                    MenuView()
                }
            }
        }
        .environmentObject(generator)
        .animation(.default.speed(0.5), value: generator.isSetting)
        .animation(.default.speed(0.5), value: generator.isHelp)
        .animation(.default.speed(0.5), value: generator.isRecording)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
