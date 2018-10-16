%% Assignment 2 Quadratic Programming
% Luca de Laat      - 4135040
% Nathan Timmers    - 4283449
clear all; close all; clc;
fprintf('Assignment 3 - Nonlinear Programming \n')
fprintf('Luca de Laat   - 4135040 \n')
fprintf('Nathan Timmers - 4283449 \n\n')

%% Initializing Constants
E1 = (0+4)/2;
E2 = (4+4)/2;
E3 = (0+9)/2;

plotResult = true;

N = 4;      % number of segments
tau = 10;   % s
mu = 80;    % km^2/h
Cr = 2000;  % veh/h
rhom = 120; % veh/(km*lane)
alpha = 0.1;
K = 10;
a = 2;
vf = 110;   % km/h
rhoc = 28;  % veh/(km*lane)

q0 = [7000 + 100*E1; 
      2000 + 100*E3];
%% Question 1 & 2
fprintf('Question 1 & 2: \n')


% fprintf('The values of the system parameters are: \n a1 = %d \n a2 = %d \n', a1, a2)
% fprintf('Yielding: \n A  =  %1.5f \n B  = [%d, %d] \n ck = %d * Tamb \n\n', A, B(1), B(2), ck)
% 
% clearvars -except E1 E2 E3 dt plotResult

%% Question 3
fprintf('Question 3: \n')

