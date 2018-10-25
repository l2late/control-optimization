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
else
    U1 = U(1:kmax);
    U2 = U(kmax+1:end);
end

figure();
subplot(3,1,1)
plot((1:kmax)-1,[x1;x2;x3;x4],'LineWidth',2);
title('Density')
ylabel('veh/(km lane)')
legend('Density segment 1','Density segment 2','Density segment 3','Density segment 4');
set(gca,'FontSize',20)   

subplot(3,1,2)
plot((1:kmax)-1,[x5;x6;x7;x8],(1:(kmax))-1,U1,'--', 'LineWidth',2)
title('Speed')
ylabel('km/h')
legend('Speed segment 1', 'Speed segment 2','Speed segment 3','Speed segment 4','VSL'); 
set(gca,'FontSize',20)  

subplot(3,1,3)
plot((1:kmax)-1,x9,'LineWidth',2)
if(size(U,1)/kmax > 1 || size(U,2)/kmax > 1)
    hold on;
    plot((1:kmax)-1,U2,'LineWidth',2)
end
title('On-ramp Queue ')
ylabel('# of cars') 
legend('Car queue','r'); 
set(gca,'FontSize',20)  
end

