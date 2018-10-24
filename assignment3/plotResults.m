function plotResults(x,k,u)
%PLOTRESULTS Summary of this function goes here
%   Detailed explanation goes here
%% Plot results
figure();
subplot(3,1,1)
plot(1:k,x(1:4,:),'LineWidth',2);
title('Density')
ylabel('veh/(km lane)')
legend('Density segment 1','Density segment 2','Density segment 3','Density segment 4');
set(gca,'FontSize',20)   

subplot(3,1,2)
plot(1:k,x(5:8,:),1:k,u(1:2,:),'LineWidth',2)
title('Speed')
ylabel('km/h')
legend('Speed segment 1', 'Speed segment 2','Speed segment 3','Speed segment 4','VSL2','VSL3'); 
set(gca,'FontSize',20)  

subplot(3,1,3)
plot(1:k,x(9,:),'LineWidth',2)
title('On-ramp Queue ')
ylabel('# of cars') 
set(gca,'FontSize',20)  
end

