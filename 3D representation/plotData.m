clc
close all
%load log5.mat  
load /Users/larsbrusletto/Documents/MATLAB/Master/ROVprogram/Logfiles_mat/20140814--0930day.mat;

%use
% northEastPhotomosaic.m
% ticklabelformat.m

convertToRad = pi/180;

%% Description of log file
% data specifications (APRIL DATA):
% time, north_mes, east_mes, depth_mes, head_mes, --,--,--,--, north_est,
% east_est, depth_est, head_est, --,--,--,--, north_des, east_des,
% depth_des, head_des,--,--,--,--, 16x (--), alt_mes, alt_est, alt_des, 8x (--)  

% offset position: [--- N	--- E]

% transform time in seconds. The first time will be zero. The offset is
% indicated in the plot.

%% Need the foolowing parameters for program to work
% north_est

%% Parameters to set
calculate_time=0;                                   %put to one if t_s is not defined in the workspace
%path='C:\Users\candelor\Desktop\Long Trip';       % path to the images
pos_offset=[7052810.00	 575250.00]';                % find in the header
cam_offset=[0.65 0.4]; 
time_start=[13 49 00];                              % period you want to plot
time_end=[14 36 00];

% Lars Version
%path='/Users/larsbrusletto/Documents/MASTER/Haltbrekken/Run1';
path = '/Users/larsbrusletto/Documents/MASTER/Haltbrekken/Run1/Left';
% cam_offset is maybe the time between the stereoImages?

%% Reads the name of the pictures (where you can find the times)
n=dir(path);
l=length(n); % 56
n=n(3:l);
l=length(n); % 52
%picturesToTag = zeros(l);


for i=1:1:l % i=1,2,3,4...54
    %picturesToTag(i,:)=n(i).name; % ex: n(5).name = LeftCameraRun1_11.png
    %picturesToTag(i)=n(i).name;
end
picturesToTag = n(1).name; 


n_off=pos_offset(1);
e_off=pos_offset(2);

l=length(time);

%% calculates the time if you set calculate_time to 1 before
if calculate_time    
    t=time{1};
    hh=str2num(t(1:2));
    mm=str2num(t(4:5));
    ss=str2num(t(7:8));
    dd=str2num(t(10));
    t_s_off=hh*60*60+mm*60+ss+dd/10;
    
    for i=1:1:l
        t=time{i};
        hh=str2num(t(1:2));
        mm=str2num(t(4:5));
        ss=str2num(t(7:8));
        dd=str2num(t(10));
        t_s(i)=hh*60*60+mm*60+ss+dd/10-t_s_off;
        disp (sprintf(strcat('Calculating time indexes: ', num2str(i),' on ',num2str(l))));
    end
end

% for i=1:1:l
%     if north_est(i)<10000
%         north_est(i)=north_est(i)+n_off;
%         east_est(i)=east_est(i)+e_off;
%     end
% end


north_est_real=north_est+n_off;
east_est_real=east_est+e_off;
%%
figure();
ticklabelformat(gca,'x','%.0fE')
ticklabelformat(gca,'y','%.0fN')
%%
[ind_s]=northEastPhotomosaic(time_start, time);
[ind_e]=northEastPhotomosaic(time_end, time);

%% Plot track
plot(east_est_real(ind_s:ind_e),north_est_real(ind_s:ind_e));
hold on
axis equal
grid on

%% Find position of the pictures by comparing their name with logfile
[l  ll]=size(picturesToTag);
indTag=0;
picturesTime=[0 0 0];
for i=1:1:l
    picturesTime(i,:)=[str2double(picturesToTag(i,10:11))+2 str2double(picturesToTag(i,12:13)) str2double(picturesToTag(i,14:15))];
    if i>1
        indTag(i)=northEastPhotomosaicTAG(picturesTime(i,:), time, indTag(i-1));
    else
        indTag(i)=northEastPhotomosaicTAG(picturesTime(i,:), time, 2);
    end
    disp (sprintf(strcat('Comparing pictures with log file: ', num2str(i),' on ',num2str(l))));
end
%% Plot Dots
for i=1:1:l
    head_corr(i,1:2)=[cos(head_est(indTag(i))*pi/180) -sin(head_est(indTag(i))*pi/180);
        sin(head_est(indTag(i))*pi/180) cos(head_est(indTag(i))*pi/180)]*[cam_offset(1) cam_offset(2) ]';
        head_est(indTag(i));
    disp (sprintf(strcat('Plotting camera position: ', num2str(i),' on ',num2str(l))));
end

plot(east_est_real(indTag(:))+head_corr(:,2),north_est_real(indTag(:))+head_corr(:,1),'r -o');
hold on

for i=1:1:l
    resto=mod(i,10);
    if resto==0
        text(east_est_real(indTag(i))+0.01,north_est_real(indTag(i))+0.01,num2str(i));
    end
end

%% Draw ROV
%plot3 makes a 3d plot
ll = 1.44; 				% length (m)
b = 0.82;				% breadth (m)
h = 0.8;                % height (m)
for i = 1:1:l
    R  = [cos(head_est(indTag(i))*pi/180) -sin(head_est(indTag(i))*pi/180) 0;
        sin(head_est(indTag(i))*pi/180) cos(head_est(indTag(i))*pi/180) 0;
        0 0 1];
        rov = R*[ll/2 0.9*ll/2 0.5*ll/2 -ll/2 -ll/2 0.5*ll/2 0.9*ll/2 ll/2;
             0 b/2 b/2 b/2 -b/2 -b/2 -b/2 0;
             h/2 0.9*h/2 0.5*h/2 -h/2 -h/2 0.5*h/2 0.9*h/2 h/2]; 
    plot3(east_est_real(indTag(i))+rov(2,:),north_est_real(indTag(i))+rov(1,:),depth_est(indTag(i))+rov(3,:),'b');
end

%% Writing geo File
ff=fopen('geoTagFile.txt','w');
Header=sprintf('Index\tPicName\tNorth\tEast\tDepth\tAltitude\n');
fprintf(ff,'%s',Header);
for i=1:1:l
    fprintf(ff,'%d\t %s\t %f\t %f\t %f\t %s\n',i,picturesToTag(i,:),north_est_real(indTag(i))+head_corr(i,1),east_est_real(indTag(i))+head_corr(i,2),depth_est(indTag(i)),alt_est(indTag(i)));
end

fclose(ff);

