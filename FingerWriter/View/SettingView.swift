import Controls
import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            SettingHeader()
            SettingInstrument()
            SettingVolume()
            SettingReverb()
            Spacer()
        }
        .background(Color("myBackgroundA"))
    }
}

struct SettingHeader: View {
    @EnvironmentObject var generator: MelodyGen
    var body: some View {
        HStack{
            Button {
                generator.isSetting = false
            } label: {
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("myPrimary"))
                    .frame(height:  UIScreen.main.bounds.height * 0.03)
                    .frame(width:  UIScreen.main.bounds.width * 0.1)
            }
            
            Text("Setting")
                .font(.system(size: UIScreen.main.bounds.height * 0.04))
                .fontWeight(.bold)
                .foregroundColor(Color("myPrimary"))
                .multilineTextAlignment(.center)
                .frame(width:  UIScreen.main.bounds.width * 0.65)
            
            Spacer()
        }
        .frame(height: UIScreen.main.bounds.height * 0.05)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct SettingInstrument: View {
    @EnvironmentObject var generator: MelodyGen
    var body: some View {
        VStack{
            mySubtitle(text: "Instrument")
            
            mySelector(index: $generator.leadSample,
                       title: "Lead",
                       labels: ["Disable", "Synth", "Carillon", "Organ"])
                .onChange(of: generator.leadSample) { newValue in
                    generator.updateLead()
                }
              
            mySelector(index: $generator.chordSample,
                       title: "Chord",
                       labels: ["Disable", "Guitar", "Piano", "Bell"])
                .onChange(of: generator.chordSample) { newValue in
                    generator.updateChord()
                }
                            
            mySelector(index: $generator.drumSample,
                       title: "Drum",
                       labels: ["Disable", "Rock", "Electric", "African"])
                .onChange(of: generator.drumSample) { newValue in
                    generator.updateDrum()
                }
        }
        .environmentObject(generator)
    }
}

struct SettingVolume: View {
    @EnvironmentObject var generator: MelodyGen
    var body: some View {
        VStack{
            mySubtitle(text: "Mixing")
            
            mySlider(position: $generator.leadVolume, title: "Lead")
                .onChange(of: generator.leadVolume) { newValue in
                    generator.updateVolume()
                }
            
            mySlider(position: $generator.chordVolume, title: "Chord")
                .onChange(of: generator.chordVolume) { newValue in
                    generator.updateVolume()
                }
            
            mySlider(position: $generator.drumVolume, title: "Drum")
                .onChange(of: generator.drumVolume) { newValue in
                    generator.updateVolume()
                }
        }
        .environmentObject(generator)
    }
}

struct SettingReverb: View {
    @EnvironmentObject var generator: MelodyGen
    @State var radius: Float = 0
    var body: some View {
        VStack{
            mySubtitle(text: "Reverb")

            mySlider(position: $generator.leadRevMix, title: "Lead")
                .onChange(of: generator.leadRevMix) { newValue in
                    generator.updateReverb()
                }
            
            mySlider(position: $generator.chordRevMix, title: "Chord")
                .onChange(of: generator.chordRevMix) { newValue in
                    generator.updateReverb()
                }
            
            mySlider(position: $generator.drumRevMix, title: "Drum")
                .onChange(of: generator.drumRevMix) { newValue in
                    generator.updateReverb()
                }
        }
        .environmentObject(generator)
    }
}


