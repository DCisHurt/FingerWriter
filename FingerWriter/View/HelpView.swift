import Controls
import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack{
            HelpHeader()
            HelpBody()
        }
        .background(Color("myBackgroundA"))
    }
}

struct HelpHeader: View {
    @EnvironmentObject var generator: MelodyGen
    var body: some View {
        HStack{
            Spacer()
            
            Text("Manual")
                .font(.system(size: UIScreen.main.bounds.height * 0.04))
                .fontWeight(.bold)
                .foregroundColor(Color("myPrimary"))
                .multilineTextAlignment(.center)
                .frame(width:  UIScreen.main.bounds.width * 0.65)
            
            Button {
                generator.isHelp = false
            } label: {
                Image(systemName: "arrowshape.turn.up.right.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("myPrimary"))
                    .frame(height:  UIScreen.main.bounds.height * 0.03)
                    .frame(width:  UIScreen.main.bounds.width * 0.1)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.05)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct HelpBody: View {
    var body: some View {
        ScrollView{
            VStack{
                VStack{
                    HelpGenerate()
                    HelpPlayback()
                    HelpTools()
                    HelpSetting()
                    HelpExport()
                }
                .foregroundColor(Color("myPrimary"))
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .background(Color("myBackgroundB"))
    }
}

struct HelpGenerate: View {
    var body: some View {
        ManualTitle(title: "Generate")
        
        ManualText(text:"First, use the mood and genre selectors to change the type of music and ambience.")
        
        Image("mood")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
        ManualText(text:"The bar selector is used to change the number of bars of the music.")
        
        Image("bar")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
        ManualText(text:"Shift the pitch of the music by clicking on the plus or minus buttons.")
        
        Image("pitch")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
        ManualText(text:"Finally, click on the Generate button to create the music.")
        
        Image("generate")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
    }
}

struct HelpPlayback: View {
    var body: some View {
        ManualTitle(title: "Playback")
                    
        ManualText(text:
"""
At the bottom of the interface is the playback bar.

The Play/Stop button is to toggle music play or not.
"""
                   )
        
        Image("play")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
        ManualText(text: "The Loop button is to enable/doable the looping mode.")
        
        Image("loop")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
        ManualText(text: "The Tempo knob is to adjust the speed of playback.")
        
        Image("tempo")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
        ManualText(text: "The Vol knob is to control the master volume.")
        
        Image("vol")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
    }
}

struct HelpTools: View {
    var body: some View {
        ManualTitle(title: "Setting")

        ManualText(text: "Click on the control button in the top left of the interface to bring up the settings page.")
        
        Image("setting")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
        ManualText(text: "Now, you can individually change the instrument, volume and reverb of each secttion.")
    }
}

struct HelpSetting: View {
    var body: some View {
            ManualTitle(title: "Instrument")
        
            ManualText(text:
"""
Each section has three different instruments.

You can disable the target section by changing the selector to disable.
"""
            )
        
        Image("instrument")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
        
            ManualTitle(title: "Balance Volume")
        
            ManualText(text: "Control the volume slider to adjust the volume of the instrument in percentage.")
             
        Image("mixing")
            .resizable()
            .padding(.bottom)
            .scaledToFit()

             ManualTitle(title: "Reverb")
        
             ManualText(text: "Use sliders control the reverb proportion of the instrument in percentage.")
        
        Image("reverb")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
    }
}

struct HelpExport: View {
    var body: some View {
        ManualTitle(title: "Export")

        ManualText(text: "Export the music as an audio file to your device by clicking on the Export button.")
        
        Image("export")
            .resizable()
            .padding(.bottom)
            .scaledToFit()
    }
}
