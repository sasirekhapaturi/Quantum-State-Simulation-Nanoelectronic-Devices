# Quantum-State-Simulation-Nanoelectronic-Devices
MATLAB-based simulation of quantum states in nanoelectronic devices using the finite-difference method.
# Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

This repository contains the MATLAB implementation developed for the MSc project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Project Overview

The project investigates the numerical simulation of quantum-confined states in one-dimensional potential-well systems. The time-independent Schrödinger equation is solved numerically using the finite-difference method (FDM).

The implementation calculates quantum energy eigenvalues and corresponding eigenfunctions for different potential-energy profiles.

## Potential-Well Profiles

The MATLAB simulation includes:

- Square well
- Stepped well
- Double well
- Sloping well
- Truncated parabolic well
- Morse potential
- Parabolic fit to Morse potential
- Lattice potential

## Main MATLAB Files

### se_wells.m
Generates the spatial grid and selected potential-energy profile.

### se_solve.m
Constructs the finite-difference Hamiltonian matrix and calculates eigenvalues and eigenvectors.

### se_psi.m
Displays the calculated wavefunctions, probability densities and energy states.

### se_orthonormal.m
Checks normalisation and orthogonality of calculated wavefunctions.

### simpson1d.m
Performs numerical integration using Simpson's 1/3 rule.

### se_infWell.m
Provides an analytical infinite-square-well comparison for validation.

### se_measurements.m
Calculates numerical quantum-state properties such as expectation values and uncertainties.

## Software

- MATLAB
- MATLAB App Designer / MATLAB GUI

## Numerical Method

The one-dimensional time-independent Schrödinger equation is discretised using the finite-difference method. The resulting Hamiltonian matrix is diagonalised to obtain the allowed energy states and corresponding wavefunctions.

## Project Author

Sasirekha Paturi

MSc Embedded Systems and IC Design

Liverpool John Moores University
