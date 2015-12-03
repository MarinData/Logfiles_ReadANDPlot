function [time, eta_mes, eta_est, eta_des, altitudes, gradF]=readLogFile_eta(path) 

% readLogFile_eta
% 
% Purpose: 
%           Read log text files (eta file) for ROV MINERVA & 30k
%               
% Record of revisions:
% Date:        Programmer:                    Description of change:
%--------------------------------------------------------------------------
% based on Mauro Candeloro read of log file..
% Oct 2012    Fredrik Dukan                 org. 
% 
%
%--------------------------------------------------------------------------
% time, eta_mes, eta_est, eta_des (6-DOF), alt_mes, alt_est, alt_des, gradF_x, gradF_y, gradF_z 
%%
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
% time, eta_mes, eta_est, eta_des (6-DOF), alt_mes, alt_est, alt_des, gradF_x, gradF_y, gradF_z 
statesData=textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
                        
time=statesData{1};
[r,c]=size(time); 

eta_mes=zeros(6,r);
for i=1:6
eta_mes(i,:)=statesData{i+1};  
end

eta_est=zeros(6,r);
for i=1:6
eta_est(i,:)=statesData{i+7};  
end

eta_des=zeros(6,r);
for i=1:6
eta_des(i,:)=statesData{i+13};  
end

altitudes=zeros(3,r);
for i=1:3
altitudes(i,:)=statesData{i+19};  
end

gradF=zeros(3,r);
for i=1:3
gradF(i,:)=statesData{i+22};  
end

fclose(fid);

end

