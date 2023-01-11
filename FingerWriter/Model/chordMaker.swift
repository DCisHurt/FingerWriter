//
//  chordMaker.swift
//  melodyGen
//
//  Created by test on 12/30/22.
//

import Foundation
import Tonic
import AudioKit


class chordMaker {
    var instrument = AppleSampler()
    var sequencer = AppleSequencer()
    var midiCallback = MIDICallbackInstrument()
    var track1 : MusicTrackManager!
    var genArray : Array<Chord> = []
    var pitchShift: Int8 = 0
    init() {
        midiCallback.callback = { status, note, velocity in
            if status == 144 { //Note On
                self.instrument.play(noteNumber: note, velocity: velocity, channel: 0)
            }
            else if status == 128 { //Note Off
                self.instrument.stop(noteNumber: note, channel: 0)
            }
        }
        track1 = sequencer.newTrack()
        track1.setMIDIOutput(midiCallback.midiIn)
    }
    
    open func generate(patten: Int, k: Key, bars: Int){
        track1.clear()
        sequencer.setLength(Duration(beats: Double(bars*4)))
        
        genArray = []
        
        let chordArray = k.chords
        let Narray = chordArray.count
        for bar in 1...bars {
            let random = Int.random(in: 0..<Narray)
            let newChord = chordArray[random]
            genArray.append(newChord)
            self.addChord(patten: patten, noteArray: newChord, bar: bar)
        }
    }
    
    internal func addChord (patten: Int, noteArray: Chord, bar: Int) {
        let notes = noteArray.noteClasses
        let beat = (bar-1)*4
        var previousNote : Int8 = 0
        for j in notes{
            var numMidi = j.canonicalNote.noteNumber

            if numMidi < previousNote{
                numMidi += 12
                if numMidi < previousNote{
                    numMidi += 12
                }
            }
            previousNote = numMidi
            numMidi = numMidi - 24 + pitchShift
            grooveGen(patten: patten, note: numMidi, position: Double(beat))
        }
    }
    
    internal func grooveGen(patten: Int, note: Int8, position: Double){
        switch patten {
            case 1:
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+0.5),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+1.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+1.5),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+2.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+2.5),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.5),
                           duration: Duration(beats: 0.5))
            case 2:
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position),
                           duration: Duration(beats: 1))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+1.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+1.5),
                           duration: Duration(beats: 1))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+2.5),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.5),
                           duration: Duration(beats: 0.5))
            case 3:
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position),
                           duration: Duration(beats: 1))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+1.0),
                           duration: Duration(beats: 1))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+2.0),
                           duration: Duration(beats: 1))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.5),
                           duration: Duration(beats: 0.5))
            case 4:
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position),
                           duration: Duration(beats: 1))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+1.0),
                           duration: Duration(beats: 0.75))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+1.75),
                           duration: Duration(beats: 0.25))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+2.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+2.5),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.0),
                           duration: Duration(beats: 0.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.5),
                           duration: Duration(beats: 0.5))
            case 5:
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position),
                           duration: Duration(beats: 4))
            case 6:
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position),
                           duration: Duration(beats: 3.5))
                track1.add(noteNumber: MIDINoteNumber(note),
                           velocity: 127,
                           position: Duration(beats: position+3.5),
                           duration: Duration(beats: 0.5))
            default:
                break
        }
    }
    
    open func setSample(url: String){
        try? instrument.loadWav(url)
    }
}
