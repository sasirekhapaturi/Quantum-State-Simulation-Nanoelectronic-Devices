%% 
classdef QUANTDEVICE_GUI_Implementation < matlab.apps.AppBase
    % QUANTDEVICE
    % Quantum State Simulator for Nanoelectronic Devices
    %
    % Single-file MATLAB App Designer style implementation.
    % The numerical solver uses the finite-difference method (FDM) to
    % discretise the 1-D time-independent Schrodinger equation.

    properties (Access = public)
        UIFigure
        INPUTPARAMETERSPanel
        WellTypeDropDown
        WellTypeDropDownLabel
        WellWidthLnmEditField
        WellWidthLnmEditFieldLabel
        BarrierHeightVoeVEditField
        BarrierHeightVoeVEditFieldLabel
        EffectiveMassmEditField
        EffectiveMassmEditFieldLabel
        GridPointsNEditField
        GridPointsNEditFieldLabel
        NumberofStatesEditField
        NumberofStatesEditFieldLabel
        xrangenmEditField
        xrangenmEditFieldLabel
        toEditField
        toEditFieldLabel
        SOLVESYSTEMButton
        RESETButton
        EXPORTRESULTSButton

        SIMULATIONSTATUSPanel
        Lamp
        StatusMessageLabel
        ComputationTimeLabel
        TotalEigenvaluesLabel
        MethodLabel
        DateTimeLabel
        ComputationValueLabel
        EigenvalueCountValueLabel
        MethodValueLabel
        DateTimeValueLabel

        POTENTIALPROFILEVkPanel
        UIAxes
        WAVEFUNCTIONSPanel
        UIAxes2
        PROBABILITYDENSITYPanel
        UIAxes3
        ENERGYEIGENVALUESPanel
        UIAxes5
        ENERGYLEVELDIAGRAMPanel
        UIAxes6
        SELECTWELLTYPEPanel
        UIAxes4
        UIAxes4_2
        UIAxes4_3
        UIAxes4_4

        QUANTUMSTATESIMULATORFORNANOELECTRONICDEVICESLabel
    end

    properties (Access = private)
        x
        U
        E
        psi
        prob
        selectedState = 1
        lastResults
    end

    methods (Access = private)

        function solveSystem(app, ~, ~)
            try
                app.Lamp.Color = [0.93 0.68 0.05];
                app.StatusMessageLabel.Text = 'Solving system...';
                drawnow;

                % Read and validate GUI inputs
                wellType = app.WellTypeDropDown.Value;
                L = app.WellWidthLnmEditField.Value;
                Vo = app.BarrierHeightVoeVEditField.Value;
                massRatio = app.EffectiveMassmEditField.Value;
                N = round(app.GridPointsNEditField.Value);
                nRequested = round(app.NumberofStatesEditField.Value);
                xMin = app.xrangenmEditField.Value;
                xMax = app.toEditField.Value;

                if L <= 0
                    error('Well width must be greater than zero.');
                end
                if Vo <= 0
                    error('Barrier height must be greater than zero.');
                end
                if massRatio <= 0
                    error('Effective mass must be greater than zero.');
                end
                if N < 101 || mod(N,2) == 0
                    error('Grid Points N must be an odd integer of at least 101.');
                end
                if nRequested < 1
                    error('Number of States must be at least 1.');
                end
                if xMax <= xMin
                    error('The upper x-range must be greater than the lower x-range.');
                end

                % Physical constants
                hbar = 1.054571817e-34;       % J.s
                q = 1.602176634e-19;          % J/eV
                me = 9.1093837015e-31;        % kg
                m = massRatio * me;

                % Create spatial grid
                x = linspace(xMin, xMax, N).';
                dx = x(2) - x(1);

                % Generate selected potential
                U = app.makePotential(wellType, x, L, Vo);

                % Finite-difference Hamiltonian
                xi = x(2:end-1);
                nInterior = N - 2;

                % Second derivative:
                % d2psi/dx2 = (psi(i+1)-2psi(i)+psi(i-1))/dx^2
                D2 = spdiags( ...
                    [ones(nInterior,1), -2*ones(nInterior,1), ones(nInterior,1)], ...
                    -1:1, nInterior, nInterior) / dx^2;

                % Kinetic-energy operator. x is in nm, so convert dx to m.
                dx_m = dx * 1e-9;
                D2_m = spdiags( ...
                    [ones(nInterior,1), -2*ones(nInterior,1), ones(nInterior,1)], ...
                    -1:1, nInterior, nInterior) / dx_m^2;

                T = -(hbar^2/(2*m)) * D2_m / q; % eV
                V = spdiags(U(2:end-1), 0, nInterior, nInterior);
                H = T + V;

                % Solve for the lowest requested eigenstates.
                nSolve = min(nRequested, nInterior - 2);
                %opts.issym = true;
                opts.isreal = true;
                opts.tol = 1e-10;
                opts.maxit = 2000;

                tStart = tic;
                if nSolve < nInterior - 2
                    [Vects, D] = eigs(H, nSolve, 'smallestreal', opts);
                    E = real(diag(D));
                else
                    [Vects, D] = eig(full(H));
                    E = real(diag(D));
                    [E, order] = sort(E, 'ascend');
                    Vects = Vects(:, order);
                    Vects = Vects(:, 1:nSolve);
                end
                elapsed = toc(tStart);

                [E, order] = sort(E, 'ascend');
                Vects = Vects(:, order);

                % Add zero boundary values and normalise each state.
                psi = zeros(N, nSolve);
                prob = zeros(N, nSolve);

                for k = 1:nSolve
                    psi(:,k) = [0; real(Vects(:,k)); 0];

                    normVal = sqrt(trapz(x, abs(psi(:,k)).^2));
                    if normVal > 0
                        psi(:,k) = psi(:,k) / normVal;
                    end

                    % Make the first non-negligible point positive for
                    % consistent visual orientation.
                    idx = find(abs(psi(:,k)) > max(abs(psi(:,k))) * 1e-4, 1, 'first');
                    if ~isempty(idx) && psi(idx,k) < 0
                        psi(:,k) = -psi(:,k);
                    end

                    prob(:,k) = abs(psi(:,k)).^2;
                end

                % Store results
                app.x = x;
                app.U = U;
                app.E = E;
                app.psi = psi;
                app.prob = prob;
                app.selectedState = 1;

                app.lastResults = struct( ...
                    'WellType', wellType, ...
                    'WellWidth_nm', L, ...
                    'BarrierHeight_eV', Vo, ...
                    'EffectiveMass', massRatio, ...
                    'GridPoints', N, ...
                    'NumberOfStates', nSolve, ...
                    'xMin_nm', xMin, ...
                    'xMax_nm', xMax, ...
                    'Energy_eV', E, ...
                    'ComputationTime_s', elapsed);

                % Update all plots
                app.updatePlots();

                app.Lamp.Color = [0.20 0.85 0.20];
                app.StatusMessageLabel.Text = 'Simulation completed';
                app.ComputationValueLabel.Text = sprintf('%.4f s', elapsed);
                app.EigenvalueCountValueLabel.Text = sprintf('%d', nSolve);
                app.MethodValueLabel.Text = 'Finite Difference';
                app.DateTimeValueLabel.Text = datestr(now, 'dd mmm yyyy HH:MM:SS');

            catch ME
                app.Lamp.Color = [0.90 0.15 0.15];
                app.StatusMessageLabel.Text = 'Simulation error';
                uialert(app.UIFigure, ME.message, 'Simulation Error');
            end
        end

        function U = makePotential(app, wellType, x, L, Vo) %#ok<INUSD>
            % Potential is referenced to 0 eV outside the well.
            U = zeros(size(x));
            halfL = L/2;

            switch wellType
                case 'Square Quantum Well'
                    U(abs(x) <= halfL) = -Vo;

                case 'Double Quantum Well'
                    % Two wells separated by a central barrier.
                    w = L/3;
                    separation = L/5;
                    c = w/2 + separation/2;
                    U(abs(x-c) <= w/2) = -Vo;
                    U(abs(x+c) <= w/2) = -Vo;
                  case 'Stepped Quantum Well'
                    % Stepped quantum well.
                    % Left half has a deeper potential (-Vo).
                    % Right half has a shallower potential (-Vo/2).
                
                    inside = abs(x) <= halfL;
                
                    % Left side of the well
                    leftSide = inside & (x <= 0);
                    U(leftSide) = -Vo;
                
                    % Right side of the well
                    rightSide = inside & (x > 0);
                    U(rightSide) = -Vo/2;

                case 'Sloping Quantum Well'
                    inside = abs(x) <= halfL;
                    U(inside) = -Vo + Vo*(x(inside)+halfL)/L;

                case 'Truncated Parabolic Well'
                    inside = abs(x) <= halfL;
                    U(inside) = -Vo .* (1 - (x(inside)/halfL).^2);

                case 'Morse Potential'
                    % Morse-type finite potential, minimum = -Vo.
                    a = max(L/2, eps);
                    x0 = 0;
                    z = exp(-(x-x0)/a);
                    U = Vo .* (z.^2 - 2*z);
                    U(U > 0) = 0;

                case 'Lattice Structure'
                    % Periodic array of finite square wells.
                    numberOfWells = 8;
                    totalWidth = min(0.75*(max(x)-min(x)), max(L,eps)*4);
                    spacing = totalWidth / numberOfWells;
                    wellWidth = 0.45 * spacing;
                    startX = -totalWidth/2 + spacing/2;
                    centers = startX + (0:numberOfWells-1)*spacing;

                    for c = centers
                        U(abs(x-c) <= wellWidth/2) = -Vo;
                    end

                otherwise
                    error('Unknown potential well type.');
            end
        end

        function updatePlots(app)
            if isempty(app.x) || isempty(app.E)
                return
            end

            x = app.x;
            U = app.U;
            E = app.E;
            psi = app.psi;
            prob = app.prob;

            nStates = length(E);
            xRange = [min(x) max(x)];

            % 1. Potential profile
            cla(app.UIAxes);
            plot(app.UIAxes, x, U, 'LineWidth', 2);
            grid(app.UIAxes, 'on');
            xlabel(app.UIAxes, 'Position x (nm)');
            ylabel(app.UIAxes, 'Potential U (eV)');
            title(app.UIAxes, 'Potential Energy Profile');
            xlim(app.UIAxes, xRange);

            % 2. Wavefunctions, vertically offset by their energies
            cla(app.UIAxes2);
            hold(app.UIAxes2, 'on');
            scale = 0.12 * max(max(E)-min(E), 0.05);
            if scale <= 0
                scale = 0.1;
            end

            for k = 1:nStates
                p = psi(:,k);
                pmax = max(abs(p));
                if pmax > 0
                    p = p / pmax * scale;
                end
                plot(app.UIAxes2, x, E(k) + p, 'LineWidth', 1.2);
                yline(app.UIAxes2, E(k), '--');
            end
            hold(app.UIAxes2, 'off');
            grid(app.UIAxes2, 'on');
            xlabel(app.UIAxes2, 'Position x (nm)');
            ylabel(app.UIAxes2, 'Energy / \psi');
            title(app.UIAxes2, 'Wavefunctions');
            xlim(app.UIAxes2, xRange);

            % 3. Probability density for first state
            state = min(max(1, app.selectedState), nStates);
            cla(app.UIAxes3);
            plot(app.UIAxes3, x, prob(:,state), 'LineWidth', 2);
            grid(app.UIAxes3, 'on');
            xlabel(app.UIAxes3, 'Position x (nm)');
            ylabel(app.UIAxes3, 'Probability density |\psi|^2');
            title(app.UIAxes3, sprintf('Probability Density - State n = %d', state));
            xlim(app.UIAxes3, xRange);

            % 4. Eigenvalue table-like plot
            cla(app.UIAxes5);
            axis(app.UIAxes5, 'off');
            title(app.UIAxes5, 'Energy Eigenvalues (eV)');
            for k = 1:nStates
                text(app.UIAxes5, 0.12, 1 - (k-0.5)/nStates, ...
                    sprintf('State %d      E_%d = %.6f eV', k, k, E(k)), ...
                    'FontSize', 11);
            end

            % 5. Energy-level diagram
            cla(app.UIAxes6);
            hold(app.UIAxes6, 'on');
            for k = 1:nStates
                plot(app.UIAxes6, [xRange(1) xRange(2)], [E(k) E(k)], ...
                    'LineWidth', 2);
                text(app.UIAxes6, xRange(1), E(k), ...
                    sprintf('  n=%d', k), 'VerticalAlignment', 'bottom');
            end
            plot(app.UIAxes6, x, U, 'LineWidth', 1);
            hold(app.UIAxes6, 'off');
            grid(app.UIAxes6, 'on');
            xlabel(app.UIAxes6, 'Position x (nm)');
            ylabel(app.UIAxes6, 'Energy (eV)');
            title(app.UIAxes6, 'Energy Level Diagram');
            xlim(app.UIAxes6, xRange);

            % 6. Four well previews at the bottom
            previewAxes = {app.UIAxes4, app.UIAxes4_2, app.UIAxes4_3, app.UIAxes4_4};
            previewTypes = {...
                            'Square Quantum Well', ...
                            'Double Quantum Well', ...
                            'Stepped Quantum Well', ...
                            'Morse Potential'};

            for k = 1:4
                ax = previewAxes{k};
                cla(ax);
                Upreview = app.makePotential(previewTypes{k}, x, ...
                    app.WellWidthLnmEditField.Value, ...
                    app.BarrierHeightVoeVEditField.Value);
                plot(ax, x, Upreview, 'LineWidth', 1.5);
                grid(ax, 'on');
                title(ax, previewTypes{k}, 'FontSize', 9);
                xlabel(ax, 'x (nm)');
                ylabel(ax, 'U (eV)');
                xlim(ax, xRange);
            end
        end

        function resetApp(app, ~, ~)
            app.WellTypeDropDown.Value = 'Square Quantum Well';
            app.WellWidthLnmEditField.Value = 10;
            app.BarrierHeightVoeVEditField.Value = 0.3;
            app.EffectiveMassmEditField.Value = 0.3;
            app.GridPointsNEditField.Value = 801;
            app.NumberofStatesEditField.Value = 5;
            app.xrangenmEditField.Value = -20;
            app.toEditField.Value = 20;

            app.x = [];
            app.U = [];
            app.E = [];
            app.psi = [];
            app.prob = [];
            app.lastResults = [];

            cla(app.UIAxes);
            cla(app.UIAxes2);
            cla(app.UIAxes3);
            cla(app.UIAxes5);
            cla(app.UIAxes6);

            app.StatusMessageLabel.Text = 'Ready to simulate';
            app.Lamp.Color = [0.20 0.85 0.20];
            app.ComputationValueLabel.Text = '--';
            app.EigenvalueCountValueLabel.Text = '--';
            app.MethodValueLabel.Text = 'Finite Difference';
            app.DateTimeValueLabel.Text = '--';

            % Show previews even before solving
            app.drawPreviews();
        end

        function drawPreviews(app)
            x = linspace(app.xrangenmEditField.Value, ...
                         app.toEditField.Value, ...
                         max(101, round(app.GridPointsNEditField.Value)));

            previewAxes = {app.UIAxes4, app.UIAxes4_2, app.UIAxes4_3, app.UIAxes4_4};
            previewTypes = { 'Square Quantum Well', ...
                                    'Double Quantum Well', ...
                                    'Stepped Quantum Well', ...
                                    'Morse Potential'};

            for k = 1:4
                ax = previewAxes{k};
                cla(ax);
                Upreview = app.makePotential(previewTypes{k}, x, ...
                    app.WellWidthLnmEditField.Value, ...
                    app.BarrierHeightVoeVEditField.Value);
                plot(ax, x, Upreview, 'LineWidth', 1.5);
                grid(ax, 'on');
                title(ax, previewTypes{k}, 'FontSize', 9);
                xlabel(ax, 'x (nm)');
                ylabel(ax, 'U (eV)');
            end
        end

        function exportResults(app, ~, ~)
            if isempty(app.lastResults)
                uialert(app.UIFigure, ...
                    'Please solve the system before exporting results.', ...
                    'No Results');
                return
            end

            [file, path] = uiputfile({'*.mat','MATLAB data (*.mat)'; ...
                                      '*.csv','Energy CSV (*.csv)'}, ...
                                      'Export Simulation Results');

            if isequal(file,0)
                return
            end

            fullName = fullfile(path,file);

            [~,~,ext] = fileparts(fullName);

            if strcmpi(ext,'.csv')
                T = table((1:length(app.E)).', app.E, ...
                    'VariableNames', {'QuantumState','Energy_eV'});
                writetable(T, fullName);
            else
                results = app.lastResults;
                results.x_nm = app.x;
                results.potential_eV = app.U;
                results.wavefunctions = app.psi;
                results.probabilityDensity = app.prob;
                save(fullName, 'results');
            end

            uialert(app.UIFigure, ...
                sprintf('Results exported successfully to:\n%s', fullName), ...
                'Export Complete');
        end

        function wellTypeChanged(app, ~, ~)
            app.drawPreviews();
        end

        function createComponents(app)
            % Main window
            app.UIFigure = uifigure('Visible','off');
            app.UIFigure.Position = [100 100 1250 760];
            app.UIFigure.Name = 'Quantum State Simulator for Nanoelectronic Devices';

            % Main title
            app.QUANTUMSTATESIMULATORFORNANOELECTRONICDEVICESLabel = ...
                uilabel(app.UIFigure);
            app.QUANTUMSTATESIMULATORFORNANOELECTRONICDEVICESLabel.FontSize = 19;
            app.QUANTUMSTATESIMULATORFORNANOELECTRONICDEVICESLabel.FontWeight = 'bold';
            app.QUANTUMSTATESIMULATORFORNANOELECTRONICDEVICESLabel.HorizontalAlignment = 'center';
            app.QUANTUMSTATESIMULATORFORNANOELECTRONICDEVICESLabel.Position = [300 715 900 30];
            app.QUANTUMSTATESIMULATORFORNANOELECTRONICDEVICESLabel.Text = ...
                'QUANTUM STATE SIMULATOR FOR NANOELECTRONIC DEVICES';

            % Input panel
            app.INPUTPARAMETERSPanel = uipanel(app.UIFigure);
            app.INPUTPARAMETERSPanel.Title = 'INPUT PARAMETERS';
            app.INPUTPARAMETERSPanel.FontWeight = 'bold';
            app.INPUTPARAMETERSPanel.Position = [30 365 280 330];

            app.WellTypeDropDownLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.WellTypeDropDownLabel.Position = [12 280 70 22];
            app.WellTypeDropDownLabel.Text = 'Well Type';

            app.WellTypeDropDown = uidropdown(app.INPUTPARAMETERSPanel);
            app.WellTypeDropDown.Items = {'Square Quantum Well', ...
                'Double Quantum Well', 'Stepped Quantum Well', 'Sloping Quantum Well', ...
                'Truncated Parabolic Well', 'Morse Potential', ...
                'Lattice Structure'};
            app.WellTypeDropDown.Value = 'Square Quantum Well';
            app.WellTypeDropDown.Position = [92 280 170 22];
            app.WellTypeDropDown.ValueChangedFcn = @app.wellTypeChanged;

            app.WellWidthLnmEditFieldLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.WellWidthLnmEditFieldLabel.Position = [12 245 120 22];
            app.WellWidthLnmEditFieldLabel.Text = 'Well Width L (nm)';

            app.WellWidthLnmEditField = uieditfield(app.INPUTPARAMETERSPanel,'numeric');
            app.WellWidthLnmEditField.Position = [155 245 107 22];
            app.WellWidthLnmEditField.Value = 10;

            app.BarrierHeightVoeVEditFieldLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.BarrierHeightVoeVEditFieldLabel.Position = [12 210 135 22];
            app.BarrierHeightVoeVEditFieldLabel.Text = 'Barrier Height Vo (eV)';

            app.BarrierHeightVoeVEditField = uieditfield(app.INPUTPARAMETERSPanel,'numeric');
            app.BarrierHeightVoeVEditField.Position = [155 210 107 22];
            app.BarrierHeightVoeVEditField.Value = 0.3;

            app.EffectiveMassmEditFieldLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.EffectiveMassmEditFieldLabel.Position = [12 175 125 22];
            app.EffectiveMassmEditFieldLabel.Text = 'Effective Mass m/me';

            app.EffectiveMassmEditField = uieditfield(app.INPUTPARAMETERSPanel,'numeric');
            app.EffectiveMassmEditField.Position = [155 175 107 22];
            app.EffectiveMassmEditField.Value = 0.3;

            app.GridPointsNEditFieldLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.GridPointsNEditFieldLabel.Position = [12 140 125 22];
            app.GridPointsNEditFieldLabel.Text = 'Grid Points N';

            app.GridPointsNEditField = uieditfield(app.INPUTPARAMETERSPanel,'numeric');
            app.GridPointsNEditField.Position = [155 140 107 22];
            app.GridPointsNEditField.Value = 801;

            app.NumberofStatesEditFieldLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.NumberofStatesEditFieldLabel.Position = [12 105 125 22];
            app.NumberofStatesEditFieldLabel.Text = 'Number of States';

            app.NumberofStatesEditField = uieditfield(app.INPUTPARAMETERSPanel,'numeric');
            app.NumberofStatesEditField.Position = [155 105 107 22];
            app.NumberofStatesEditField.Value = 5;

            app.xrangenmEditFieldLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.xrangenmEditFieldLabel.Position = [12 70 65 22];
            app.xrangenmEditFieldLabel.Text = 'x range (nm)';

            app.xrangenmEditField = uieditfield(app.INPUTPARAMETERSPanel,'numeric');
            app.xrangenmEditField.Position = [92 70 60 22];
            app.xrangenmEditField.Value = -20;

            app.toEditFieldLabel = uilabel(app.INPUTPARAMETERSPanel);
            app.toEditFieldLabel.Position = [160 70 25 22];
            app.toEditFieldLabel.Text = 'to';

            app.toEditField = uieditfield(app.INPUTPARAMETERSPanel,'numeric');
            app.toEditField.Position = [190 70 72 22];
            app.toEditField.Value = 20;

            app.SOLVESYSTEMButton = uibutton(app.INPUTPARAMETERSPanel,'push');
            app.SOLVESYSTEMButton.Position = [12 38 250 24];
            app.SOLVESYSTEMButton.FontWeight = 'bold';
            app.SOLVESYSTEMButton.Text = 'SOLVE SYSTEM';
            app.SOLVESYSTEMButton.ButtonPushedFcn = @app.solveSystem;

            app.RESETButton = uibutton(app.INPUTPARAMETERSPanel,'push');
            app.RESETButton.Position = [12 7 120 24];
            app.RESETButton.FontWeight = 'bold';
            app.RESETButton.Text = 'RESET';
            app.RESETButton.ButtonPushedFcn = @app.resetApp;

            app.EXPORTRESULTSButton = uibutton(app.INPUTPARAMETERSPanel,'push');
            app.EXPORTRESULTSButton.Position = [142 7 120 24];
            app.EXPORTRESULTSButton.FontWeight = 'bold';
            app.EXPORTRESULTSButton.Text = 'EXPORT';
            app.EXPORTRESULTSButton.ButtonPushedFcn = @app.exportResults;

            % Potential panel
            app.POTENTIALPROFILEVkPanel = uipanel(app.UIFigure);
            app.POTENTIALPROFILEVkPanel.Title = 'POTENTIAL PROFILE V(x)';
            app.POTENTIALPROFILEVkPanel.FontWeight = 'bold';
            app.POTENTIALPROFILEVkPanel.Position = [330 445 430 250];

            app.UIAxes = uiaxes(app.POTENTIALPROFILEVkPanel);
            app.UIAxes.Position = [15 15 400 205];
            title(app.UIAxes,'Potential Energy');
            xlabel(app.UIAxes,'x (nm)');
            ylabel(app.UIAxes,'U (eV)');

            % Wavefunction panel
            app.WAVEFUNCTIONSPanel = uipanel(app.UIFigure);
            app.WAVEFUNCTIONSPanel.Title = 'WAVEFUNCTIONS';
            app.WAVEFUNCTIONSPanel.FontWeight = 'bold';
            app.WAVEFUNCTIONSPanel.Position = [780 445 430 250];

            app.UIAxes2 = uiaxes(app.WAVEFUNCTIONSPanel);
            app.UIAxes2.Position = [15 15 400 205];
            title(app.UIAxes2,'Wavefunctions');
            xlabel(app.UIAxes2,'x (nm)');
            ylabel(app.UIAxes2,'Energy');

            % Status panel
            app.SIMULATIONSTATUSPanel = uipanel(app.UIFigure);
            app.SIMULATIONSTATUSPanel.Title = 'SIMULATION STATUS';
            app.SIMULATIONSTATUSPanel.FontWeight = 'bold';
            app.SIMULATIONSTATUSPanel.Position = [30 190 280 150];

            app.Lamp = uilamp(app.SIMULATIONSTATUSPanel);
            app.Lamp.Position = [12 104 18 18];
            app.Lamp.Color = [0.20 0.85 0.20];

            app.StatusMessageLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.StatusMessageLabel.Position = [40 104 220 18];
            app.StatusMessageLabel.Text = 'Ready to simulate';

            app.ComputationTimeLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.ComputationTimeLabel.Position = [12 78 120 18];
            app.ComputationTimeLabel.Text = 'Computation Time:';

            app.ComputationValueLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.ComputationValueLabel.Position = [145 78 110 18];
            app.ComputationValueLabel.Text = '--';

            app.TotalEigenvaluesLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.TotalEigenvaluesLabel.Position = [12 54 120 18];
            app.TotalEigenvaluesLabel.Text = 'Total Eigenvalues:';

            app.EigenvalueCountValueLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.EigenvalueCountValueLabel.Position = [145 54 110 18];
            app.EigenvalueCountValueLabel.Text = '--';

            app.MethodLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.MethodLabel.Position = [12 30 120 18];
            app.MethodLabel.Text = 'Method:';

            app.MethodValueLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.MethodValueLabel.Position = [145 30 110 18];
            app.MethodValueLabel.Text = 'Finite Difference';

            app.DateTimeLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.DateTimeLabel.Position = [12 7 120 18];
            app.DateTimeLabel.Text = 'Date & Time:';

            app.DateTimeValueLabel = uilabel(app.SIMULATIONSTATUSPanel);
            app.DateTimeValueLabel.Position = [100 7 160 18];
            app.DateTimeValueLabel.Text = '--';

            % Eigenvalue panel
            app.ENERGYEIGENVALUESPanel = uipanel(app.UIFigure);
            app.ENERGYEIGENVALUESPanel.Title = 'ENERGY EIGENVALUES';
            app.ENERGYEIGENVALUESPanel.FontWeight = 'bold';
            app.ENERGYEIGENVALUESPanel.Position = [330 190 205 235];

            app.UIAxes5 = uiaxes(app.ENERGYEIGENVALUESPanel);
            app.UIAxes5.Position = [5 5 195 205];
            app.UIAxes5.XLim = [0 1];
            app.UIAxes5.YLim = [0 1];

            % Energy diagram
            app.ENERGYLEVELDIAGRAMPanel = uipanel(app.UIFigure);
            app.ENERGYLEVELDIAGRAMPanel.Title = 'ENERGY LEVEL DIAGRAM';
            app.ENERGYLEVELDIAGRAMPanel.FontWeight = 'bold';
            app.ENERGYLEVELDIAGRAMPanel.Position = [550 190 210 235];

            app.UIAxes6 = uiaxes(app.ENERGYLEVELDIAGRAMPanel);
            app.UIAxes6.Position = [5 5 200 205];

            % Probability density
            app.PROBABILITYDENSITYPanel = uipanel(app.UIFigure);
            app.PROBABILITYDENSITYPanel.Title = 'PROBABILITY DENSITY';
            app.PROBABILITYDENSITYPanel.FontWeight = 'bold';
            app.PROBABILITYDENSITYPanel.Position = [780 190 430 235];

            app.UIAxes3 = uiaxes(app.PROBABILITYDENSITYPanel);
            app.UIAxes3.Position = [15 15 400 205];
            title(app.UIAxes3,'Probability Density');
            xlabel(app.UIAxes3,'x (nm)');
            ylabel(app.UIAxes3,'|\psi|^2');

            % Bottom well preview panel
            app.SELECTWELLTYPEPanel = uipanel(app.UIFigure);
            app.SELECTWELLTYPEPanel.Title = 'SELECT WELL TYPE';
            app.SELECTWELLTYPEPanel.FontWeight = 'bold';
            app.SELECTWELLTYPEPanel.Position = [30 20 1180 150];

            app.UIAxes4 = uiaxes(app.SELECTWELLTYPEPanel);
            app.UIAxes4.Position = [10 10 275 115];

            app.UIAxes4_2 = uiaxes(app.SELECTWELLTYPEPanel);
            app.UIAxes4_2.Position = [300 10 275 115];

            app.UIAxes4_3 = uiaxes(app.SELECTWELLTYPEPanel);
            app.UIAxes4_3.Position = [590 10 275 115];

            app.UIAxes4_4 = uiaxes(app.SELECTWELLTYPEPanel);
            app.UIAxes4_4.Position = [880 10 275 115];

            app.UIFigure.Visible = 'on';

            % Draw initial previews
            app.drawPreviews();
        end
    end

    methods (Access = public)
        function app = QUANTDEVICE_GUI_Implementation
            createComponents(app)
            registerApp(app, app.UIFigure)
            if nargout == 0
                clear app
            end
        end

        function delete(app)
            if isvalid(app.UIFigure)
                delete(app.UIFigure)
            end
        end
    end
end
