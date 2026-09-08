# Morse Potential Simulation Results

This folder contains the MATLAB simulation results for the **Morse potential** used in the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

The Morse potential provides a non-parabolic and asymmetric potential profile for investigating quantum states under a more continuously varying confinement environment.

The MATLAB implementation generates the Morse potential and solves the one-dimensional time-independent Schrödinger equation using the **finite-difference method (FDM)**.

## Results Included

The following results are provided in this folder:

- `morse_well_potential.png` – Morse potential-energy profile.
- `morse_well_energy_levels.png` – Calculated bound-state energy levels.
- `morse_well_wavefunctions.png` – Calculated wavefunctions and probability-density distributions.

## Simulation Characteristics

The Morse potential is asymmetric and varies nonlinearly across the spatial domain.

This produces an energy spectrum and spatial wavefunctions that differ from those of symmetric square and parabolic confinement profiles.

## Numerical Method

The time-independent Schrödinger equation is discretised using the finite-difference method.

The Hamiltonian matrix is constructed using the kinetic-energy and Morse potential-energy terms. Numerical diagonalisation is then used to obtain the energy eigenvalues and corresponding eigenvectors.

The resulting wavefunctions are normalised and their probability densities are calculated.

## Interpretation

The Morse potential demonstrates the effect of a nonlinear and asymmetric confinement profile on the calculated quantum states.

The resulting energy spectrum and spatial probability distributions illustrate the sensitivity of quantum states to the shape of the potential landscape.

## Software

- MATLAB
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
