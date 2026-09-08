# MATLAB GUI Simulation Results

This folder contains the graphical user interface (GUI) developed for the project:

**The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies**

## Overview

A MATLAB-based graphical user interface was developed to provide an interactive environment for the simulation and visualisation of quantum states in one-dimensional potential-well systems.

The GUI integrates the numerical simulation routines into a single interface, allowing potential configurations to be selected and the corresponding quantum-state results to be visualised.

## GUI Implementation

The GUI is implemented using MATLAB and is provided in the following source file:

- `QUANTDEVICE_GUI_Implementation.m` – Main MATLAB GUI implementation for the quantum-state simulation.

## Main Functions

The GUI provides an interactive interface for:

- Selecting different potential-well configurations.
- Generating and displaying the corresponding potential-energy profile.
- Calculating the quantum energy eigenvalues.
- Displaying the calculated energy states.
- Visualising wavefunctions.
- Visualising probability-density distributions.
- Presenting simulation results within the graphical interface.

## Numerical Method

The GUI uses the numerical solver developed for the project.

The one-dimensional time-independent Schrödinger equation is discretised using the **finite-difference method (FDM)**. The resulting Hamiltonian matrix is diagonalised to obtain the energy eigenvalues and corresponding eigenfunctions.

The calculated wavefunctions are normalised and used to generate probability-density distributions.

## GUI Results

The images in this folder provide representative screenshots of the developed MATLAB GUI and its visualisation of the simulated quantum states.

These screenshots demonstrate the integration of the numerical solver with the graphical interface.

## Files

- `quantum_simulator_gui.png` – Screenshot of the completed MATLAB GUI.
- Additional GUI result images may be included to demonstrate different potential configurations and simulation outputs.

## Software

- MATLAB
- MATLAB App Designer / MATLAB GUI
- Finite-Difference Method (FDM)

## Project

**Project Title:** The Simulation of Quantum States in Nanoelectronic Devices for Quantum Technologies

**Author:** Sasirekha Paturi

**Institution:** Liverpool John Moores University

**Programme:** MSc Embedded Systems and IC Design
