#ifdef CALCULATE_VCO2INIT_TABLES
ginextfree vco2init 16, $CALCULATE_VCO2INIT_TABLES, -1, 2048, 16384, -1 ;triangle
ginextfree vco2init 8, ginextfree, -1, 2048, 16384, -1 ;square
ginextfree vco2init 4, ginextfree, -1, 2048, 16384, -1 ;pulse
ginextfree vco2init 2, ginextfree, -1, 2048, 16384, -1 ;integ saw
ginextfree vco2init 1, ginextfree, -1, 2048, 16384, -1 ;saw
#end

  opcode "Oscil_1pl", a, aaii
 aamp, acps, ift, iphs xin ;in this opcode, aamp is relative to 1
 aamp = abs(aamp)%1
 ares oscil aamp, acps, ift, iphs
 ares += 1
  xout ares
  endop

 opcode "Phasor_1pl", a, ai
acps, iphs xin ;in this opcode, aamp is relative to 1
ares phasor acps, iphs
ares += 1
xout ares
 endop

 opcode "semitSin", a, aao 
asemitamount, acpsmod, iphs xin
alfo poscil3 asemitamount, acpsmod, -1, iphs
alfo = semitone(alfo)
xout alfo
 endop

 opcode "molybdenite", a, aaPOPopp
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

 opcode "amethyst", a, kkkijj
kamp, kcps, kdetune, ivx, iphs, iskipinit xin
if iphs<0 then
     iphs random 0, 1
endif
kcps__ = kcps*semitone(kdetune*ivx)
ares vco2 kamp, kcps, -iskipinit, 0, iphs
if ivx>1 then 
anext amethyst kamp, kcps, kdetune, ivx-1
endif
ares += anext
 xout ares
 endop

 opcode "brookite", a, ikkkPPo ;granulize a single segment of a source table
ifsrc, kcps, kstart, kstop, ktransp, kgrsizem, ifwdw xin ;accepts only (pow-of-2) size tables
if ifwdw==0 then
     ifwdw ftgenonce 0,0,16384,-20,5
endif
istart = i(kstart)
kgrsize divz (kstop-kstart)*kgrsizem, ktransp, 1000
ares1 syncloop 1, kcps, ktransp, kgrsize, 0, kstart, kstop, ifsrc, ifwdw, 1000, istart
xout ares1
 endop

 opcode "brucite", a, ikkOOOO
irisf ftgenonce 0,0,16384,-19,.5,.5,270,.5
igdur, kamp, kcps, kformant, kspread, koct, kband xin ;3 arguments required, 3 optional
kformant = kcps*semitone:k(kformant) ;input kformant in units of semitones
kband = 0 ;bandwidth setting for FOF,usually zero
klfo phasor 1
klfo= (klfo > .5 ? (1-klfo):klfo) ;make triangle
kband += klfo*.25 ;bit of octave warble
irist = igdur/7 ;rise time
klfogrpitch lfo kspread, kcps*.5, 2 ;bisq
kformant *= semitone:k(klfogrpitch)
ares fof kamp, kcps, kformant, koct, kband, irist, igdur, irist, 1000, -1, irisf, p3
 xout ares
 endop

 opcode "gibbsite", a, aaaaaaakkOVVOPPPPJJJJJooo
;                                                                                                                 default=0.5                  default=0            default=1             default=1              default=-1              default=-1          default=0             default=0
;                                                                                                    default=0                     default=0.5           default=1             default=1             default=-1              default=-1              default=-1            default=0          
agrainfreq, async, awavfm, asamplepos1, asamplepos2, asamplepos3, asamplepos4, kwavfreq,  kduration, krandommask, ksustain_amount, ka_d_ratio, kenv2amt, kwavekey1, kwavekey2, kwavekey3, kwavekey4, kwaveform1, kwaveform2, kwaveform3, kwaveform4, kfmenv, ienv_attack, ienv_decay, ienv2tab xin
asig	partikkel agrainfreq, 0, -1, async, kenv2amt, ienv2tab, \
               ienv_attack, ienv_decay, ksustain_amount, ka_d_ratio, kduration, 1, -1, \
               kwavfreq, 0, -1, -1, awavfm, \
               -1, kfmenv, -1, 0, 0, \
               0, -1, krandommask, kwaveform1, kwaveform2, kwaveform3, kwaveform4, \
               -1, asamplepos1, asamplepos2, asamplepos3, asamplepos4, \
               kwavekey1, kwavekey2, kwavekey3, kwavekey4, 256
xout asig
 endop
 
 opcode "glauberite", a, aaakkOVVOPPPPJooojo
agrainfreq, async, awavfm, kwavfreq, kduration, krandommask, ksustain_amount, ka_d_ratio, kenv2amt, kwavekey1, kwavekey2, kwavekey3, kwavekey4, kfmenv, ienv_attack, ienv_decay, ienv2tab, isin, iphs xin
asig gibbsite agrainfreq, async, awavfm, a(iphs), a(iphs), a(iphs), a(iphs), kwavfreq, kduration, krandommask, ksustain_amount, ka_d_ratio, kenv2amt, kwavekey1, kwavekey2, kwavekey3, kwavekey4, k(isin), k(isin), k(isin), k(isin), kfmenv, ienv_attack, ienv_decay, ienv2tab 
xout asig
 endop

 opcode "overite", a, aaaajoo ;optional wavetable input
aamp, acps, acpsmod, asemitamount, iwf, iphs, istor xin
amod semitSin asemitamount, acpsmod
ares oscilikt aamp, acps*amod, iwf, iphs, istor
 xout ares
 endop
 
 
 opcode "orpiment", a, aaaakoo ;optional wavetable input
aamp, acps, acpsmod, asemitamount, kpw, iftcos, iphs xin
if (iftcos==0) then
          iftcos ftgenonce 0,0,16384,11,1
endif

amod semitSin asemitamount, acpsmod
kcps downsamp acps
ares gbuzz aamp, acps*amod, int(.5*sr/kcps)-16, 2, 2*abs:k(.5-limit:k(kpw,0,1)), iftcos 
 xout ares
 endop

  opcode "realgar", a, aaaaiVVPPPPP
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
   
 opcode "lapislazuli", a, ikV
inumlayers, kbasefreq, kresonance xin
agauss gauss 1
kbw = kbasefreq*(1/32)*kresonance
ares resony agauss, kbasefreq, kbw, inumlayers, inumlayers, 1, 1
xout ares
 endop
 
 opcode "larimar", a, ikPV
inumlayers, kbasefreq, kresonance, koctsep xin
agauss gauss 1
kbw = kbasefreq*(1/32)*kresonance
ares resony agauss, kbasefreq, kbw, inumlayers, inumlayers*koctsep, 0, 1
xout ares
 endop
 
 opcode "quartz", a, ko
kcps, ifn xin 
ares pluck 1, kcps, 16383, ifn, 1
xout ares
 endop

 opcode "tantalite", a, akkkko
ain, kcps, kphasertrnsp, knum, kdbfeedback, iatktime xin
ares phaser1 ain, kcps*semitone:k(kphasertrnsp), knum, db(kdbfeedback)
aenv expseg 0.0001, iatktime, 1, 100000, 1
ares *= aenv
xout ares
 endop

 opcode "alforsite", aaaaaaaa, kakkikkkkaaaaPPPPOPo
kamp, agrainfreq, kwavfreq, kduration, ienv2tab, kwaveform1, kwaveform2, kwaveform3, kwaveform4, asamplepos1, asamplepos2, asamplepos3, asamplepos4, kwavekey1, kwavekey2, kwavekey3, kwavekey4, krandommask, ixtratim, iopcode_id xin
xtratim ixtratim
kflag release
if (kflag==1) then
agrainfreq = 0
endif
irandft ftgentmp 0,0,32,-21,1,7 ;random values between 0 and 7
tablew 0, 0, irandft, 0 ;write to table with raw index
tablew 31, 1, irandft, 0 ;write to table with raw index
ichannelmasks = irandft
iwaveamptab = -1 ; default: even mix of all 4 waveforms and no trainlets
iwavfreqstarttab = -1
iwavfreqendtab = -1
awavfm init 1
ifmamptab = -1
kfmenv = -1
ienv_attack = -1 ;default rise shape
ienv_decay = -1 ;default release shape
ksustain_amount init 1 ;no attack/decay except env2
ka_d_ratio init .5 ;insignificant
igainmasks = -1 ;default: no gain masking
idisttab = -1
kdistribution init 0
async init 0
ksweepshape = 0
kenv2amt = 1 ;full windowing
imax_grains = 1000
a1 , a2, a3, a4, a5, a6, a7, a8 partikkel agrainfreq, \
              kdistribution, idisttab, async, kenv2amt, ienv2tab, ienv_attack, \
              ienv_decay, ksustain_amount, ka_d_ratio, kduration, kamp, igainmasks, \
              kwavfreq, ksweepshape, iwavfreqstarttab, iwavfreqendtab, awavfm, \
              ifmamptab, kfmenv, -1,0,0, 0, \
              ichannelmasks, krandommask, kwaveform1, kwaveform2, kwaveform3, \
              kwaveform4, iwaveamptab, asamplepos1, asamplepos2, asamplepos3, \
              asamplepos4, kwavekey1, kwavekey2, kwavekey3, kwavekey4, imax_grains, \
              iopcode_id
xout a1, a2, a3, a4, a5, a6, a7, a8
 endop

 
 opcode psykick1, a, iiioj
icps_start, icps_end, isweep, ishape, isin xin
af1 expon icps_start, isweep, icps_end
af1 pdhalfy af1, ishape, 0, icps_start
ares oscili 1, af1, isin
xout ares
 endop
 
 opcode psybass1, a, iipoo 
icps,icos,imul,icurve,itime xin 
itime = ( itime==0 ? p3 : itime)
kmel transeg  .99, p3,icurve, .8^imul
ares gbuzz .95, icps, int((1/3)*.5*sr/icps), 1.995, kmel, 67
xout ares
 endop

 opcode "gaussHat", a, 0
aenv expon 1, .08, .125
ares gauss 1
aresd diff ares
aresd balance aresd, ares
aresd *= aenv
xout aresd
 endop
 
 
 opcode carnotite, a, kOp
knew, kchamt, inlayers xin
klfo1 jitter kchamt, 2, 4.6
klfo2 jitter kchamt, 1.9, 4.7
asig vco 1, knew*semitone(klfo1), 1, 0, 1, 1, .999999995, .125
asig = .25*tanh(asig*2)
asig2 vco 1, knew*semitone(-klfo2), 1, 0, 1, 1, .999999995, .25
asig2 diff asig2
anext init 0
loop:
inlayers += -1
if inlayers>0 then
ares1 carnotite knew, kchamt, inlayers
igoto loop
endif
asig dcblock asig+asig2	;remove DC
asig *= .0625*.25
;asig phaser1 asig, knew*semitone(3), 36, .975867
;asig tonex asig, 16*49, 2
xout asig
 endop
 
