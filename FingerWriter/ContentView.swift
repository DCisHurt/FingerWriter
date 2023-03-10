import SwiftUI
import Controls

/// main view of app
/// show different view between menu, help, seeting and recording with animations
/// judged by generator's state
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
    }
}
