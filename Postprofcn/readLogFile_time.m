function [time,r,c]=readLogFile_time(path) 

% readLogFile_time
% 
% Purpose: 
%           Read log text files (tau file) for ROV MINERVA & 30k
%               
% Record of revisions:
% Date:        Programmer:                    Description of change:
%--------------------------------------------------------------------------
% based on Mauro Candeloro read of log file..
% Oct 2012    Fredrik Dukan                 org. 
% 
%
%--------------------------------------------------------------------------
% time, tau [N/Nm] (X,Y,Z,K,M,N), rpm(side,vert,starboard,port) 

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
% time, tau [N/Nm] (X,Y,Z,K,M,N), rpm(side,vert,starboard,port) 
rawData=textscan(fid,'%s %f %f %f %f %f %f %d %d %d %d');
                        
time=rawData{1};
[r,c]=size(time); 

fclose(fid);

end

