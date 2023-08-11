# Unfrozen skewed turbulence for wind loading on structures

[![View Unfrozen skewed turbulence for wind loading on structures  on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/117535-unfrozen-skewed-turbulence-for-wind-loading-on-structures)
[![DOI](https://zenodo.org/badge/332502776.svg)](https://zenodo.org/badge/latestdoi/332502776)
<a href="https://www.buymeacoffee.com/echeynet" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 25px !important;width: 120px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>


The present repository includes the Matlab source code used to generate skewed turbulence for wind loading on structures, as presented in  [1]. Topic of interests are: wind engineering, structural dynamics, random processes, structural analysis, boundary layer meteorology, atmospheric science (turbulence)

## Content

The repository contains:

-    A Matlab livescript **Documentation**.mlx showing the case of a Diamond geometry

-    A Matlab livescript **regular_grid**.mlx showing the case of a regulat grid and data are saved in a format similar to windSimFast

-    The Matlab function **windSim4D**, which generate the wind field on a 4D grid (3 spatial dimensions, one temporal one)

-    The functions **getTargetSpectra**, which computes the 1-point auto and cross-spectral densities used as input

-    The functions **getRegularGrid**, which setup the regular grid for the Example case 2.

-    The function **getSamplingPara** that provides the time and frequency vector for the initialisation of the simulation

-   The function **WindToBridgeBase**, which projects the horizontal wind field (u,v) onto the structural elements. This leads to a wind field (vx0,vy0). The name of the function "WindToBridgeBase" comes from the fact that it was first applied for the case of a horizontal bridge deck.

-   The function **PlotWindProjection**, which shows the wind speed components (u,v) and (ux0,vy0) in the wind-based coordinate system and the structure-based coorindate system

-   The function **frictionVelocity**, which estimate the friction velocity from the simulated velocity histories.
 
-   The function **plotSpectra**, which compares the target and simulated velocity spectra.
 
-  The function **coherence**, which provides the co-coherence and quad-coherence estimates.
 
-   The functions **plotCoh_diamond** and **plotQuadCoh_diamond**, which are used in the tutorial only and compare the target and estimated co-coherence and quad-coherence, respectively

-  The function ** nearestneighbour.m** [2]
This is the first version of the submission. Some bugs may still be present. Any question or comment is welcome

## References

[1] Cheynet E, Daniotti N, Bogunović Jakobsen J, Snæbjörnsson J, Wang J. Unfrozen Skewed Turbulence for Wind Loading on Structures. Applied Sciences. 2022; 12(19):9537. https://doi.org/10.3390/app12199537 
[2] Richard Brown (2023). nearestneighbour.m (https://www.mathworks.com/matlabcentral/fileexchange/12574-nearestneighbour-m), MATLAB Central File Exchange. Retrieved June 9, 2023. 
