s.boot;
QuickLauncher().front;

//SC has 3 primary classes for dealing with MIDI:
/*
1) MIDIClient - Initializes clients.
2) MIDIIn - Handles input messages, but should be used "wrapped" by...
3) MIDIFunc - Registers event handlers for a number of events.
   - noteOff, noteOn, polytouch, control, program, touch, bend, sysex, sysrt, smpte
*/

//Taken from the MIDIClient help.
(
var notes, on, off, control;

MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128); // Meta_CLASSNAME must refer to the argument set required to construct CLASSNAME?

on = MIDIFunc.noteOn({ | veloc, num, chan, src |
	var veloc_mul = 0.00315;
	notes[num] = Synth(\default, [\freq, num.midicps,
	\amp, veloc * veloc_mul]);
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src |
	notes[num].release;
});

//I'm not getting some of my controls through here, and the ones I do get might be on different channels, somehow.
MIDIFunc.cc( {|uid, chan, control_number, val|
	[uid, chan, control_number, val].postln
});

q = { on.free; off.free};

)

/*
Pretty dope.  There are some libraries that make this easier, supposedly.
- MIDIIn Helpfile
- dewdrop_lib
  - Voicer
  - VoicerMIDISocket

I could also send MIDI out.  Say I found a really great synth, but wanted to play an algorithmic pattern.  I could send MIDI to the synth
directly.  I don't know a lot about the MIDI format, honestly.  Sending messages also means syncing clocks.

- MIDIIN::sysrt or smpte "roll your own" response handlers for sync.
- dewdrop_lib
  - MIDISyncCLock

dewdrop_lib, or another quark, maybe, seems like a good place to look if I wanna do crazy MIDI stuff.
*/

s.shutdown;





