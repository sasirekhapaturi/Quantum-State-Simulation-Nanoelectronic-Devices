# Truncated Parabolic Well Simulation Results

This folder contains the MATLAB simulation results for the **truncated parabolic quantum-well potential** used in the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

The truncated parabolic potential provides a smoothly varying confinement profile in which the potential energy changes approximately quadratically within the selected well region.

The MATLAB implementation generates the potential profile and solves the one-dimensional time-independent Schrödinger equation using the **finite-difference method (FDM)**.

## Results Included

The following results are provided in this folder:

- `truncated_parabolic_well_potential.png` – Truncated parabolic potential-energy profile.
- `truncated_parabolic_well_energy_levels.png` – Calculated bound-state energy levels.
- `truncated_parabolic_well_wavefunctions.png` – Calculated wavefunctions and probability-density distributions.

## Simulation Characteristics

The potential varies smoothly across the confinement region and is truncated outside the defined well.

This produces a spatially varying confinement environment in which the energy eigenvalues and wavefunctions depend on the shape of the parabolic profile.

## Numerical Method

The time-independent Schrödinger equation is discretised using the finite-difference method.

A Hamiltonian matrix is formed using the kinetic-energy and potential-energy contributions. Numerical diagonalisation provides the allowed energy eigenvalues and corresponding eigenfunctions.

The wavefunctions are subsequently normalised and used to calculate the probability-density distributions.

## Interpretation

The smoothly varying potential produces quantum states that differ from those obtained from a constant square-well potential.

The probability-density distributions provide a visual representation of where the calculated quantum states are spatially concentrated within the potential.

## Software

- MATLAB
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
