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

 opcode "groscOne_i", a, ikkkPPo ;granulize a single segment of a source table
ifsrc, kcps, kstart, kstop, ktransp, kgrsizem, ifwdw xin ;accepts only (pow-of-2) size tables
if ifwdw==0 then
     ifwdw ftgenonce 0,0,16384,-20,5
endif
istart = i(kstart)
kgrsize divz (kstop-kstart)*kgrsizem, ktransp, 1000
ares1 syncloop 1, kcps, ktransp, kgrsize, 0, kstart, kstop, ifsrc, ifwdw, 1000, istart
xout ares1
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
/*
 opcode ptklJ, a, aa
V
agrainfreq, async, awavfm, asamplepos1, asamplepos2, asamplepos3, asamplepos4, kwavefreq, ienv_attack, ienv_decay
kwavekey1, kwavekey2, kwavekey3, kwavekey4, kwaveform1, kwaveform2, kwaveform3, kwaveform4, kduration, kenv2amt, ksustain_amount, 
icosine, 
a1 partikkel agrainfreq, \
              0, -1, async, kenv2amt, ienv2tab, ienv_attack, \
              ienv_decay, ksustain_amount, ka_d_ratio, kduration, kamp, -1, \
              kwavfreq,  .5, -1, -1, awavfm, \
              -1, kfmenv, icosine, ktraincps, knumpartials, kchroma, \
              -1, krandommask, kwaveform1, kwaveform2, kwaveform3, \
              kwaveform4, -1, asamplepos1, asamplepos2, asamplepos3, \
              asamplepos4, kwavekey1, kwavekey2, kwavekey3, kwavekey4, imax_grains \
              [, iopcode_id, ipanlaws]
*/

 opcode "semitSin", a, aao 
asemitamount, acpsmod, iphs
alfo poscil3 asemitamount, acpsmod, -1, iphs
alfo = semitone(alfo)
xout alfo
 endop

 opcode pitchmodJosie_wt, a, aaaajoo ;optional wavetable input
aamp, acps, acpsmod, asemitamount, iwf, iphs, istor xin
amod semitSin asemitamount, acpsmod
ares oscilikt aamp, acps*amod, iwf, iphs, istor
 xout ares
 endop
 
 
 opcode pitchmodJosie_pw, a, aaaakoo ;optional wavetable input
aamp, acps, acpsmod, asemitamount, kpw, iftcos, iphs xin
if (iftcos==0) then
          iftcos ftgenonce 0,0,16384,11,1
endif
amod semitSin asemitamount, acpsmod
kcps downsamp acps
ares gbuzz aamp, acps*amod, int(.5*sr/kcps)-16, 2, 2*abs:k(.5-limit:k(kpw,0,1)), iftcos 
 xout ares
 endop

  opcode "bpnoiseAjax", a, aaaaiVVPPPPP
 acenterf, aamp, acps, afilterbw, inumlayers, kalpha, kbeta, kWht, kGau, kPnk, kBrn, kBet xin
 aRwht unirand 1
 aRgau gauss 1
 aRpnk fractalnoise 1, 1
 aRbrn fractalnoise 1, 2
 aRbet betarand 1, kalpha, kbeta
 aRsum sum aRwht, aRgau, aRpnk, aRbrn, aRbet
 aRsum *= db(-5.75*int((kWht+kGau+kPnk+kBrn+kBet)/2))
 ares resonx aRsum, acenterf, afilterbw, 16, 1
 ares *= aamp
  xout ares
  endop
  
  opcode "Oscil_1pl", a, aaii
 aamp, acps, ift, iphs xin ;in this opcode, aamp is relative to 1
 aamp = abs(aamp)%1
 ares oscil aamp, acps, ift, iphs
 ares += 1
  xout ares
  endop

 opcode "Phasor_1pl", a, aaii
aamp, acps, ift, iphs xin ;in this opcode, aamp is relative to 1
ares phasor aamp, acps, ift, iphs
ares += 1
xout ares
 endop
 
 opcode "shinereson", a, ikV
inumlayers, kbasefreq, kresonance xin
agauss gauss 1
kbw = kbasefreq*.125*kresonance
ares resony agauss, kbasefreq, kbw, inumlayers, kbasefreq, 1, 1
xout ares
 endop
 
 opcode "shinereson_oct", a, ikPV
inumlayers, kbasefreq, koctsep, kresonance xin
agauss gauss 1
kbw = kbasefreq*.125*kresonance
ares resony agauss, kbasefreq, kbw, inumlayers, koctsep, 0, 1
xout ares
 endop
 
 
