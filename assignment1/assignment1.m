%Luca = 040
%Nathan = 449

clear all

E1 = 4;
E2 = 8;
E3 = 9;

bc = (5 + E1) * 10e6; %battery cells
bw = 6*10e3; %battery cells for W
br = 4*10e3; %battery cells for R
bv = 2*10e3; %battery cells for V
hrw = 15; %hours required for W
hrr = 10; %hours required for R
hrv = 8;  %hours required for V
nemp = 100 + E2; %number of employees
hpm = 160; %hours per month per employee
thpm = nemp * hpm; % total hours
ms = 3000 + 50*E3; %monthly salary
avs = (15 + E3) * 10e3; %available storage space
rssw = 12; % required storage space W
rssr = 10; % required storage space R
rssv = 8;  % required storage space V
pr = 55000; %price R
pw = 75000; %price W
pv = 45000; %price V
mcr = 30000; %manufacturing cost R
mcw = 45000; %manufacturing cost W
mcv = 15000; %manufacturing cost V


%% Part 2
c = [(mcr - pr), (mcw - pw)];

A =[br,     bw;
    rssr,   rssw;
    hrr,    hrw];

b = [bc, avs, thpm];

lb = [0 0]; %lower bound

ub = [inf inf]; %upper bound

options = optimoptions('linprog','Algorithm','dual-simplex');

[x1,~,exitflag,~,~] = linprog(c,A,b,[],[],lb,ub,options);
assert(exitflag == 1);
round(x1)
profit1 =-c*round(x1) - nemp*ms % Total profit
s = -(A*x1-b')
%% Part 3

ub = [1000 inf]; %upper bound

[x2,~,exitflag,~,~] = linprog(c,A,b,[],[],lb,ub,options);
assert(exitflag == 1);
round(x2)
profit2 =-c*round(x2)  - nemp*ms % Total profit

%% Part 3

bc = (8 + E1) * 10e6; %battery cells
avs = (22 + E3) * 10e3; %available storage space

c = [(mcr - pr), (mcw - pw)];

lb = [0 0]; %lower bound

ub = [1000 inf]; %upper bound
x_3 = 0:72;

for i = 1:length(x_3)
    
    whr = 5/60*x_3(i); % work time reduction per car
    
    A =[br,     bw;
        rssr,   rssw;
        hrr-whr,    hrw-whr];
    
    b = [bc, avs, thpm+160*x_3(i)];
    
    [x3(:,i),~,exitflag,~,~] = linprog(c,A,b,[],[],lb,ub,options);
    assert(exitflag == 1);
    round(x3(:,i));
    profit3(i) = -c*round(x3(:,i))-ms*x_3(i);
end

maxIndex = find(profit3 == max(profit3));
x3(:,maxIndex)
optWorkers = x_3(maxIndex)
maxProfit = profit3(maxIndex)  - nemp*ms % Total profit
% plot(x_3,profit3)

%% Part 4
whr = 5/60*optWorkers;

c4 = [(mcr - pr), (mcw - pw), (mcv - pv) ];

lb4 = [1250 1000 1500]; %lower bound

ub4 = [inf inf inf]; %upper bound

A4 = [br,        bw,         bv;
    rssr,      rssw,       rssv;
    hrr-whr,   hrw-whr,    hrv];

b4 = [bc, avs, thpm+160*optWorkers];

[x4,fval,exitflag,~,~] = linprog(c4,A4,b4,[],[],lb4,ub4,options);

if isempty(x4)
    msg = 'It is NOT economically beneficial to build the new model V';
    warning(msg);
    
    % check if x1 = 1500, x2 = 1000, x3 = 0 is within constraints
    xcheck = [1250;1000;0];
    
    if(A4*xcheck-(b4')>0)
        msg = 'Contract for Model W and Model R is not within constraints';
        warning(msg);
    else
        disp('Contract for Model W and Model R is within constraints');
    end

end
