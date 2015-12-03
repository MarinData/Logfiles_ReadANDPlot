%% Post processing of DVL data to approximate the seabottom for the April 2012 data - Tautra mosaic
% Purpose: 
%           Post processing of DVL data 
%
% Subroutines:  1) 
%               2)
%               
%                  
% Comments: this function could contain ad hoc modification for ECOTONE
% file processing
%
% Requirements:    1) RUN dat2mat 
%                  2) RUN post_pro_ROV
%
% Record of revisions:
% Date:        Programmer:                    Description of change:
%--------------------------------------------------------------------------
%    May 13    Mauro Candeloro                org.
% 25 Oct 13    Mauro Candeloro                modification for new log
% files
%--------------------------------------------------------------------------

% start and l_t are the starting index and length of the selected data
% window, they come from post_pro_ROV, saved in the partialDataInfo.mat
load ('/Users/larsbrusletto/Documents/MATLAB/Master/ROVprogram/partialDataInfo.mat')
i1=start;
i2=start+l_t;


%Fixed DVL parameters
Gamma=30*pi/180;
%Beta=[270 90 0 180]*pi/180;
Beta=[180 90 0 270]*pi/180;
r_d_b=[-0.79,0,-0.10]';


%Attitude
% roll_est=THETA_hat(1,:)*pi/180;
% pitch_est=THETA_hat(2,:)*pi/180;
% yaw_est=EstStates(:,4)*pi/180;
% north_est=EstStates(:,1);
% east_est=EstStates(:,2);
% depth_est=EstStates(:,3);

% rotation of ROV
roll_est=States.Eta_est.data(i1:i2,4);
pitch_est=States.Eta_est.data(i1:i2,5);
yaw_est=States.Eta_est.data(i1:i2,6);

% direction of ROV
north_est=States.Eta_est.data(i1:i2,1);
east_est=States.Eta_est.data(i1:i2,2);
depth_est=States.Eta_est.data(i1:i2,3);

%save('navData.mat','roll_est','pitch_est','yaw_est','north_est','east_est','depth_est','-append');

%%
dvl=Raw.DVL_a.Data;
%dvl data
dvl1=dvl(i1:i2,1);
dvl2=dvl(i1:i2,2);
dvl3=dvl(i1:i2,3);
dvl4=dvl(i1:i2,4);

%deleting duplicated data

% for i=l_t:-1:1
%     if (dvl1(i)==dvl1(i+1))&&(dvl2(i)==dvl2(i+1))&&(dvl3(i)==dvl3(i+1))&&(dvl4(i)==dvl4(i+1))
%         dvl1(i+1)=[];
%         dvl2(i+1)=[];
%         dvl3(i+1)=[];
%         dvl4(i+1)=[];
%         roll_est(i+1)=[];
%         pitch_est(i+1)=[];
%         yaw_est(i+1)=[];
%         north_est(i+1)=[];
%         east_est(i+1)=[];
%         depth_est(i+1)=[];
%      
%     end
% end

l=length(dvl1);

%% deleting outliers
for i=2:1:l
    if abs((dvl1(i)-dvl1(i-1)))>1.5
        dvl1(i)=dvl1(i-1);
        disp('eliminato 1');
    end
    if abs((dvl2(i)-dvl2(i-1)))>1.5
        dvl2(i)=dvl2(i-1);
        disp('eliminato 2');
    end
    if abs((dvl3(i)-dvl3(i-1)))>1.5
        dvl3(i)=dvl3(i-1);
        disp('eliminato 3');
    end
    if abs((dvl4(i)-dvl4(i-1)))>1.5
        dvl4(i)=dvl4(i-1);
        disp('eliminato 4');
    end
end

%% getting the rj_d
for i=1:1:l
    r1_d(:,i)=dvl1(i)*[tan(Gamma)*cos(Beta(1)) tan(Gamma)*sin(Beta(1)) 1]';
    r2_d(:,i)=dvl2(i)*[tan(Gamma)*cos(Beta(2)) tan(Gamma)*sin(Beta(2)) 1]';
    r3_d(:,i)=dvl3(i)*[tan(Gamma)*cos(Beta(3)) tan(Gamma)*sin(Beta(3)) 1]';
    r4_d(:,i)=dvl4(i)*[tan(Gamma)*cos(Beta(4)) tan(Gamma)*sin(Beta(4)) 1]';
end

%% transforming into body frame
for i=1:1:l
    r1_b(:,i)=rot3d(0,0,-45*pi/180)*r1_d(:,i)+r_d_b;
    r2_b(:,i)=rot3d(0,0,-45*pi/180)*r2_d(:,i)+r_d_b;
    r3_b(:,i)=rot3d(0,0,-45*pi/180)*r3_d(:,i)+r_d_b;
    r4_b(:,i)=rot3d(0,0,-45*pi/180)*r4_d(:,i)+r_d_b;
end

%% transforming into ned frame
for i=1:1:l
%     r1_n(:,i)=rot3d(roll_est(i),pitch_est(i),(-yaw_est(i)*180/pi+90)*pi/180)*r1_b(:,i);
%     r2_n(:,i)=rot3d(roll_est(i),pitch_est(i),(-yaw_est(i)*180/pi+90)*pi/180)*r2_b(:,i);
%     r3_n(:,i)=rot3d(roll_est(i),pitch_est(i),(-yaw_est(i)*180/pi+90)*pi/180)*r3_b(:,i);
%     r4_n(:,i)=rot3d(roll_est(i),pitch_est(i),(-yaw_est(i)*180/pi+90)*pi/180)*r4_b(:,i);
    r1_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r1_b(:,i);
    r2_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r2_b(:,i);
    r3_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r3_b(:,i);
    r4_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r4_b(:,i);
end

%% calculating sea bottom in four points
for i=1:1:l
    seaB1(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r1_n(:,i);
    seaB2(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r2_n(:,i);
    seaB3(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r3_n(:,i);
    seaB4(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r4_n(:,i);
end

%% Put all together into the same matrix
seaB=[seaB1(:,1),seaB2(:,1),seaB3(:,1),seaB4(:,1)];
for i=2:1:length(seaB1)
seaB=[seaB,seaB1(:,i),seaB2(:,i),seaB3(:,i),seaB4(:,i)];
end

%moreData=[x';y';z'];
%seaB=[seaB,moreData];

%% create mesh
%close all
%START MAURO COMMENT FOR PLOT
figure
F=TriScatteredInterp(seaB(1,:)',seaB(2,:)',seaB(3,:)','natural');

step1=(max(seaB(1,:))-min(seaB(1,:)))/100;
step2=(max(seaB(2,:))-min(seaB(2,:)))/100;

tx = min(seaB(1,:)):step1:max(seaB(1,:));
ty = min(seaB(2,:)):step2:max(seaB(2,:));
[qx,qy] = meshgrid(tx,ty);   %[qx,qy] = meshgrid(seaB(1,1:10:9012),seaB(2,1:10:9012));
qz = F(qx,qy);
mesh(qx,qy,-qz);
hold on
plot3(seaB(1,:)',seaB(2,:)',-seaB(3,:)','o','linewidth',0.1)

plot3(seaB(1,200)',seaB(2,200)',-seaB(3,200)','o','linewidth',0.1)


axis equal
hidden off

hold on
plot3(States.Eta_est.data(i1:i2,1),States.Eta_est.data(i1:i2,2),-(States.Eta_est.data(i1:i2,3)+States.Alt_est.data(i1:i2)),'b','linewidth',1);
%END MAURO COMMENT FOR PLOT

% 
% 
% % for i=2253*0+1:1:2253*4
% %    plot3(seaB(1,i),seaB(2,i),-seaB(3,i),'ro') 
% %     
% % end
% 
 save('seaBottomApprox.mat','seaB','F','-mat');
% 
% %plot3(x,y,-z)
% 
% 
% 
% %% Find intersection of pictures for further correction
% 
% %  N = cross(P2-P1,P3-P1); % Normal to the plane of the triangle
% %  P0 = Q1 + dot(P1-Q1,N)/dot(Q2-Q1,N)*(Q2-Q1); % The point of intersection
% % 
% %  dot(cross(P2-P1,P0-P1),N)>=0 & ...
% %  dot(cross(P3-P2,P0-P2),N)>=0 & ...
% %  dot(cross(P1-P3,P0-P3),N)>=0
% 
% % l=length(seaB);
% % 
% % kf_H=[ones(l,1),seaB(1,:)',seaB(2,:)'];%matrice enorme
% % kf_y=seaB(3,:)';%vettore enorme
% % kf_u=zeros(l,1);
% % 
% % kf_time=l;
% % kf_x_0=[1 1 1]';
% % kf_P_0=eye(3);
% % kf_Q=0;
% % kf_R=1;
% % kf_Phi=eye(3);
% % kf_Delta=zeros(3,1);
% % kf_Gamma=zeros(3,1);
% % 
% % 
% % [~,kf_x_est,~]=DKF(kf_x_0,kf_P_0,kf_Q,kf_R,kf_Phi,kf_Delta,kf_Gamma,kf_H,kf_time,kf_y,kf_u);
% 
% [a_allArea,b_allArea,c_allArea]=linApprox(seaB);
% 
% % a_allArea=kf_x_est(1);
% % b_allArea=kf_x_est(2);
% % c_allArea=kf_x_est(3);
% save('seaBottomApprox.mat','a_allArea','b_allArea','c_allArea','-append');
% %%
% delta=10.0077-(-10.6136)/100;
% tx_allArea = -10.6136:delta:10.0077;
% delta=2.5145-(-22.4985)/100;
% ty_allArea = -22.4985:delta:2.5145;
% for i=1:1:length(tx_allArea)
%     for j=1:1:length(ty_allArea)
%         tz_allArea(i,j)=a_allArea+b_allArea*tx_allArea(i)+c_allArea*ty_allArea(j);
%     end
% end
% 
% save('seaBottomApprox.mat','tx_allArea','ty_allArea','tz_allArea','-append');
% 
% 
