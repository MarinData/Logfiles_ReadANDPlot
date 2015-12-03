function [time, signal_in, MT_DATA, MT_SINGLE, DVL_alts, ship_pos, dBar]=readLogFile_raw(path) 

% readLogFile_raw
% 
% Purpose: 
%           Read log text files (raw file) for ROV MINERVA & 30k
%               
% Record of revisions:
% Date:        Programmer:                    Description of change:
%--------------------------------------------------------------------------
% based on Mauro Candeloro read of log file..
% Oct 2012       Fredrik Dukan             org. 
% 13 Dec 2012    Fredrik Dukan             read MTi-100 data in legacy mode and Digiquartz in kPa
% 04 Feb 2015    Stein M. Nornes           correct Digiquartz to dBar
%
%
%--------------------------------------------------------------------------
% time, signals out (X_tp, Y_tp, Z_pg, 0, 0,psi_c, u_dvl, v_dvl, z_dvl, p, q, r), MT DATA, dvl alts (1-4), Ship pos (X,Y, Psi [deg])

fid=fopen(path);

i=0;
stop=0;
while stop==0
    i=i+1;
    h1=fgetl(fid);
    lh=length(h1);
    
    if lh >= 1 && h1(1)=='t'
        stop=1;
    end
    logInfo(i,1)={h1};
end

%logInfo=logInfo(1:i-1,:);
check=logInfo{1,:};
l_c=length(check);
% time, signals in (X_tp, Y_tp, Z_pg, 0, 0,psi_c, u_dvl, v_dvl, z_dvl, p, q, r), MT DATA, dvl alts (1-4), Ship pos (X,Y, Psi [deg])
%rawData=textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %d %d %d %d %d %d %d %d %d %d %d %d %f %f %f %f %f %f %f');
rawData=textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %f %f %f %f %f %f %f %f %f');       

time=rawData{1};
[r,c]=size(time); 

signal_in=zeros(12,r);
for i=1:12
signal_in(i,:)=rawData{i+1};  
end

% MT_DATA=zeros(r,12);
% for i=1:12
% MT_DATA(:,i)=rawData{i+13};  
% end

MT_DATA=zeros(r,43);
for i=1:43
MT_DATA(:,i)=rawData{i+13};  
end

%IMU measurements
%MT_SINGLE=[acc_x (m/s^2),acc_y (m/s^2),acc_z (m/s^2),gyr_x (rad/s),gyr_y (rad/s),gyr_z (rad/s),mag_x (AU), mag_y (AU), mag_z (AU), roll (degs), pitch (degs), pitch (degs)]
%NOTE: values in MTi reference frame. 
% convert from bits to single:
MT_SINGLE=zeros(r,9);
for i=1:r 
    for j=1:9    
        temp=uint8([MT_DATA(i,7+(4*j-3):-1:4+(4*j-3))]);
        MT_SINGLE(i,j)=typecast(temp, 'single');
    end
end

DVL_alts=zeros(4,r);
for i=1:4
DVL_alts(i,:)=rawData{i+56};  %25 %68
end

ship_pos=zeros(3,r);
for i=1:3
ship_pos(i,:)=rawData{i+60};  %29 %72
end

dBar=rawData{64}; %raw Digiquartz readings in kPa

fclose(fid);
%end of read file ---------------------------------------------------------

end

