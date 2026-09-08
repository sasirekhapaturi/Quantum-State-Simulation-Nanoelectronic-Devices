# Stepped Well Simulation Results

This folder contains the MATLAB simulation results for the **stepped quantum-well potential** used in the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

The stepped-well configuration represents an asymmetric quantum confinement potential in which different regions of the well have different potential-energy values.

The MATLAB implementation generates the potential profile and solves the one-dimensional time-independent Schrödinger equation using the **finite-difference method (FDM)**.

## Results Included

The following results are provided in this folder:

- `stepped_well_potential.png` – Stepped potential-energy profile.
- `stepped_well_energy_levels.png` – Calculated bound-state energy levels.
- `stepped_well_wavefunctions.png` – Calculated wavefunctions and probability-density distributions.

## Simulation Characteristics

The stepped-well model contains regions with different potential-energy values, producing an asymmetric confinement environment.

The simulation calculates the allowed bound-state energies and the corresponding spatial wavefunctions for the selected potential.

## Numerical Method

The time-independent Schrödinger equation is discretised using the finite-difference method. The resulting Hamiltonian matrix is diagonalised to obtain the energy eigenvalues and eigenvectors.

The calculated eigenvectors are normalised and used to determine the corresponding probability-density distributions.

## Interpretation

The stepped potential produces a different energy spectrum and spatial distribution of quantum states compared with a simple square well.

The change in potential height across the well modifies the confinement conditions and therefore affects both the calculated energy levels and the spatial characteristics of the wavefunctions.

## Software

- MATLAB
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
