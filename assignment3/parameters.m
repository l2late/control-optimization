E1 = (0+4)/2;
E2 = (4+4)/2;
E3 = (0+9)/2;

plotResult = true;

N       = 4;    % number of segments
tau     = 10;   % s
T       = tau;
muu     = 80/(3600*T);   % km^2/h
Cr      = 2000; % veh/(10s)
rhom    = 120;  % veh/(km*lane)
alph    = 0.1;
K       = 10;
a       = 2;
vf      = 110;  % km/h
rhoc    = 28;   % veh/(km*lane)
L       = 1;    % km
lambda  = 4;
Dr      = 1500; %veh/(10s)

VSL0    = 120;

Tend    = 60*10;
kmax = Tend / T + 1;
x0 = [ones(4,1)*20;ones(4,1)*90;0];

q0 = [ones(1,12)*(7000+100*E1),ones(1,kmax-12)*(2000+100*E2)];
