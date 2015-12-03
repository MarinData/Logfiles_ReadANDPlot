clc
close all
%PRODUCES THE .MAT FILE linLocApproxData.mat

% load in start & stop & l_t 
load ('/Users/larsbrusletto/Documents/MATLAB/Master/ROVprogram/partialDataInfo.mat');

% Need to load in time.str somehow??
%% Parameters to set
cam_offset=[0.7 0.4 0.4];

timeTrans=time.str(start:start+l_t,:);
dateForm=strcat(date_name(7:8),'-',date_name(5:6),'-',date_name(1:4));
%% Reads the name of the pictures to find the time (up to second precision) when they were takem)

for k=1:l_t
    
    northROV(k)=States.Eta_est.data(k+start-1,1);         % recovering position and attitude of ROV for that picture
    eastROV(k)=States.Eta_est.data(k+start-1,2);
    depthROV(k)=States.Eta_est.data(k+start-1,3);
    altROV(k)=States.Alt_Est.Data(k+start-1);
    rollROV_rad(k)=States.Eta_est.data(k+start-1,4);
    pitchROV_rad(k)=States.Eta_est.data(k+start-1,5);
    yawROV_rad(k)=rad2infinf(States.Eta_est.data(k+start-1,6));   %from post_pro_minerva             
                                            
    rollROV(k)=rollROV_rad(k)*180/pi;
    pitchROV(k)=pitchROV_rad(k)*180/pi;
    yawROV(k)=yawROV_rad(k)*180/pi;

    % obtaining position and attitude of the CAMERA for that picture
    pCam(:,k)=[northROV(k) eastROV(k) depthROV(k)]'+rot3d(rollROV_rad(k),pitchROV_rad(k),yawROV_rad(k))*cam_offset';
    northCAM(k)=pCam(1,k);
    eastCAM(k)=pCam(2,k);
    depthCAM(k)=pCam(3,k);
    altCAM(k)=depthROV(k)+altROV(k)-depthCAM(k);
end


save('navData.mat','northROV','eastROV','depthROV','rollROV','pitchROV','yawROV','-mat');

%% Writing all down to a file

delete(strcat(fold,'\geoTagUHI_',date_name,'.txt'));
ff=fopen(strcat(fold,'\geoTagUHI_',date_name,'.txt'),'w');
Header=sprintf('This file contains all the information regarding position and attitude of ROV and Camera for every recorded instant.\nIndex\tDate[dd-mm-yyyy]\tTime[hh:mm:ss.dddd]\tNorthCAM[m]\tEastCAM[m]\tRollROV/CAM[deg]\tPitchROV/CAM[deg]\tYawROV/CAM[deg]\tDepthCAM[m]\tAltCAM[m]\tNorthROV[m]\tEastROV[m]\tRollROV/CAM[rad]\tPitchROV/CAM[rad]\tYawROV/CAM[rad]\tDepthROV[m]\tDepthCAM[m]\tAltitudeROV[m]\n');
fprintf(ff,'%s',Header);
for i=1:1:l_t
    fprintf(ff,'%d\t %s\t %s\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n',i,dateForm,timeTrans{i},northCAM(i),eastCAM(i),rollROV(i),pitchROV(i),yawROV(i),depthCAM(i),altCAM(i),northROV(i),eastROV(i),rollROV_rad(i),pitchROV_rad(i),yawROV_rad(i),depthROV(i),altROV(i));
end
fclose(ff);

%% find line through camera z-axis and intersection with approximation plane (only to find first point to start searching)

% for i=1:1:l_t
%     
%     phi=rollROV_rad(i);
%     theta=pitchROV_rad(i);
%     psi=yawROV_rad(i);
%     
%     pLine1(:,i)=pCam(:,i);
%     pLine2(:,i)=[northROV(i) eastROV(i) depthROV(i)]'+rot3d(phi,theta,psi)*(cam_offset'+[0 0 1]');
%     
%     
% end
% 
 %save('linLocApproxData.mat','pLine1','pLine2','-mat');

%% for each picture find bathymetry point closest to camera axis, collecting all the points inside a circle to linearly approximate that area 
% clear closestSet closestSets closest closestInd d a1 a2 
% 
% 
% for i=1:1:l_t/20
%     fprintf('%d on %d\n',i,floor(l_t/20))
%     k=1;
%     closestSet=[];
%     for j=1:1:length(seaB)
%         a1=pLine2(:,i)-pLine1(:,i);
%         a2=seaB(:,j)-pLine2(:,i);
%         d(j) = norm(cross(a1,a2))/norm(a1);
%         if d(j)<5
%             closestSet(:,k)=seaB(:,j);
%             k=k+1;
%         end        
%     end
%     closestSets{i}=closestSet;
%     [~,closestInd(i)]=min(d);
%     closest(:,i)=seaB(:,closestInd(i));
% end
% 
% save('linLocApproxData.mat','closestSets','closest','-append');

%% linearly approximate the region with a plane described by z=ax+by+c
% k=1;
% i=1;
% j=1;
% clear tx ty tz
%  
% hold on
% for k=1:1:l_t/20
%     fprintf('%d on %d\n',k,floor(l_t/20))
%     points=closestSets{k};
% 
%     [a(k),b(k),c(k)]=linApprox(points);
%     tx(k,:) = closest(1,k)-2:.1:closest(1,k)+2;
%     ty(k,:) = closest(2,k)-2:.1:closest(2,k)+2;
% 
%     for i=1:1:length(tx(k,:))
%         for j=1:1:length(ty(k,:))
%             tz(i,j,k)=a(k)+b(k)*tx(k,i)+c(k)*ty(k,j);
%         end
%     end
% end
% 
% save('linLocApproxData.mat','tx','ty','tz','-append');


%% find intersection camera axes / linear approximation

% for k=1:1:l_t/20
% 
%     fprintf('%d on %d\n',k,floor(l_t/20))
%     P1=[tx(k,1),ty(k,1),-tz(1,1,k)];
%     P2=[tx(k,10),ty(k,20),-tz(10,20,k)];
%     P3=[tx(k,20),ty(k,20),-tz(20,20,k)];
%     u = cross(P2-P1,P3-P1);
%     Oz(:,k) = u/norm(u);
% 
%     [O(:,k),check]=plane_line_intersect(Oz,P2,[pLine1(1,k) pLine1(2,k) -pLine1(3,k)],[pLine2(1,k) pLine2(2,k) -pLine2(3,k)]);
%   
%     save('linLocApproxData.mat','O','Oz','-append');
% end

