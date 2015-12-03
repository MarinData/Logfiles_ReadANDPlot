
%% plot only the track
figure();
hold on;

ticklabelformat(gca,'x','%.0fE')
ticklabelformat(gca,'y','%.0fN')

%% Plot track
plot(east_des(ind_s:ind_e)+pos_offset(2),north_des(ind_s:ind_e)+pos_offset(1),'b');
plot(east_mes(ind_s:ind_e)+pos_offset(2),north_mes(ind_s:ind_e)+pos_offset(1),'r');
plot(east_est_real(ind_s:ind_e),north_est_real(ind_s:ind_e),'color',[0 0.8 0]);
legend('Planned Path','Measured Path','Estimated Path');
xlabel('East [m]');
ylabel('North [m]')
axis equal
grid on


%% Plot Dots
for i=1:1:l
    head_corr(i,1:2)=[cos(head_est(indTag(i))*pi/180) -sin(head_est(indTag(i))*pi/180); sin(head_est(indTag(i))*pi/180) cos(head_est(indTag(i))*pi/180)]*[cam_offset(1) cam_offset(2) ]';
    head_est(indTag(i));
    disp (sprintf(strcat('Plotting camera position: ', num2str(i),' on ',num2str(l))));
end

% plot(east_est_real(indTag(:))+head_corr(:,2),north_est_real(indTag(:))+head_corr(:,1),'r -o');
% hold on

for i=1:1:l
    resto=mod(i,5);
    if resto==0
        text(east_est_real(indTag(i))+0.01,north_est_real(indTag(i))+0.01,num2str(i));
    end
end


%% Plot total depth
figure
plot(depth_est(:)+alt_des(:));
legend('Approximated Sea Bottom Depth [m]');
xlabel('Position along the path [m]');
ylabel('Total Sea Bottom Depth [m]')
grid on