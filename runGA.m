% Number of variables (6 PID gains)
nvars = 6;

% Lower and upper bounds for gains
lb = [0 0 0 0 0 0];        % Minimum possible gains
ub = [50 50 50 50 50 50];  % Maximum possible gains

% GA options
options = optimoptions('ga', ...
    'Display', 'iter', ...          % Show progress in Command Window
    'PopulationSize', 20, ...       % Number of candidates per generation
    'MaxGenerations', 100, ...       % Total generations
    'UseParallel', false, ...       % Disable parallel processing
    'PlotFcn', {@gaplotbestf});     % Live convergence plot during GA

% Run GA
[x_opt, fval, exitflag, output, population, scores] = ...
    ga(@fitnessPID, nvars, [], [], [], [], lb, ub, [], options);

% Display optimized gains
fprintf('Optimized PID Gains:\n');
fprintf('Kp1 = %.2f, Ki1 = %.2f, Kd1 = %.2f\n', x_opt(1), x_opt(2), x_opt(3));
fprintf('Kp2 = %.2f, Ki2 = %.2f, Kd2 = %.2f\n', x_opt(4), x_opt(5), x_opt(6));

%% ---- Plot Best Cost vs Generation (AFTER GA completes) ----

% Extract best fitness per generation (from scores or output)
bestCosts = min(scores, [], 2);   % Take min cost of each generation

figure;
plot(bestCosts, 'LineWidth', 2);
xlabel('Generation');
ylabel('Best Cost f(x)');
title('GA Convergence: Best Cost per Generation');
grid on;