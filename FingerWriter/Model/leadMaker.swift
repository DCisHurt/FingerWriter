import Foundation
import Tonic
import AudioKit

class leadMaker{
    var instrument = AppleSampler()
    var sequencer = AppleSequencer()
    var midiCallback = MIDICallbackInstrument()
    var track1 : MusicTrackManager!
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
    
    /// generate a bar of notes
    /// - Parameters:
    ///   - noteArray: notes content
    ///   - bar: start position of the bar
    open func generateAbar(noteArray: Array<Note>, bar: Int){
        let beatSeeds = [0.5]
        let Nnotes = noteArray.count
        let startBeat = Double((bar-1)*4)
        var beatCount = 0.0

        for _ in 0...7 {
            let random = Int.random(in: 0..<Nnotes)
            let newNote = noteArray[random]
            var duration = beatSeeds[Int.random(in: 0..<beatSeeds.count)]
            if (beatCount + duration) > 4{
                duration = 4.0 - beatCount
            }
            track1.add(noteNumber: MIDINoteNumber(newNote.noteNumber +
                       pitchShift + 12*Int8.random(in: 0...1)),
                       velocity: 127,
                       position: Duration(beats: beatCount + startBeat),
                       duration: Duration(beats: duration))
            beatCount += duration
        }
    }
    
    /// set EXS24 instrument samples from url
    /// - Parameter url: file location of samples
    open func setSample(url: String){
        try? instrument.loadWav(url)
    }
}
