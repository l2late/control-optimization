function plotResults(x,kmax,U)
%PLOTRESULTS Summary of this function goes here
%   Detailed explanation goes here
%% Plot results
x1 = x(1,:);
x2 = x(2,:);
x3 = x(3,:);
x4 = x(4,:);
x5 = x(5,:);
x6 = x(6,:);
x7 = x(7,:);
x8 = x(8,:);
x9 = x(9,:);

if (size(U,1)/kmax < 2 && size(U,2)/kmax < 2)
    U1 = U(1:end);
    U2 = ones(kmax,1);
else
    U1 = U(1:kmax);
    U2 = U(kmax+1:end);
end

figure();
subplot(4,1,1)
plot((1:kmax)-1,[x1;x2;x3;x4],'LineWidth',2);
title('Density')
ylabel('veh/(km lane)')
legend('\rho_1','\rho_2','\rho_3','\rho_4');
set(gca,'FontSize',20)   

subplot(4,1,2)
plot((1:kmax)-1,[x5;x6;x7;x8],'LineWidth',2)
hold on;
stairs((1:(kmax))-1,U1,'--', 'LineWidth',2)
title('Speed')
ylabel('km/h')
legend('v_1', 'v_2','v_3','v_4','VSL'); 
set(gca,'FontSize',20)  

subplot(4,1,3)
plot((1:kmax)-1,x9,'LineWidth',2)    
title('On-ramp Queue ')
ylabel('# of cars') 
set(gca,'FontSize',20)  

subplot(4,1,4)
stairs((1:kmax)-1,U2,'LineWidth',2)
title('On-ramp metering ')
ylabel('r(k)') 
set(gca,'FontSize',20) 
end

