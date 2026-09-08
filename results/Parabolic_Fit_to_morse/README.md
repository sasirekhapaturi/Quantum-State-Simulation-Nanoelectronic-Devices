# Parabolic Fit to Morse Potential Simulation Results

This folder contains the MATLAB simulation results for the **parabolic fit to the Morse potential** used in the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

This configuration provides a parabolic approximation to the Morse potential. It is used to compare the quantum-state behaviour of a smoothly varying parabolic model with the corresponding Morse potential.

The MATLAB implementation generates the fitted potential profile and solves the one-dimensional time-independent Schrödinger equation using the **finite-difference method (FDM)**.

## Results Included

The following results are provided in this folder:

- `parabolic_fit_morse_potential.png` – Parabolic approximation to the Morse potential.
- `parabolic_fit_morse_energy_levels.png` – Calculated bound-state energy levels.
- `parabolic_fit_morse_wavefunctions.png` – Calculated wavefunctions and probability-density distributions.

## Simulation Characteristics

The potential is represented using a quadratic approximation derived from the Morse potential.

This allows the calculated energy spectrum and wavefunctions to be compared with those obtained from the original Morse potential.

## Numerical Method

The time-independent Schrödinger equation is discretised using the finite-difference method.

The resulting Hamiltonian matrix is diagonalised numerically to obtain the energy eigenvalues and corresponding eigenfunctions.

The calculated eigenfunctions are normalised and used to obtain the corresponding probability densities.

## Interpretation

The parabolic approximation provides a simplified representation of the Morse potential.

Comparison of the two configurations demonstrates how changes in the shape of the potential can influence the calculated quantum energy states and spatial probability distributions.

## Software

- MATLAB
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
