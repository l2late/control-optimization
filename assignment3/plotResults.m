function plotResults(x,k)
%PLOTRESULTS Summary of this function goes here
%   Detailed explanation goes here
%% Plot results
figure();
subplot(2,1,1)
plot(1:k,x(1:4,:),'LineWidth',2);
title('Density')
ylabel('veh/(km lane)')
legend('Density segment 1','Density segment 2','Density segment 3','Density segment 4');
set(gca,'FontSize',20)   

subplot(2,1,2)
plot(1:k,x(5:8,:),'LineWidth',2)
title('Speed')
ylabel('km/h')
legend('Speed segment 1', 'Speed segment 2','Speed segment 3','Speed segment 4'); 
set(gca,'FontSize',20)  
end

