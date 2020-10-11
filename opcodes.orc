
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

 opcode "SuperVcoSaw_mono", a, kkki
kamp, kcps, kdetune, ivx xin
ares vco2 kamp, kcps*semitone(kdetune*ivx), 0, 0, random:i(0,1)
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
