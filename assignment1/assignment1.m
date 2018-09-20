%Luca = 040
%Nathan = 449

clear all

E1 = 4;
E2 = 8;
E3 = 9;

bc = (5 + E1) * 10e6; %battery cells
bw = 4*10e3; %battery cells for W
br = 6*10e3; %battery cells for R
hrw = 15; %hours required for W
hrr = 10; %hours required for R
nemp = 100 + E2; %number of employees
hpm = 160; %hours per month per employee
thpm = nemp * hpm;
ms = 3000 + 50*E3; %monthly salary
avs = (15 + E3) * 10e3; %available storage space
rssw = 12; % required storage space W
rssr = 10; % required storage space R
pr = 55000; %price R
pw = 75000; %price W
mcr = 30000; %manufacturing cost R
mcw = 45000; %manufacturing cost W


%% Part 2
c = [(mcr - pr), (mcw - pw)];

A =[br,     bw;
    rssr,   rssw;
    hrr,    hrw];

b = [bc, avs, thpm];

lb = [0 0]; %lower bound

ub = [inf inf]; %upper bound

options = optimoptions('linprog','Algorithm','dual-simplex');
                    
[x1,fval,exitflag,output,lambda] = linprog(c,A,b,[],[],lb,ub,options);
round(x1)
profit1 =-c*round(x1)

%% Part 3

ub = [1000 inf]; %upper bound
                    
[x2,fval,exitflag,output,lambda] = linprog(c,A,b,[],[],lb,ub,options);
round(x2)
profit2 =-c*round(x2)

%% Part 3

bc = (8 + E1) * 10e6; %battery cells
avs = (22 + E3) * 10e3; %available storage space

c = [(mcr - pr), (mcw - pw), ms];

A =[br,     bw,     0;
    rssr,   rssw,   0;
    hrr,    hrw,    -((5/60)+160)];

b = [bc, avs, thpm];

lb = [0 0 0]; %lower bound

ub = [1000 inf 72]; %upper bound
                    
[x3,fval,exitflag,output,lambda] = linprog(c,A,b,[],[],lb,ub,options);
round(x3)
profit3 = -c*round(x3)