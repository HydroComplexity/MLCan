clear x y;
%day=[168, 182, 196, 218, 231, 252, 274, 295, 309, 330];    % wrong
day = [138, 152, 167, 188, 201, 232, 244, 265, 278, 300];   % 2005
%day = [115, 128, 158, 187, 214, 243, 257, 271, 286];        %2006

num_plot=length(day);
x=[0:0.5:23.5];
dayplot=day-doy(1);
figure(12);

for j=2:9
    num_j=num2str(j);
    day_j=num2str(day(j));
    obs = ['obs',num_j];
    Sheet = ['Sheet',num_j];
    obs=xlsread('GS_SW_obs_05.xlsx',Sheet);
    for i=1:48
        y(i)=gs_sun_2_store(i+dayplot(j)*48);
    end
    xobs=obs(:,1);
    yobs=obs(:,2);
    subplot(3,3,j);
    hold on;
    grid on;
    plot(x,y,'k','LineWidth',1);
    plot(xobs,yobs,'ro', 'MarkerFaceColor','b','MarkerEdgeColor','k');
    day_plot=['Day ',day_j];
    title(day_plot);
    xlabel('hours');
    ylabel('gs [mol m^{-2} s^{-1}]');
    axis([4,22,0,0.5]);
    %legend('model','obs');
end
legend('model','obs');