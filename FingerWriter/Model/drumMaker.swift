//
//  Sequencer.swift
//  SimpleSequences
//
//  Created by Nicholas Arner on 5/20/16. Edited Andy Hunt 10/07/22
//  Copyright © 2022 University of York Department of Electronic Engineering
//
//  This file contains 2 samples and 2 MIDI file.
//  Alter the comments to choose which one of each you want to be active

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
    
    open func setMidi(type: String, bars: Int){
        sequencer.loadMIDIFile("Midi/"+type+"_"+String(bars))
        sequencer.setGlobalMIDIOutput(midiCallback.midiIn)
    }
    
    open func setSample(url: String){
        try? instrument.loadEXS24(url)
    }
}
