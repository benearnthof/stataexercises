***********************************************************************.
* PATCHFILE FOR ALLBUScompact 2016.
* FOR USE WITH RELEASE  1.1.0.
* This patch changes the variable names of ALLBUScompact 2016 to the
* names used in ALLBUS Cumulation 1980-2016.
***********************************************************************.

cd "<ENTER DATA LOCATION HERE>"
use "ZA5251_v1-1-0.dta", clear

rename isced97 iscd975
rename dp02 dp03
rename fde23 fde01
rename fisced97 fiscd975
rename isced11 iscd11
rename mde23 mde01
rename misced97 miscd975
rename pdn03a pdn01
rename pisced11 piscd11
rename pisced97 piscd975
rename scdn03a scdn01
rename sciscd97 sciscd975

save "ZA5251_v1-1-0_patched.dta"