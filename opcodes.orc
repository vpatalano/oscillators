#ifdef CALCULATE_VCO2INIT_TABLES
ginextfree vco2init 16, $CALCULATE_VCO2INIT_TABLES, -1, 2048, 16384, -1 ;triangle
ginextfree vco2init 8, ginextfree, -1, 2048, 16384, -1 ;square
ginextfree vco2init 4, ginextfree, -1, 2048, 16384, -1 ;pulse
ginextfree vco2init 2, ginextfree, -1, 2048, 16384, -1 ;integ saw
ginextfree vco2init 1, ginextfree, -1, 2048, 16384, -1 ;saw
#end

 opcode schmuzz, a, aaPOPopp
aamp, acps, klfocps, klfodc, klfoscl, iftcos, iharmonics, ilowh xin
if (iftcos==0) then
          iftcos ftgenonce 0,0,16384,11,1
endif
inumh = int((sr/2)/p5)*iharmonics
kmul oscil klfoscl, klfocps
kmul = klfodc+.5+kmul*.5
ares gbuzz aamp, acps, inumh, ilowh, kmul, iftcos
xout ares
 endop

 opcode "SuperVcoSaw_mono", a, kkkijj
kamp, kcps, kdetune, ivx, iphs, iskipinit xin
if iphs<0 then
     iphs random 0, 1
endif
kcps__ = kcps*semitone(kdetune*ivx)
ares vco2 kamp, kcps, -iskipinit, 0, iphs
if ivx>1 then 
anext SuperVcoSaw_mono kamp, kcps, kdetune, ivx-1
endif
ares += anext
xout ares
 endop

 opcode "groscBoulder", a, ikkOOOO
irisf ftgenonce 0,0,16384,-19,.5,.5,270,.5
igdur, kamp, kcps, kformant, kspread, koct, kband xin ;3 arguments required, 3 optional
kformant = kcps*semitone:k(kformant) ;input kformant in units of semitones
kband = 0 ;bandwidth setting for FOF, usually zero
klfo phasor 1
klfo= (klfo > .5 ? (1-klfo):klfo) ;make triangle
kband += klfo*.25 ;bit of octave warble
irist = igdur/7 ;rise time
klfogrpitch lfo kspread, kcps*.5, 2 ;bisq
kformant *= semitone:k(klfogrpitch)
ares fof kamp, kcps, kformant, koct, kband, irist, igdur, irist, 1000, -1, irisf, p3
xout ares
 endop
