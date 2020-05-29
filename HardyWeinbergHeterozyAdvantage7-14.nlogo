
globals [ currentgeneration ]

;[malesHMZDom maleHMZDom]; three genotypes of males homozyg dominant, heterzy, homozyg recessive
;[malesHETZ maleHETZ]; AA, Aa, aa
;[malesHMZRec maleHMZRec]
   ; different types of turtles and should be put with plural followed by singular
;[femalesHMZDom femaleHMZDom]; 3 genotypes of females (AA, Aa, aa)
;[femalesHETZ femaleHETZ]
;[femalesHMZRec]
breed [people person] 
breed [mosquitos mosquito] ; mosquito vector              ; example. [wolves wolf]  
                ; this way you can call all wolves or one specific wolf
breed [forest]
people-own [ allele1 allele2 gender generation ] ; allows people and person to own attributes of genotype and gender

to setup
  ca  ;short for clear-all
  reset-ticks ; sets ticks back to zero when pushing the setup button 
  set currentgeneration 1
ask patches with 
[
  pxcor >= 0
] ; set up the color of the green right side
[
  set pcolor 56
]
ask patches with 
[
  pxcor < 0
] ; set up the color of the highlands
[
  set pcolor 36
]

create-people HomozygousDominantMales
[
  set generation 1
  set allele1 1; means there two versions of each allele 0=a 1=A
  set allele2 1
  set gender 1; means there are 2 different genders 0= female 1= males
]
create-people HeterozygousMales
[
  set generation 1
  ifelse random 2 = 0 [set allele1 0 set allele2 1][set allele1 1 set allele2 0]; means there two versions of each allele 0=a 1=A
  set gender 1; means there are 2 different genders 0= female 1= males
]
create-people HomozygousRecessiveMales
[
  set generation 1
  set allele1 0; means there two versions of each allele 0=a 1=A
  set allele2 0
  set gender 1; means there are 2 different genders 0= female 1= males
]
create-people HomozygousDominantFemales
[
  set generation 1
  set allele1 1; means there two versions of each allele 0=a 1=A
  set allele2 1
  set gender 0; means there are 2 different genders 0= female 1= males
]
create-people HeterozygousFemales
[
  set generation 1
  ifelse random 2 = 0 [set allele1 0 set allele2 1][set allele1 1 set allele2 0]
  set gender 0; means there are 2 different genders 0= female 1= males
]
create-people HomozygousRecessiveFemales
[
  set generation 1
  set allele1 1; means there two versions of each allele 0=a 1=A
  set allele2 1
  set gender 0; means there are 2 different genders 0= female 1= males
]

express 

 create-mosquitos Number_of_mosquitos ; create a turtle good guys variable number of goodguys for slider
  [set shape "mosquitos"; make a person shape
    set size 2; make person size 1
    ;set color blue; make the person blue
    setxy (random max-pxcor) (random-ycor)]; just put the person in a random place
  
 create-forest Number_of_forest
 [set shape "trees"; make trees
   set size 4; make the tree size 4
   setxy -9  -6 pen-down]
 ask forest [fd 2]
 ask patch 8 8 [ask patches in-radius 4 [set pcolor brown]]
end

to go
  if not any? people with [generation = currentgeneration] [ show (word "Nobody in generation " currentgeneration ".  Stopping.") stop ]
  ask turtles with [breed != forest] ; ask all breeds to move between 1 and 29 spaces (!= bang equals means not equal to so exclude forest)
    [
    rt (random 20) lt (random 20)  ; with helps you make exceptions
    if patch-ahead 1 = nobody ; makes sure they haven't gone off the edge (end)
      [rt 180]; right turn 180 degrees
    ask mosquitos [if (pxcor = 0) [ set heading 90 fd 1]]
    fd 1
    ask people [
      if any? mosquitos in-radius 1 [
        ifelse allele1 = 1 and allele2 = 1
          [ifelse (random 100) > (HomozygousDominantSurvivalChance - 1) [show "I'm dead, argh" die][show "I survived Malaria"]]
          [ifelse allele1 = 1 and allele2 = 0 or allele1 = 0
            [ifelse (random 100) > (HeterozygousSurvivalChance - 1) [show "I'm dead, argh" die][show "I survived Malaria"]]
            [if allele1 = 0 and allele2 = 0 [
              ifelse (random 100) > (HomozygousRecessiveSurvivalChance - 1) [show "I'm dead, argh" die][show "I survived Malaria"]]
            ]
          ]
          
        ]
      ]
    ]
    
  wait .3
  ask people [people_breed]
  tick
end

;SUBROUTINES FOLLOW BELOW

to people_breed ; subroutine to let males and females find each other
  let TEMP1 0
  let TEMP2 0
  ask people with [gender = 0]
    [ifelse any? people with [gender = 1 and generation = [generation] of myself ]  in-radius 2 
   [
      repeat 2
      [
      
      ifelse random 2 = 0 [set TEMP1 allele1][set TEMP1 allele2] ; flipping the coin
      ask one-of people with [gender = 0] in-radius 2
      [
        ifelse random 2 = 0 [set TEMP2 allele1][set TEMP2 allele2] 
        
          hatch-people 1 
          [ 
            set generation generation + 1
            set allele1 TEMP1
            set allele2 TEMP2
            express
            fd (random 3)
          ]
      ]  
      ]
      ask one-of people with [gender = 0] in-radius 2
      [
        die
      ]
      die
   ] [ setxy random-xcor random-ycor]
 ] 
 ask people ;ask goodguys [if any? badguys in-radius 1 [di
      
      [ 
        if (Recessive_lethals = true)
        [ ;show "I'm checking"
          if ((allele1 = 0) and (allele2 = 0))
          [show" I'm dead, argh"
            die
          ] 
        ]  
      ]
end

to express
  ask people
[
  if gender = 0 and allele1 = 0 and allele2 = 0  
  [ set shape "femalesHMZRec"; make female homozygous recessive aa
    set size 3
    setxy (random-xcor) (random-ycor); just put the person in a random place
]

   if gender = 1 and allele1 = 0 and allele2 = 0  
  [ set shape "malesHMZRec"; make female homozygous recessive aa
    set size 3
    setxy (random-xcor) (random-ycor); just put the person in a random place
   ]
 
   if gender = 0 and ( allele1 = 1 and allele2 = 0 ) OR ( allele1 = 0 and allele2 = 1)
  [ set shape "femalesHETZ"; make female homozygous recessive aa
    set size 3
    setxy (random-xcor) (random-ycor); just put the person in a random place
   ]
 
   if gender = 1 and ( allele1 = 1 and allele2 = 0 ) OR ( allele1 = 0 and allele2 = 1)
  [ set shape "malesHETZ"; make female homozygous recessive aa
    set size 3
    setxy (random-xcor) (random-ycor) ; just put the person in a random place
   ]

  if gender = 0 and allele1 = 1 and allele2 = 1
  [ set shape "femalesHMZDOM"; make female homozygous recessive aa
    set size 3
    setxy (random-xcor) (random-ycor) ; just put the person in a random place
   ]

  if gender = 1 and allele1 = 1 and allele2 = 1
  [ set shape "malesHMZDom"; make female homozygous recessive aa
    set size 3
    setxy (random-xcor) (random-ycor); just put the person in a random place
   ]
]
end

to bounce
  if patch-ahead 1 = nobody; makes sure they haven't gone off the edge (end)
  [
    rt 180; right turn 180 degrees
  ]
  
    
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
649
470
16
16
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
29
43
93
76
NIL
Setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
695
31
990
64
HomozygousDominantMales
HomozygousDominantMales
0
100
4
1
1
Males AA purple
HORIZONTAL

SLIDER
701
80
970
113
HeterozygousMales
HeterozygousMales
0
100
4
1
1
Males Aa orange
HORIZONTAL

SLIDER
698
132
990
165
HomozygousRecessiveMales
HomozygousRecessiveMales
0
100
4
1
1
Males aa white
HORIZONTAL

SLIDER
696
198
1019
231
HomozygousDominantFemales
HomozygousDominantFemales
0
100
4
1
1
Females AA purple
HORIZONTAL

SLIDER
696
255
995
288
HeterozygousFemales
HeterozygousFemales
0
100
4
1
1
Females Aa orange
HORIZONTAL

SLIDER
700
309
1019
342
HomozygousRecessiveFemales
HomozygousRecessiveFemales
0
100
4
1
1
Females aa white
HORIZONTAL

SLIDER
673
353
846
386
Number_of_mosquitos
Number_of_mosquitos
0
100
7
1
1
NIL
HORIZONTAL

SLIDER
670
394
842
427
number_of_forest
number_of_forest
0
5
5
1
1
NIL
HORIZONTAL

BUTTON
120
46
183
79
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
2
101
202
134
Heterozygote_Advantage
Heterozygote_Advantage
0
1
-1000

SWITCH
17
159
174
192
Recessive_Lethals
Recessive_Lethals
0
1
-1000

PLOT
6
220
206
370
Allele Counts
Ticks
Number of A (black) or a (red)
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks count people with [allele1 = 1]"
"pen-1" 1.0 0 -2674135 true "" "plotxy ticks count people with [allele1 = 0]"

SLIDER
940
376
1213
409
HomozygousDominantSurvivalChance
HomozygousDominantSurvivalChance
0
100
0
1
1
%
HORIZONTAL

SLIDER
941
413
1213
446
HeterozygousSurvivalChance
HeterozygousSurvivalChance
0
100
50
1
1
%
HORIZONTAL

SLIDER
942
452
1219
485
HomozygousRecessiveSurvivalChance
HomozygousRecessiveSurvivalChance
0
100
100
1
1
%
HORIZONTAL

BUTTON
32
371
155
404
Next Generation
set currentgeneration (currentgeneration + 1)
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
29
402
163
451
Current Generation
currentgeneration
3
1
12

@#$#@#$#@
## Overview
	1. Purpose
		Model Hardy Weinberg situations using the breeding bunny idea from PBS. 			Additional idea is to include heterozygote advantage, recessive lethality
	2. Entities, State Variables, and Scales
		Entities:agents: genotypes of host organism- humans (sickle cell anemia), 			pathogens mosquito vectors (ex.malaria), 
			patches environment: highlands, lowlands with swamps
		State Variable: age, gender, mating, hatching, generation, health 				(fitness)
		Scales: generation
	3. Process Overview and Scheduling
		a. reach a certain age (known genotype) option of infection
		b. find a mate (random???... infection?)
		c. hatch offspring
		d. determine the genotype 
		e. survival based on genotype and location, temp, pathogens (highland or 			swamp)
		f. one generation report p and q and show graph of changes in p and q 				variables (in frequency decimals)
		g. can change location, distance migrated, temperature, season, fitness 
		h. slider of survivability of p^2 and q^2, mobility of population
		i. set initial p and q values (must = 1)

, 
## Design Concepts
	4. Design Concepts

## Details
	5. Initialization
		a) setup 2 large patches representing highlands (light brown) and low land 				swamp (lite green)
		b) turtles-own gender & genotype give humans genotypes (intial situation); mosquito (temperature)
		c) expose to mosquitos, random  chance of infection or (slider % chance)
		d) 
	6. Input Data
	7. Submodels
		a) movement of males and females to meet up and mate, yield genotype
		b) need 3 clothes colors of humans purple AA; orange Aa; white aa; males 				Blue girls Pink
		c) infection model
		d) calculation of p and q values for chart
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

femaleshetz
false
0
Circle -2064490 true false 110 5 80
Polygon -955883 true false 120 90 105 195 90 285 105 300 135 300 150 300 165 285 195 300 210 285 195 195 180 90
Rectangle -2064490 true false 135 75 165 90
Polygon -2064490 true false 180 90 240 150 210 180 180 120
Polygon -2064490 true false 120 90 60 135 90 180 120 120
Rectangle -16777216 true false 105 0 195 15
Rectangle -16777216 true false 105 15 120 75
Rectangle -16777216 true false 180 15 195 75

femaleshmzdom
false
0
Circle -2064490 true false 110 5 80
Polygon -8630108 true false 120 90 105 195 90 285 105 300 135 300 150 300 165 285 195 300 210 285 195 195 180 90
Rectangle -2064490 true false 135 75 165 90
Polygon -2064490 true false 180 90 240 150 210 180 180 120
Polygon -2064490 true false 120 90 60 135 90 180 120 120
Rectangle -16777216 true false 105 0 195 15
Rectangle -16777216 true false 105 15 120 75
Rectangle -16777216 true false 180 15 195 75

femaleshmzrec
false
0
Circle -2064490 true false 110 5 80
Polygon -1 true false 120 90 105 195 90 285 105 300 135 300 150 300 165 285 195 300 210 285 195 195 180 90
Rectangle -2064490 true false 135 75 165 90
Polygon -2064490 true false 180 90 240 150 210 180 180 120
Polygon -2064490 true false 120 90 60 135 90 180 120 120
Rectangle -16777216 true false 105 0 195 15
Rectangle -16777216 true false 105 15 120 75
Rectangle -16777216 true false 180 15 195 75

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

maleshetz
false
0
Circle -13791810 true false 110 5 80
Polygon -955883 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -13791810 true false 127 79 172 94
Polygon -13791810 true false 195 90 240 150 225 180 165 105
Polygon -13791810 true false 105 90 60 150 75 180 135 105

maleshmzdom
false
0
Circle -13791810 true false 110 5 80
Polygon -8630108 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -13791810 true false 127 79 172 94
Polygon -13791810 true false 195 90 240 150 225 180 165 105
Polygon -13791810 true false 105 90 60 150 75 180 135 105

maleshmzrec
false
0
Circle -13791810 true false 110 5 80
Polygon -1 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -13791810 true false 127 79 172 94
Polygon -13791810 true false 195 90 240 150 225 180 165 105
Polygon -13791810 true false 105 90 60 150 75 180 135 105

mosquitos
true
0
Polygon -2674135 true false 139 148 100 105 55 90 25 90 10 105 10 135 45 150 90 165 139 163
Polygon -2674135 true false 162 150 200 105 245 90 275 90 290 105 290 135 270 150 255 150 225 165 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 105 60
Polygon -1184463 true false 135 90 150 45 165 90
Circle -2674135 true false 120 90 30
Circle -2674135 true false 150 90 30
Line -16777216 false 135 90 150 105
Line -16777216 false 150 105 195 60

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

trees
false
0
Circle -13840069 true false 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -13840069 true false 65 21 108
Circle -13840069 true false 131 86 127
Circle -13840069 true false 45 90 120

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
