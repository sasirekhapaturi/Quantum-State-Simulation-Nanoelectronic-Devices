# Lattice Potential Simulation Results

This folder contains the MATLAB simulation results for the **lattice quantum potential** used in the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

The lattice configuration consists of a repeated sequence of potential wells, creating a periodic confinement structure.

The MATLAB implementation generates the lattice potential and solves the one-dimensional time-independent Schrödinger equation using the **finite-difference method (FDM)**.

## Results Included

The following results are provided in this folder:

- `lattice_potential.png` – Periodic lattice potential-energy profile.
- `lattice_energy_levels.png` – Calculated bound-state energy levels.
- `lattice_wavefunctions.png` – Calculated wavefunctions and probability-density distributions.

## Simulation Characteristics

The potential contains multiple repeated wells across the spatial domain.

The periodic structure provides a more complex confinement environment than a single isolated quantum well and allows the numerical solver to calculate the corresponding quantum states.

## Numerical Method

The time-independent Schrödinger equation is discretised using the finite-difference method.

A Hamiltonian matrix is assembled from the kinetic-energy and periodic potential-energy terms and then diagonalised to obtain the energy eigenvalues and eigenvectors.

The wavefunctions are normalised and the associated probability densities are calculated.

## Interpretation

The lattice potential produces a more complex energy spectrum due to the repeated confinement regions.

The calculated wavefunctions and probability densities demonstrate how quantum states respond to a spatially repeated potential environment.

## Software

- MATLAB
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
