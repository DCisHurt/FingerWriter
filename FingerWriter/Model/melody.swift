import Foundation
import Tonic
import AudioKit
import SoundpipeAudioKit
import AudioKitEX
import AVFoundation

class MelodyGen: ObservableObject {
    @Published var isSetting: Bool = false
    @Published var isHelp: Bool = false
    @Published var isPlaying: Bool = false
    @Published var isLooping: Bool = true
    @Published var isGenerated: Bool = false
    @Published var isRecording: Bool = false
    
    @Published var tempo: Float = 120.0
    @Published var key: Int = 0
    @Published var bars: Int = 4
    @Published var mood: Int = 0
    @Published var genre: Int = 0
    @Published var pitch: Float = 0.0

    @Published var leadSample: Int = 1
    @Published var chordSample: Int = 1
    @Published var drumSample: Int = 1
    
    @Published var leadRevMix: Float = 0.2
    @Published var chordRevMix: Float = 0.2
    @Published var drumRevMix: Float = 0.2
    
    @Published var leadVolume: Float = 0.5
    @Published var chordVolume: Float = 0.5
    @Published var drumVolume: Float = 0.5
    @Published var masterVolume: Float = 80.0
    
    let grooves = [["pop_rock", "pop_indie", "pop_edm"],
                   ["rock_hard", "rock_funk", "rock_punk"],
                   ["disco_jump", "disco_pop", "disco_funky"],
                   ["edm_trap", "edm_house"," edm_dub"]]
    
    let scales = [[Scale.ionian, Scale.lydian, Scale.mixolydian],
                  [Scale.harmonicMinor, Scale.phrygian, Scale.melodicMinor],
                  [Scale.blues, Scale.dorian, Scale.jazzMelodicMinor],
                  [Scale.pentatonicMinor, Scale.minorBebop, Scale.aeolian]]

    let mixer: Mixer
    let recordTrack: Mixer
    let engine = AudioEngine()
    let recorderOut: Fader
    
    let lead = leadMaker()
    var chord = chordMaker()
    let drum = drumMaker()
    
    var leadReverb : Reverb!
    var chordReverb : Reverb!
    var drumReverb : Reverb!
    
    var recoder : NodeRecorder!
    
    var drumComp :DynamicRangeCompressor!
    init() {
        drumComp = DynamicRangeCompressor(
            drum.instrument,
            ratio: 3.2,
            threshold: -40,
            attackDuration: 0.023,
            releaseDuration: 0.1)
        
        leadReverb = Reverb(lead.instrument)
        chordReverb = Reverb(chord.instrument)
        drumReverb = Reverb(drumComp)
        
        recordTrack = Mixer(leadReverb, chordReverb, drumReverb)
        recorderOut = Fader(recordTrack, gain: 0)
        
        mixer = Mixer(leadReverb, chordReverb, drumReverb, recordTrack)
        
        engine.output = mixer
        
        let outURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("home: \(NSHomeDirectory())")
        recoder = try! NodeRecorder(node: recordTrack,
                                    fileDirectoryURL: outURL[0],
                                    shouldCleanupRecordings: false)
        updateReverb()
        updateInsturment()
        updateTempo()
        updateVolume()
        
        lead.sequencer.enableLooping()
        drum.sequencer.enableLooping()
        chord.sequencer.enableLooping()
        
        try? engine.start()
    }
    
    /// convert generated music to a audio file and export to device
    open func export(){
        do {
            
            self.isRecording = true
            
            self.lead.sequencer.stop()
            self.chord.sequencer.stop()
            self.drum.sequencer.stop()
            
            self.mixer.volume = 0
            
            try recoder.record()
            
            self.lead.sequencer.disableLooping()
            self.chord.sequencer.disableLooping()
            self.drum.sequencer.disableLooping()
            
            self.lead.sequencer.setTime(0)
            self.chord.sequencer.setTime(0)
            self.drum.sequencer.setTime(0)
            
            self.lead.sequencer.play()
            self.chord.sequencer.play()
            self.drum.sequencer.play()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.lead.sequencer.length.seconds) {
                self.recoder.stop()

                self.mixer.volume = self.masterVolume  / 100
                
                self.lead.sequencer.stop()
                self.chord.sequencer.stop()
                self.drum.sequencer.stop()
                
                self.lead.sequencer.setTime(0)
                self.chord.sequencer.setTime(0)
                self.drum.sequencer.setTime(0)
                
                if(self.isLooping){
                    self.lead.sequencer.enableLooping()
                    self.chord.sequencer.enableLooping()
                    self.drum.sequencer.enableLooping()
                }
                
                if(self.isPlaying){
                    self.lead.sequencer.play()
                    self.chord.sequencer.play()
                    self.drum.sequencer.play()
                }
                
                self.isRecording = false
            }
            
        } catch {
            print("renderToFile error: \(error)")
            self.isRecording = false
        }
    }
    
    /// generate a melody
    open func generate(){
        let type = Int.random(in: 0...2)
        let feel = Int.random(in: 0...2)
        
        let mykey = Key(root: NoteClass.C, scale: scales[mood][feel])
        let groove = grooves[genre][type]

        lead.pitchShift = Int8(pitch)
        chord.pitchShift = Int8(pitch)
        
        lead.sequencer.stop()
        chord.sequencer.stop()
        drum.sequencer.stop()
        
        lead.sequencer.setTime(0)
        chord.sequencer.setTime(0)
        drum.sequencer.setTime(0)
        
        updateGenre()
        
        drumGen(groove: groove)
        chordGen(groove: groove, key: mykey)
        leadGen(key: mykey)
        
        drum.sequencer.play()
        lead.sequencer.play()
        chord.sequencer.play()
        
        isPlaying = true
        isGenerated = true
    }
    
    /// update default genre's parameters for all section including insturment , volume and reverb
    internal func updateGenre(){
        switch genre{
            case 0:
                leadSample = 1
                chordSample = 2
                drumSample = 1
                
                leadVolume = 0.5
                chordVolume = 0.5
                drumVolume = 0.5
            
                leadRevMix = 0.4
                chordRevMix = 0.5
                drumRevMix = 0.1
            
            case 1:
                leadSample = 3
                chordSample = 1
                drumSample = 1
                
                leadVolume = 0.5
                chordVolume = 0.4
                drumVolume = 0.5
            
                leadRevMix = 0.6
                chordRevMix = 0.4
                drumRevMix = 0.1
            
            case 2:
                leadSample = 2
                chordSample = 3
                drumSample = 3
                
                leadVolume = 0.5
                chordVolume = 0.4
                drumVolume = 0.7
            
                leadRevMix = 0.7
                chordRevMix = 0.6
                drumRevMix = 0.3
            
            case 3:
                leadSample = 1
                chordSample = 2
                drumSample = 2
                
                leadVolume = 0.4
                chordVolume = 0.5
                drumVolume = 0.7
            
                leadRevMix = 0.6
                chordRevMix = 0.5
                drumRevMix = 0.2
            default:
                break
        }
        updateInsturment()
        updateVolume()
        updateReverb()
    }
    
    /// generate lead note with selected  key
    /// - Parameter key: root key
    internal func leadGen(key: Key){
        lead.track1.clear()
        lead.sequencer.setLength(Duration(beats: Double(bars*4)))
        
        if(isLooping){
            lead.sequencer.enableLooping()
        }
        
        for i in 1...bars{
            lead.generateAbar(noteArray: key.noteSet.array, bar: i)
        }
    }

    /// generate chord with selected groove and key
    /// - Parameters:
    ///   - groove: patten of groove of chords
    ///   - key: root key
    internal func chordGen(groove: String, key: Key){
        var patten = 0
        switch groove{
            case "pop_rock":
                patten = 2
            case "pop_indie":
                patten = 3
            case "pop_edm":
                patten = 4
            case "rock_hard":
                patten = 1
            case "rock_funk":
                patten = 4
            case "rock_punk":
                patten = 1
            case "edm_trap":
                patten = 5
            case "edm_house":
                patten = 4
            case "edm_dub":
                patten = 6
            case "disco_jump":
                patten = 2
            case "disco_pop":
                patten = 3
            case "disco_funky":
                patten = 4
        default:
            break
        }
        chord.generate(patten: patten, k: key, bars: bars)
        if(isLooping){
            chord.sequencer.enableLooping()
        }
    }
    
    /// generate drum with selected groove
    /// - Parameter groove: <#groove description#>
    internal func drumGen(groove: String){
        drum.setMidi(type: groove, bars: bars)
        drum.sequencer.setTempo(Double(tempo))
    }
    
    /// update tempo for all section
    open func updateTempo() {
        lead.sequencer.setTempo(Double(self.tempo))
        chord.sequencer.setTempo(Double(self.tempo))
        drum.sequencer.setTempo(Double(self.tempo))
    }
    
    /// update volume for all section
    open func updateVolume(){
        if(leadSample > 0){
            lead.instrument.amplitude = leadVolume * 50 - 45
        }
        if(chordSample > 0){
            chord.instrument.amplitude = chordVolume * 50 - 45
        }
        if(drumSample > 0){
            drum.instrument.amplitude = drumVolume * 25 - 13
        }
        mixer.volume = masterVolume / 100
    }
    
    /// toggle play or stop state for all section
    open func togglePlay(){
        if(isPlaying){
            lead.sequencer.stop()
            chord.sequencer.stop()
            drum.sequencer.stop()
            
            lead.sequencer.setTime(0)
            chord.sequencer.setTime(0)
            drum.sequencer.setTime(0)
        }
        else{
            drum.sequencer.play()
            lead.sequencer.play()
            chord.sequencer.play()
        }
        isPlaying.toggle()
    }
    
    /// toggle loop functionality for all section
    open func toggleLoop(){
        lead.sequencer.toggleLoop()
        chord.sequencer.toggleLoop()
        drum.sequencer.toggleLoop()
        isLooping.toggle()
    }
    
    /// update sample and volume for all section
    open func updateInsturment(){
        updateLead()
        updateChord()
        updateDrum()
    }
    
    /// update reverb for all section
    open func updateReverb(){
        leadReverb.dryWetMix = leadRevMix
        chordReverb.dryWetMix = chordRevMix
        drumReverb.dryWetMix = drumRevMix
    }
    
    /// update lead sample and volume
    open func updateLead(){
        switch leadSample {
            case 1:
                lead.setSample(url: "Sounds/synth_old")
                lead.instrument.amplitude = leadVolume * 50 - 45
            case 2:
                lead.setSample(url: "Sounds/xylophone")
                lead.instrument.amplitude = leadVolume * 50 - 45
            case 3:
                lead.setSample(url: "Sounds/organ")
                lead.instrument.amplitude = leadVolume * 50 - 45
            default:
                lead.instrument.amplitude = -90
        }
    }
    
    /// update chord sample and volume
    open func updateChord(){
        switch chordSample {
            case 1:
                chord.setSample(url: "Sounds/guitar")
                chord.instrument.amplitude = chordVolume * 50 - 45
            case 2:
                chord.setSample(url: "Sounds/piano")
                chord.instrument.amplitude = chordVolume * 50 - 45
            case 3:
            chord.setSample(url: "Sounds/bell")
                chord.instrument.amplitude = chordVolume * 50 - 45
            default:
                chord.instrument.amplitude = -90
        }
    }
    
    /// update drum sample and volume
    open func updateDrum(){
        switch drumSample {
            case 1:
                drum.setSample(url: "Sounds/DrumK/DrumK")
                drum.instrument.amplitude = drumVolume * 25 - 13
            case 2:
                drum.setSample(url: "Sounds/Modern 808")
                drum.instrument.amplitude = drumVolume * 25 - 13
            case 3:
                drum.setSample(url: "Sounds/African Kit")
                drum.instrument.amplitude = drumVolume * 25 - 13
            default:
                drum.instrument.amplitude = -90
        }
    }
}

