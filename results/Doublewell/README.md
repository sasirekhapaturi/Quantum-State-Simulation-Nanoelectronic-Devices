# Double Well Simulation Results

This folder contains the MATLAB simulation results for the **double-well quantum potential** used in the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

The double-well configuration consists of two potential wells separated by a higher potential-energy region. This configuration provides a coupled confinement structure in which the quantum states are influenced by the interaction between the two wells.

The MATLAB implementation generates the double-well potential profile and solves the one-dimensional time-independent Schrödinger equation using the **finite-difference method (FDM)**.

## Results Included

The following results are provided in this folder:

- `double_well_potential.png` – Double-well potential-energy profile.
- `double_well_energy_levels.png` – Calculated bound-state energy levels.
- `double_well_wavefunctions.png` – Calculated wavefunctions and probability-density distributions.

## Simulation Characteristics

The double-well model contains two potential wells separated by a higher potential-energy region.

The simulation calculates the allowed bound-state energies and their corresponding spatial wavefunctions.

For the implemented double-well configuration, **nine bound states** were obtained. The calculated energy levels are:

- −374.61 eV
- −374.61 eV
- −300.00 eV
- −299.95 eV
- −183.19 eV
- −182.46 eV
- −76.813 eV
- −46.259 eV
- −13.697 eV

## Numerical Method

The time-independent Schrödinger equation is discretised using the finite-difference method.

A Hamiltonian matrix is constructed from the kinetic-energy and potential-energy terms. The Hamiltonian is then diagonalised to obtain the energy eigenvalues and corresponding eigenvectors.

The calculated wavefunctions are normalised and used to obtain the associated probability-density distributions.

## Interpretation

The double-well configuration produces closely spaced quantum states because of the coupled confinement regions.

In particular, the third and fourth states occur at approximately **−300.00 eV** and **−299.95 eV**, demonstrating a small energy separation between these states.

The corresponding wavefunctions and probability densities provide information about the spatial distribution of the calculated quantum states within the double-well potential.

## Software

- MATLAB
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
