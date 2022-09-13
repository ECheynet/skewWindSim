# skewWindSim
The present repository includes the Matlab source code used to generate skewed turbulence for wind loading on structures, as presented in  [1].

## Content

The repository contains:

-    A Matlab livescript Documentation.mlx showing the case of a Diamond geometry

-    The Matlab function windSim4D.m, which generate the wind field on a 4D grid (3 spatial dimensions, one temporal one)

-    The functions getTargetSpectra.m, which computes the 1-point auto and cross-spectral densities used as input

-    The function getSamplingPara.m that provides the time and frequency vector for the initialisation of the simulation

-   The function WindToBridgeBase, which projects the horizontal wind field (u,v) onto the structural elements. This leads to a wind field (vx0,vy0). The name of the function "WindToBridgeBase" comes from the fact that it was first applied for the case of a horizontal bridge deck.

 -   The function frictionVelocity, which estimate the friction velocity from the simulated velocity histories.
 
 -   The function plotSPectra, which compares the target and simulated velocity spectra.
 
 -  The function coherence, which provides the co-coherence and quad-coherence estimates.
 
 -   The functions plotCoh_diamond and plotQuadCoh_diamond, which are used in the tutorial only and compare the target and estimated co-coherence and quad-coherence, respectively

This is the first version of the submission. Some bugs may still be present. Any question or comment is welcome

## References

[1] Cheynet E, Daniottì N, Bogunović Jakobsen J, Snæbjörnsson J and Wang J. (2022) Unfrozen skewed turbulence for wind loading on structures. Accepted for publication in Applied Sciences
