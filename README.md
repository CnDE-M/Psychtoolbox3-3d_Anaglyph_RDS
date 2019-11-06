# 3D anaglyph Random Dot Stereogram

The project is to reproduce "dynamic RDSs stereopsis experiment" based on the study of Zhaoping and Ackermann (2018)<sup>[1]</sup>. Instead of using mirror stereoscope, screen is designed into 3D anaglyph, and subjects are asked to wear **red-blue glass** through the experiments. 

The experiment is produced with Psychtoolbox-3.

## Introduction

The experiment is to test stereoscopic depth detection in central and peripheral vision field, and stereoscopic depth is formed by 2 properties between left and right vision image
+ position disparity 
+ contrast correlation 

In each trial, subject will focus to fixation cross, so that RDS frames displayed later will either reflect to one' central or peripheral vision field. Then, 15 independent dynamic RDS frames are presented with equal displaying intervals. Those RDS frames all consist of one inner and one outer planes, only dots within inner plane shows disparity and specific correlation. All those RDS frames share the same disparity and correlation properties, so the continuing stimuli will form a stable vision depth if detectable. After the stimuli, subjects will response if they detect depth between inner plane and outer plane, and the depth order of two planes.

According to previous research: 
(2) anti-correlation form vision depth;linear
(3) peripheral / central vision depth performance;
(3) peripheral / central vision field different performance on: size, acuration, linear


## Design

All parameters and trial settings are consistent to design in Zhaoping and Ackermann (2018) study.

### Elements Settings per trial:

1. Condition:

+ Vision field: 
  Subject fix the gaze to certain area so that frames will fall into either central or peripheral receptive field.
  - Central vision field; 
  - Peripheral vision field;

+ Correlation: properties of dots which contrast (black or white) are the same both in left vision image or right vision image.
  - Full-correlated; 
  - Half-correlated; 
  - Anti-correlated;


2. Screen display

<div align=center>
	<img width="800" height="430" src="screen_display.jpg"/>
</div>

+ Plane
  - inner plane: with disparity;
  - outer plane: zero disparity;
  - surrounding ring: no dots in expriment 4-5;

+ Dots stimulus:
square, coordinate randomly generated, all dot area cover 25% of all plane area

+ Red fixation cross
Gaze fixation so that frame will reflect into whether central or peripheral vision receptive field.



### Experiment Process:

<div align=center>
	<img width="800" height="381" src="experiment_process.jpg"/>
</div>

[1] Practice Session
	This is to help subjects familiar with the experiments, but also the validation of subjects' response.

+ 1. 
	Vision Field: Central;
	Correlation: Full-Correlated
    RDS frame: 1 static, 2s per frame.
	Trial number per condition: 10;

+ 2. 
	Vision Field: Central;
	Correlation: Full-Correlated
    RDS frame: 15 dynamic, 0.1s per frame.
	Trial number per condition: 10;

+ 3. 
	Vision Field: Central + Peripheral;
	Correlation: Full-Correlated
    RDS frame: 15 dynamic, 0.1s per frame.
	Trial number per condition: 10;
	In ramdon order;

+ 4. 
	Vision Field: Central + Peripheral;
	Correlation: Full-Correlated + Half-Correlated + Anti-Correlated
    RDS frame: 15 dynamic, 0.1s per frame.
	Trial number per condition: 1;
	In random order

If correctness in Practice 1-3 all higher than 90%, then subject can start to Practice 4 and all formal Experiments.


[2] Formal Experiment
This is to help subjects familiar with the experiments, but also the validation of subjects' response.

+ 1. 
	Vision Field: Central + Peripheral;
	Correlation: Full-Correlated + Half-Correlated + Anti-Correlated
    RDS frame: 15 dynamic, 0.1s per frame.
	Trial number per condition: 1;
	In random order;

+ 2. 
	To test if vision field affect length perception
    -> Dot size, ring size, cross size, cross-to-disk distance, disparity distance are halved in central vision trials.


+ 3. 
	To test if vision field affect length perception
    -> Dot size, ring size, cross size, cross-to-disk distance are halved in central vision trials; disparity is doubled in peripheral vision trials.

+ 4. 
	Same setting as Experiment 2
	No dot is generatedn in r and R<sub>1</sub> radium range.

+ 5.
	Same setting as Experiment 3
	No dot is generatedn in r and R<sub>1</sub> radium range.


### Script and Function

"StereoVision_expr_Anaglyph_3D.m"
	Run.
	Process all practice and experiments in sequence.
	For each session, call functions including:

+ "expr_para_generator.m"
	Save and randomly generate parameters for each experiments;

+ "load_trials.m"
	Load parameters in sequence to generate each trial;
	- Pre-fixation Stage:
	A fixation cross with hint on left and right side.
	- Fixation Stage:
	The fixation cross keep present.
	Call ""anaglyph_3D_trial.m" to draw elements on screen. 15 independent RDS frames popping out with equal intervals, (in Practice 1, RDS frame are static).
	After presenting, subject reponses on plane depth order are collected.

+ "anaglyph_3D_trial.m"
	Draw all elements composed of each RDS frame.

	Below shows one RDS frame (with no anaglyph filter)

<div align=center>
	<img width="700" height="530" src="trial_example.jpg"/>
</div>


+ "angle_to_pixel.m"
	All length are in vision angle unit. The function is to convert vision angle to pixel.

	Below explains the convertion calculation:

<div align=center>
	<img width="1000" height="340" src="angle_convertion.jpg"/>
</div>



## Question

1. Why central fixation cross shown in both peripheral vision trials and central vision trials?

2. Why psychophysics experiments require much less subjects?

3. The paper mentioned “response non-linearity” and “visual acuity” difference on peripheral vision field and central vision field.
Can we add gradient to correlated properties, from 0 to 1, and collect the percentage of vision depth recognition for each correlated property?  The vision depth recognition percentage changing by correlated percentage may increase/decrease smoothly, or increase/decrease suddenly at a threshold?
Would deliberately vague image in central vision field form vision depth, as is the situation of low visual acuity in peripheral vision field?



## Reference

[1] Zhaoping L, Ackermann J. Reversed Depth in Anticorrelated Random-Dot Stereograms and the Central-Peripheral Difference in Visual Inference[J]. Perception, 2018, 47(5): 531-539.