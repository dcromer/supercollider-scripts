FreqScope.new;
s.boot

//Our synth defs
(
SynthDef.new(\blip, { |out = 0, freq = 440, numHarm = 200, dur=0.1, pan = 0.0|
	var env = EnvGen.ar(Env.perc(0.01, dur), 1, 1, doneAction:2);
	var sig = Blip.ar(freq, numHarm, 0.5 * env);
	sig = LPF.ar(sig, freq);
	Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

(
SynthDef.new(\reverb, { |in, out = 0, mix=0, room=0.5, damp=0.5, mul=1 |
	var input = In.ar(in, 2);
	var sig = FreeVerb2.ar(input[0], input[1], mix, room, damp, mul);
	Out.ar(out, sig);
}).add;
)

//Busses.  We only need one.
~effectBus = Bus.control(s, 2);

//Inits a reverb synth + GUI
(
x = Synth(\reverb, [\in, ~effectBus], addAction:\addToTail);
w = Window("Reverb Control", Rect(200, 200, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds, 8@8, 2@2);


EZSlider.new(w.view, 300@80, "Mix", ControlSpec(0.0, 1.0),
	{|ez| x.set(\mix, ez.value)},
	0.33);
EZSlider.new(w.view, 300@80, "Room", ControlSpec(0.0, 1.0),
	{|ez| x.set(\room, ez.value)},
	0.33);
EZSlider.new(w.view, 300@80, "Damp", ControlSpec(0.0, 1.0),
	{|ez| x.set(\damp, ez.value)},
	0.33);

w.front;
w.onClose_({x.free});
)


//Plays the blips from random semitones within a scale.
//This shows the available scales.
Scale.directory;
(
var scale = Scale.major;

{
inf.do{ |i|
	var note = scale.degreeToFreq(rrand(0,12), 60.midicps, 0);
		Synth(\blip, [\freq, note,
			\numHarm, exprand(100, 1000),
			\dur, rrand(0.1, 0.5),
			\pan, rand2(1.0),
			\out, ~effectBus]);
	0.1.wait;
};
}.fork)
x.free;