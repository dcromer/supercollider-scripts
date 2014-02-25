s.boot;
QuickLauncher().front;

(
SynthDef.new(\mod_synth, { |freq = 440, amp = 1,  mod_freq = 2.0, gate = 1|
	var mod = SinOsc.ar(mod_freq, 0, 1);
	var sig = SinOsc.ar(freq * mod, 0, 0.1);
	var env = EnvGen.ar(Env.adsr, gate, doneAction:2);
	Out.ar(0, Pan2.ar(sig * env, 0.0));
}).add;
)

//MIDI Boilerplate, don't judge.
(
var notes, on, off, control, mod_freq = 0;

MIDIClient.init;
MIDIIn.connectAll;

notes = Array.newClear(128);
~synthGroup = Group.new;

on = MIDIFunc.noteOn({ | veloc, num, chan, src|
	var veloc_mul = 0.003;
	notes[num] = Synth(\mod_synth, [\freq, num.midicps,
	\gate, veloc * veloc_mul,
	\mod_freq, mod_freq],
	~synthGroup);
});

off = MIDIFunc.noteOff({ |veloc, num, chan, src |
	notes[num].release;
});

//Any control is bound to my LFO freq.
MIDIFunc.cc( {|val,  num, chan, src|
	var max_mod_freq = 220;
	var control = ControlSpec(1, max_mod_freq, \exponential, default:1);
	mod_freq = 	control.map(val / 127.0);
	~synthGroup.set(\mod_freq, mod_freq);
});

q = { on.free; off.free};

)