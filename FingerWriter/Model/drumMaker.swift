import AudioKit


open class drumMaker {
    var instrument = AppleSampler()
    var sequencer = AppleSequencer()
    var midiCallback = MIDICallbackInstrument()
    var track1 : MusicTrackManager!
    init() {
        midiCallback.callback = { status, note, velocity in
            if status == 144 { //Note On
                self.instrument.play(noteNumber: note, velocity: velocity, channel: 0)
            }
            else if status == 128 { //Note Off
                self.instrument.stop(noteNumber: note, channel: 0)
            }
        }
        sequencer = AppleSequencer()
        sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
    }
    
    /// set midi groove
    /// - Parameters:
    ///   - type: type of groove
    ///   - bars: number of bar
    open func setMidi(type: String, bars: Int){
        sequencer.loadMIDIFile("Midi/"+type+"_"+String(bars))
        sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
    }
    
    /// set EXS24 instrument samples from url
    /// - Parameter url: file location of samples
    open func setSample(url: String){
        try? instrument.loadEXS24(url)
    }
}
