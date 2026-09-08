# Sloping Well Simulation Results

This folder contains the MATLAB simulation results for the **sloping quantum-well potential** used in the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

The sloping-well configuration represents a quantum confinement potential whose energy varies continuously across the well region.

The MATLAB implementation generates the sloping potential profile and solves the one-dimensional time-independent Schrödinger equation using the **finite-difference method (FDM)**.

## Results Included

The following results are provided in this folder:

- `sloping_well_potential.png` – Sloping potential-energy profile.
- `sloping_well_energy_levels.png` – Calculated bound-state energy levels.
- `sloping_well_wavefunctions.png` – Calculated wavefunctions and probability-density distributions.

## Simulation Characteristics

The potential energy varies approximately linearly across the confined region rather than remaining constant.

This produces an asymmetric confinement environment and changes the distribution of the allowed quantum states compared with a square-well potential.

## Numerical Method

The time-independent Schrödinger equation is discretised using the finite-difference method.

The resulting Hamiltonian matrix is constructed from the kinetic-energy and potential-energy terms and diagonalised to obtain the energy eigenvalues and corresponding eigenvectors.

The calculated wavefunctions are normalised and used to determine the probability-density distributions.

## Interpretation

The spatial variation of the potential modifies the energy spectrum and the spatial distribution of the quantum states.

The resulting wavefunctions demonstrate how a non-uniform confinement potential affects the localisation of quantum states.

## Software

- MATLAB
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
