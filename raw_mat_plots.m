% plot script for ROV data              
%--------------------------------------------------------------------------
clc;clear;close all;

%% INPUT:-------------------------------------------------------------------
date_time='20140814--0930';  % file ID 
% '20140814--0930' is haltbrekken run1 image folder
start_t='09:30:49'; % start time
end_t='12:15:49';

% Change from 1 to 0 to only get transponder plot
sflag=1;   % sflag=0: plot all data in file, else part of file
tflag=0;   % selct which time to use in plots
all=1;     % all=0: only NED plot, else all plots    
%% END INPUT----------------------------------------------------------------

path_c=cd;
addpath([path_c,'/Postprofcn']); % makes the methods in 'Postprofcn' available in this directory
folder_mat='Logfiles_mat';
mat_path=[path_c,'/',folder_mat,'/',date_time,'day','.mat'];

load(mat_path);

%% Select time interval and type

% make other time formats:
time_vec=datevec(datenum([start_t; end_t],'HH:MM:SS'));        % time in datevec format [yyyy mm dd HH MM SS]

f_vec=[3600,60,1];
time_ssmn=time_vec(:,4:6)*f_vec.';    % time since midnight in seconds
time_ssof=time_ssmn-time.ssmn(1);     % time since start of file in seconds

[start,stop] = partial_data(time_ssof(1),time_ssof(2),sflag,time.ssof);

if tflag==0     % use serial date
time_temp=time.serial(start:stop);
elseif tflag==1 % use seconds since midnight
time_temp=time.ssmn(start:stop);
else            % use seconds since start of file
time_temp=time.ssof(start:stop);
end

%% ROV positions:-----------------------------------------------------------
figure(1)
ax1(1)=subplot(3,1,1);
plot(time_temp,raw.HiPAP.pos(1,start:stop),'b')
title('HiPAP North Transponder Position')
xlabel('t [s]')
ylabel('N [m]')
hleg=legend('$N_{tp}$');
set(hleg,'interpreter','latex')
grid on

ax1(2)=subplot(3,1,2);
plot(time_temp,raw.HiPAP.pos(2,start:stop),'b')
title('HiPAP East Transponder Position')
xlabel('t [s]')
ylabel('E [m]')
hleg=legend('$E_{tp}$');
set(hleg,'interpreter','latex')
grid on

ax1(3)=subplot(3,1,3);
plot(time_temp,raw.PG.depth(start:stop),'b')
title('Depth')
xlabel('t [s]')
ylabel('z [m]')
hleg=legend('$z_m$');
set(hleg,'interpreter','latex')
grid on

linkaxes(ax1,'x')
if tflag==0
dynamicDateTicks(ax1, 'linked')
end

%% (Resten av plottene)
if all==1;

% plot Compass 
figure(2)
%ax2(1)=subplot(3,1,3);
plot(time_temp,raw.Compass.psi(start:stop),'b')
title('Compass heading')
xlabel('t [s]')
ylabel('\psi [m]')
hleg=legend('$\psi$');
set(hleg,'interpreter','latex')
dynamicDateTicks
grid on

% ROV velocities: ---------------------------------------------------------
figure(3)
ax2(1)=subplot(3,1,1);
plot(time_temp,raw.DVL.bottomtrack(1,start:stop),'b')
title('DVL X Velocity')
xlabel('t [s]')
ylabel('u [m/s]')
grid on

ax2(2)=subplot(3,1,2);
plot(time_temp,raw.DVL.bottomtrack(2,start:stop),'b')
title('DVL Y Velocity')
xlabel('t [s]')
ylabel('v [m/s]')
grid on

ax2(3)=subplot(3,1,3);
plot(time_temp,raw.DVL.bottomtrack(3,start:stop),'b')
title('DVL Z Velocity')
xlabel('t [s]')
ylabel('w [m/s]')
grid on

linkaxes(ax2,'x')
if tflag==0
dynamicDateTicks(ax2, 'linked')
end

%% MTI output
% acc (raw): --------------------------------------------------------------
figure(4)
ax3(1)=subplot(2,2,1);
plot(time_temp,raw.MTi.MT_SINGLE(start:stop,1),time_temp,raw.MTi.MT_SINGLE(start:stop,2),time_temp,raw.MTi.MT_SINGLE(start:stop,3))
title('Accelerometers')
xlabel('t [s]')
ylabel('acc [m/s^2]')
legend('acc_x', 'acc_y', 'acc_z') % cov is 6.4-6.8e-005 for acc
grid on

ax3(2)=subplot(2,2,2);
plot(time_temp,raw.MTi.MT_SINGLE(start:stop,4),time_temp,raw.MTi.MT_SINGLE(start:stop,5),time_temp,raw.MTi.MT_SINGLE(start:stop,6))
title('Gyro rates')
xlabel('t [s]')
ylabel('turn rate [rads/s]')
legend('p', 'q', 'r') % cov is 2.0-2.2e-005 for gyros
grid on

ax3(3)=subplot(2,2,3);
plot(time_temp,raw.MTi.MT_SINGLE(start:stop,7),time_temp,raw.MTi.MT_SINGLE(start:stop,8),time_temp,raw.MTi.MT_SINGLE(start:stop,9))
title('Magnetometer')
xlabel('t [s]')
ylabel('AU')
legend('mag_x', 'mag_y', 'mag_z') % cov is about 5e-007 for mags
grid on

%Use comment for MTi-100, no attitude data
% ax3(4)=subplot(2,2,4);
% plot(time_temp,raw.MTi.MT_SINGLE(start:stop,10),time_temp,raw.MTi.MT_SINGLE(start:stop,11),time_temp,raw.MTi.MT_SINGLE(start:stop,12),time_temp,raw.Compass.psi(start:stop),'b')
% title('Orientation from MTi KF')
% xlabel('t [s]')
% ylabel('[degs]')
% hleg=legend('$\phi$', '$\theta$', '$\psi_{KF}$', '$\psi_{compass}$');
% set(hleg,'interpreter','latex')
% grid on

linkaxes(ax3,'x')
if tflag==0
dynamicDateTicks(ax3, 'linked')
end

%% DVL altitudes-----------------------------------------------------------
% DVL and est altitudes in mission:----------------------------------------
figure(5)
plot(time_temp,raw.DVL.altitudes(1,start:stop),'-b',time_temp,raw.DVL.altitudes(2,start:stop),'--r',time_temp,raw.DVL.altitudes(3,start:stop),':k',time_temp,raw.DVL.altitudes(4,start:stop),'-.g') % map DVL no to quad no: 1->2, 2->4, 3->1, 4->3: (blue 600kHz DVL)
%plot(RAW.DVL_a)
title('DVL Altitudes')
xlabel('t [s]') % time_temp
ylabel('a [m]')
hleg=legend('$a^{DVL}_1$','$a^{DVL}_2$','$a^{DVL}_3$','$a^{DVL}_4$');
set(hleg,'interpreter','latex') % make it into latex syntax
%ylim([7 19])
grid on

if tflag==0
dynamicDateTicks
end

%% HiPAP 2-D plot -- plot(LonditudeROV,LatitudeROV,'b')

figure(6)
plot(raw.HiPAP.pos(2,start:stop),raw.HiPAP.pos(1,start:stop),'b')
axis equal
xlabel('East Position [m]')
ylabel('North Position [m]')
title('ROV Trace')
grid on

end %all
