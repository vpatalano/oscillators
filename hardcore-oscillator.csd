<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o octave.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

; Required settings for WebAudio:

sr = 48000
ksmps = 128
nchnls = 2
nchnls_i = 1

; sr = 44100
; ksmps = 32
; nchnls = 2
0dbfs  = 1

opcode "SuperVcoSaw_mono", a, kkijj
kcps, kdetune, ivx, iphs, iskipinit xin
if iphs<0 then
     iphs random 0, 1
endif
kcps__ = kcps*semitone(kdetune*ivx)
ares vco2 1, kcps__, 2*(ivx%5), .5, iphs
if ivx>1 then 
anext SuperVcoSaw_mono kcps, kdetune, ivx-1
endif
ares += anext
 xout ares
 endop


instr 1
xtratim 30
aenv linsegr 0,.01,1,2.0,0
asig SuperVcoSaw_mono 72, .09, 8, 0, 0
asig *= aenv
asig2 SuperVcoSaw_mono 288*semitone(-.37), .04, 8, 0, 0
asig *= aenv
asig = tanh(asig*9+asig2*3)
asig K35_lpf asig, 320, 8.0
asig K35_hpf asig, 140, 9.0
asig *= db(-26)
asig, aR babo asig, 0,0,0,200,200,200
asig = tanh((asig%.25))
     outs asig, asig

endin
</CsInstruments>
<CsScore>

i 1 0 1
e

</CsScore>
</CsoundSynthesizer>
