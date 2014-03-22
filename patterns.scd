s.boot;
FreqScope.new;

(
SynthDef.new(\derp, { |attackTime = 0.01, decayTime = 0.03, gate = 1, filterFreq = 1600|
	var sig, env;
	env = EnvGen.ar(Env.perc(attackTime, decayTime), gate, doneAction: 2);
	sig = LPF.ar(PinkNoise.ar(env), filterFreq);
	Out.ar(0, sig ! 2);
}).add();

)

x = Synth.new(\derp);

(
TempoClock.default.tempo = 540/60;
Pbind(
	\instrument, \derp,
	\attackTime, Pwhite(0.005, 0.015, inf),
	\decayTime, Pwhite(0.02, 0.035, inf),
	\gate, Prand([0,1], inf),
	\filterFreq, Pwhite(800, 6000, inf)
).play;
)

(
SynthDef.new(\spacetown, {
	var sig, mod;
	mod = XLine.kr(440, 10000, 5, 1, doneAction: 2);
	sig = SinOsc.ar(SinOsc.ar(mod), 0, 0.1);
	Out.ar(0, sig ! 2);
}).add();
)

x = Synth.new(\spacetown);