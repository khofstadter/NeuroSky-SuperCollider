# focus-nf-neurosky-supercollider

Neurofeedback with NeuroSky and SuperCollider. An audio neurogame.

Two parts:

1. focus-neurofeedback:

![screenshot](screenshot-focus-nf.jpg?raw=true "focus-nf")

2. focus-sequencer:

![screenshot](screenshot-focus-seq.jpg?raw=true "focus-sequencer")

## log
* 0.1.8
  - organise synths;
  - made arguments clearer in functions after .value (added UX)
  - panning Ugen parameters are slightly different in each constantSynth.  they are can be controlled by the eSenses.  one side of the Pan is the same, so when 2 synths are mapped to different eSenses (the higher a value the more in phase the sounds are, the lower, the less in phase)
  - victory sound on track 9 (each islet the same)
  - 3 islets (no sea), challenges are there, but they don't move (so no pressure, users can choose each islet manually)' '
  - synths removed;

* 0.1.7 (2020-07-09)
  - can choose which eSense controls constantSynth parameter.  can add 3rd synth that can be controlled by both (change0 and change 3) in ~fadeConstantSynts
  - manual threshold added (~rewCalcTask simplified)
  - new GUI;
  - automove disables;
  - enter straight into sea (new practice)
* 0.1.6 (2016-09-05)
* 0.1.3.7 (2016-06-05)

## TODO
- make constantSynts loader in synthDef, and quieter in islets; 
- test with NeuroSky (3 islets)
- make videos (nf and sequencer)
- make reset load at the beginning of each island (~loadFile.value(track:{all},filename:0); )
- make each islet sound good (loops, rewards, victor sound) - try to use as many reward types as possible;
- if max counter is above the current save max, than start counting: update gui as well;

## later:
- check scale arrays in generate.scd
- clean code;
- make new CMW videos;

## NOTE
- tracks start from 0, not 1 (need to be consistent when talking, naming, commenting, etc; )
