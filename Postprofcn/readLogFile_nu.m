function [time, nu_mes, nu_est, nu_des]=readLogFile_nu(path) 

% readLogFile_nu
% 
% Purpose: 
%           Read log text files (nu file) for ROV MINERVA & 30k
%               
% Record of revisions:
% Date:        Programmer:                    Description of change:
%--------------------------------------------------------------------------
% based on Mauro Candeloro read of log file..
% Oct 2012    Fredrik Dukan                 org. 
% 
%
%--------------------------------------------------------------------------
% time, nu_mes, nu_est, nu_des (6-DOF) 

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
% time, nu_mes, nu_est, nu_des (6-DOF) 
rawData=textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
                        
time=rawData{1};
[r,c]=size(time); 

nu_mes=zeros(6,r);
for i=1:6
nu_mes(i,:)=rawData{i+1};  
end

nu_est=zeros(6,r);
for i=1:6
nu_est(i,:)=rawData{i+7};  
end

nu_des=zeros(6,r);
for i=1:6
nu_des(i,:)=rawData{i+13};  
end

fclose(fid);

end

