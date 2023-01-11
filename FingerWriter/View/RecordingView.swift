import SwiftUI


/// the view of recording progress page
struct RecordingView: View {
    @EnvironmentObject var generator: MelodyGen
    @State var progress: Double = 0.0
    @State var progress100: Double = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack{
            HStack{
                Text("Exporting ...")
                    .font(.title3)
                    .foregroundColor(Color("myPrimary"))
                    .padding([.leading, .bottom])

                Spacer()
                
                Text(String(progress100)+"%")
                    .font(.system(size: UIScreen.main.bounds.height * 0.018))
                    .foregroundColor(Color("myPrimary"))
                    .font(.body)
                    .padding([.bottom, .trailing])
                    .onReceive(timer) { _ in
                        if(generator.isRecording){
                            let tmp = generator.chord.sequencer.currentPosition.seconds
                            / generator.chord.sequencer.length.seconds / 2
                            
                            if(tmp > 1.0){
                                progress = 1.0
                            }
                            else{
                                progress = tmp
                            }
                            progress100 = round(progress * 1000)/10
                        }
                        else{
                            progress = 0
                        }
                    }
            }
            
            ProgressView(value: progress)
            .foregroundColor(Color("myPrimary"))
            
        }
        .padding(.horizontal)
        .frame(height:  UIScreen.main.bounds.height)
        .background(Color("myBackgroundA"))
    }
}
