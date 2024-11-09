# Homework #3: Perform live music with multi-modal input!

The goal of this homework is to design a real-time musical interaction system using keyboard and visual input with Chuck. Record a video of yourself performing music with the system you created.

## Due date and deliverables
- **Nov 24 (Sun), 11:59pm**
- Source code file (.ck)
- A short report (.pdf): Describe what you implemented and performed
- A video file of your performance (.mp4): This video should include yourself, your input devices and the sound. You can use your smartphone to record the video. The length should not exceed 30 seconds.
- Make a zip file and submit them to KLMS.

# Baselines
## Practice #1:  Let’s play music with MIDI keyboard and Chuck
You can use the provided MIDI keyboard (AKAI) or your own laptop keyboard.
<img src="https://github.com/juhannam/ctp431-2024/blob/main/mapped_parameters.png?raw=true" height="600"/>

**Code Examples**
1. <a href="https://github.com/juhannam/ctp431-2024/blob/main/poly-midi.ck"> poly-midi.ck </a>
- MIDI input : MIDI keyboard
- Mapped parameters
    1. Joystick: Panning
    2. Pressure sensors: Oscillator on/off (Sine, Triangle, Square), Audio playback
    3. Knob: Volume, Low Pass Filter, High Pass Filter, Reverb (Mix), Decay length
2. <a href="https://github.com/juhannam/ctp431-2024/blob/main/poly-key.ck"> poly-key.ck </a>
- MIDI input : Laptop keyboard (Letter keyboard)
- Mapped parameters
    1. Number keys (0 ~ 9) : Audio playback, Oscillator on/off, Volume -/+, Low Pass Filter -/+, High Pass Filter -/+

## Practice #2: Let’s control the music with faceOSC inputs
Download and install the necessary software <a href="https://github.com/kylemcdonald/ofxFaceTracker/releases"> (FaceOSC) </a>.

**Code Examples**
1. OSC input examples
    1. <a href="https://github.com/juhannam/ctp431-2024/blob/main/faceosc-single-input.ck"> faceosc-single-input.ck </a>
    2. <a href="https://github.com/juhannam/ctp431-2024/blob/main/faceosc-multiple-inputs.ck"> faceosc-multiple-inputs.ck </a>
2. Parameter control examples
    1. <a href="https://github.com/juhannam/ctp431-2024/blob/main/faceosc-audiosynth-fm.ck"> faceosc-audiosynth-fm.ck </a> (sound synthesis):
        - Control the modulation frequency of FM synthesis by the user mouth width
    2. <a href="https://github.com/juhannam/ctp431-2024/blob/main/faceosc-audioeffect-biquad.ck"> faceosc-audioeffect-biquad.ck </a> (audio effect):
        - Control the frequency parameter of bi-quad filter by the user mouth width
    3. <a href="https://github.com/juhannam/ctp431-2024/blob/main/faceosc-gain.ck "> faceosc-gain.ck </a> (basic element):
        - Control the gain of noise by the user mouth width

# Perform live music with multi-modal input!
- Make a short video (less than 30 seconds) that shows you and your computer performing live music.
- Use both your hands (MIDI Keyboard or Computer Keyboard) and face (FaceOSC) to make creative sound.
- Try to add nuances and flavors. Consider implementing the following features:
1. Sound synthesis: FM synthesis, AM Synthesis, Additive Synthesis, …
2. Audio effect: Wah-wah, Distortion, … 
3. MIDI effect: Chord progression changes, Tonality Changes, Arpeggiator, … 
4. ETC: ADSR, Loudness (Fade-in, Fade-out, …), Pitch (Pitch Bending, Vibrato, …), Panning, …

# Submit source code and report
Source code should be well-understandable by adding appropriate amount of comments.

In the report, you should appeal in detail what you’ve materialized.

**Evaluation criteria:**

- **Completeness and Creativity**: The focus will be on the originality and uniqueness of sound effects created beyond the baseline code and basic ChucK examples.
- **Performance Example**: The overall quality and creativity of the live performance will be assessed.

## References
- [Chuck Examples Documentation](https://chuck.stanford.edu/doc/examples/)
- [Youtube Tutorial: Creating Electronic Music with Chuck](https://www.youtube.com/playlist?list=PL-9SSIBe1phI_r3JsylOZXZyAXuEKRJOS)