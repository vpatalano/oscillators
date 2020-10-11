
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

 opcode "groscBoulder", a, kk
irisf ftgenonce 0,0,16384,-19,.5,.5,270,.5
kamp, kcps xin
kformant = 2782
koct = 0
kband = 0
irist = 1/300
idur = .08
ares fof kamp, kcps, kformant, koct, kband, irist, idur, irist, 1000, -1, irisf, p3
xout ares
 endop
