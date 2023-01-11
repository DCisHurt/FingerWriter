import Controls
import SwiftUI
import AudioKit

struct MenuView: View {
    @EnvironmentObject var generator: MelodyGen
    var body: some View {
        VStack {
            MenuHeader()
            MenuBody()
            
            Spacer()
            
            if (generator.isGenerated) {
                MenuFooter().transition(.fadeInBottom)
            }
        }
        .environmentObject(generator)
        .animation(.default.speed(0.5), value: generator.isGenerated)
        .background(Color("myBackgroundA"))
    }
}

struct MenuHeader: View {
    @EnvironmentObject var generator: MelodyGen
    var body: some View {
        HStack{
            Button {
                generator.isSetting = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("myPrimary"))
                    .frame(height:  UIScreen.main.bounds.height * 0.03)
                    .frame(width:  UIScreen.main.bounds.width * 0.1)
            }
            
            Button {
                if(generator.isGenerated){
                    generator.export()
                }
            } label: {
                Image(systemName: "arrow.down.doc")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("myPrimary"))
                    .frame(height:  UIScreen.main.bounds.height * 0.035)
                    .frame(width:  UIScreen.main.bounds.width * 0.1)
            }
            
            Spacer()
            
            Button {
                generator.isHelp = true
            } label: {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color("myPrimary"))
                    .frame(height:  UIScreen.main.bounds.height * 0.035)
                    .frame(width:  UIScreen.main.bounds.width * 0.1)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.05)
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct MenuBody: View {
    @EnvironmentObject var generator: MelodyGen
    @State var bar: Int = 2

    var body: some View {
        VStack {
            Text("Finger Writer")
                .font(.system(size: UIScreen.main.bounds.height * 0.06))
                .fontWeight(.heavy)
                .foregroundColor(Color("myPrimary"))
            
            mySelector(index: $generator.mood,
                       title: "Mood",
                       labels: ["Happy", "Dark", "Chill", "Party"])
            
            mySelector(index: $generator.genre,
                       title: "Genre",
                       labels: ["Pop", "Rock", "Disco", "EDM"])
            
            mySelector(index: $bar,
                       title: "Bar",
                       labels: ["1", "2", "4", "8", "16"])
            .onChange(of: bar) { newValue in
                generator.bars = (pow(2, newValue) as NSDecimalNumber).intValue
            }
            
            PitchShift()
            
            ZStack{
                Button {
                    generator.generate()
                } label: {
                    Circle()
                        .strokeBorder(Color("myOutline"),
                                      lineWidth: UIScreen.main.bounds.height * 0.01)
                        .background(Circle().fill(Color("myBackgroundB")))
                        .shadow(color: Color("myOutline"), radius: 8, x: 0, y: 0)
                }
                Text("Generate")
                    .font(.system(size: UIScreen.main.bounds.height * 0.03))
                    .fontWeight(.heavy)
                    .foregroundColor(Color("myPrimary"))
            }
            .padding(.vertical)
            .frame(height:  UIScreen.main.bounds.height * 0.25)
        }
        .environmentObject(generator)
    }
}

struct MenuFooter: View {
    @EnvironmentObject var generator: MelodyGen
    @State var radius: Float = 0
    @State var islooping : Bool = false
    var body: some View {
        VStack{
            HStack {
                Button {
                    generator.togglePlay()
                } label: {
                    Image(systemName: generator.isPlaying == true ? "stop.fill" : "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("myPrimary"))
                        .frame(height:  UIScreen.main.bounds.height * 0.03)
                        .padding(UIScreen.main.bounds.height * 0.02)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("myPrimary"),
                                    lineWidth: UIScreen.main.bounds.height * 0.005))
                }
                .frame(width:  UIScreen.main.bounds.width * 0.17)
                .padding(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
                Button {
                    generator.toggleLoop()
                } label: {
                    Image(systemName: "repeat")
                        .resizable()
                        .foregroundColor(
                            generator.isLooping == true ? Color("mySecondary") : Color("myPrimary"))
                        .scaledToFit()
                        .frame(height:  UIScreen.main.bounds.height * 0.045)
                        .padding(UIScreen.main.bounds.height * 0.01)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color("myPrimary"),
                                    lineWidth: UIScreen.main.bounds.height * 0.005))
                }
                .frame(width:  UIScreen.main.bounds.width * 0.17)
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)

                ArcKnob("TEMPO", value: $generator.tempo, range: 60...240, origin: 60)
                    .backgroundColor(Color("myPrimary"))
                    .foregroundColor(Color("mySecondary"))
                    .frame(height:  UIScreen.main.bounds.height * 0.09)
                    .onChange(of: generator.tempo) { _ in
                        generator.updateTempo()
                    }
                
                ArcKnob("VOL", value: $generator.masterVolume)
                    .backgroundColor(Color("myPrimary"))
                    .foregroundColor(Color("mySecondary"))
                    .frame(height:  UIScreen.main.bounds.height * 0.09)
                    .onChange(of: generator.masterVolume) { _ in
                        generator.updateVolume()
                    }
            }
            .padding([.top, .leading, .trailing])
        }
        .frame(height: UIScreen.main.bounds.height * 0.09)
        .environmentObject(generator)
        .background(Color("myBackgroundB"))
    }
}

struct PitchShift: View {
    @EnvironmentObject var generator: MelodyGen
    var body: some View {
        ZStack {
            HStack {
                Text("Pitch")
                    .font(.system(size: UIScreen.main.bounds.height * 0.018))
                    .foregroundColor(Color("myPrimary"))
                    .frame(width: UIScreen.main.bounds.height * 0.06)
                Spacer()
            }
            HStack {
                Button {
                    generator.pitch -= 1
                } label: {
                    Image(systemName: "minus.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("myPrimary"))
                        .frame(width:  UIScreen.main.bounds.width * 0.1)
                        .frame(height:  UIScreen.main.bounds.height * 0.04)
                }
                
                Text(String(Int(generator.pitch)))
                    .font(.system(size: UIScreen.main.bounds.height * 0.018))
                    .foregroundColor(Color("myPrimary"))
                    .frame(width: UIScreen.main.bounds.height * 0.06)
                
                Button {
                    generator.pitch += 1
                } label: {
                    Image(systemName: "plus.app.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("myPrimary"))
                        .frame(width:  UIScreen.main.bounds.width * 0.1)
                        .frame(height:  UIScreen.main.bounds.height * 0.04)
                }
            }
        }
        .padding(.vertical, UIScreen.main.bounds.height * 0.005)
        .frame(height: UIScreen.main.bounds.height * 0.05)
        .frame(width: UIScreen.main.bounds.width * 0.95)
        .environmentObject(generator)
    }
}
