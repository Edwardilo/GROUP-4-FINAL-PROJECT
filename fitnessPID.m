function cost = fitnessPID(x)
% x = [Kp1 Ki1 Kd1 Kp2 Ki2 Kd2]

%% Assign GA values to base workspace (Simulink Constant Blocks)
assignin('base', 'Kp1', x(1));
assignin('base', 'Ki1', x(2));
assignin('base', 'Kd1', x(3));
assignin('base', 'Kp2', x(4));
assignin('base', 'Ki2', x(5));
assignin('base', 'Kd2', x(6));

%% Run Simulink Model
simOut = sim('PID_GA', 'ReturnWorkspaceOutputs', 'on');

%% Retrieve logged signals (error + torque)
theta1_error = simOut.logsout.getElement('Theta1_Error').Values.Data;
theta2_error = simOut.logsout.getElement('Theta2_Error').Values.Data;
torque1 = simOut.logsout.getElement('Torque_Theta1').Values.Data;
torque2 = simOut.logsout.getElement('Torque_Theta2').Values.Data;

%% Compute Integral of Absolute Error (IAE)
IAE1 = trapz(abs(theta1_error));
IAE2 = trapz(abs(theta2_error));

%% Compute Torque Penalty (optional scaling)
torquePenalty = trapz(abs(torque1)) + trapz(abs(torque2));

%% Final Cost (weighted sum of error + torque penalty)
cost = IAE1 + IAE2 + 0.01 * torquePenalty;  % Adjust 0.01 weight if needed
end