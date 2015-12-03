%% Post processing of DVL data to approximate the seabottom
% - for the April 2012 data - Tautra mosaic
% Needs the following parameters:
% - THETA_hat

load ('/Users/larsbrusletto/Documents/MATLAB/Master/ROVprogram/Logfiles_mat/20140814--0930day.mat');

%THETA_hat =
%EstStates is probably estimated States


% The program want to be in radians
convertToRad = pi/180;

%fixed DVL parameters
Gamma=30*convertToRad;

Beta=[270 90 0 180]*convertToRad;

r_d_b=[-0.79,0,-0.10]'; % is 

%% attitude
roll_est=THETA_hat(1,:)*convertToRad;
pitch_est=THETA_hat(2,:)*convertToRad;
yaw_est=EstStates(:,4)*convertToRad;
north_est=EstStates(:,1);
east_est=EstStates(:,2);
depth_est=EstStates(:,3);

%% dvl data
dvl1=dvl(:,1);
dvl2=dvl(:,2);
dvl3=dvl(:,3);
dvl4=dvl(:,4);

for i=20246:-1:1 % hmm 20246 = ?
    if (dvl1(i)==dvl1(i+1))&&(dvl2(i)==dvl2(i+1))&&(dvl3(i)==dvl3(i+1))&&(dvl4(i)==dvl4(i+1))
        dvl1(i+1)=[];
        dvl2(i+1)=[];
        dvl3(i+1)=[];
        dvl4(i+1)=[];
        roll_est(i+1)=[];
        pitch_est(i+1)=[];
        yaw_est(i+1)=[];
        north_est(i+1)=[];
        east_est(i+1)=[];
        depth_est(i+1)=[];
        
    end
end

%% 
l=length(dvl1);
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

disp('end 1')
%% getting the rj_d
for i=1:1:l
    r1_d(:,i)=dvl1(i)*[tan(Gamma)*cos(Beta(1)) tan(Gamma)*sin(Beta(1)) 1]';
    r2_d(:,i)=dvl2(i)*[tan(Gamma)*cos(Beta(2)) tan(Gamma)*sin(Beta(2)) 1]';
    r3_d(:,i)=dvl3(i)*[tan(Gamma)*cos(Beta(3)) tan(Gamma)*sin(Beta(3)) 1]';
    r4_d(:,i)=dvl4(i)*[tan(Gamma)*cos(Beta(4)) tan(Gamma)*sin(Beta(4)) 1]';
end
disp('end 2')
%% transforming into body frame
for i=1:1:l
    r1_b(:,i)=rot3d(0,0,-45*convertToRad)*r1_d(:,i)+r_d_b;
    r2_b(:,i)=rot3d(0,0,-45*convertToRad)*r2_d(:,i)+r_d_b;
    r3_b(:,i)=rot3d(0,0,-45*convertToRad)*r3_d(:,i)+r_d_b;
    r4_b(:,i)=rot3d(0,0,-45*convertToRad)*r4_d(:,i)+r_d_b;
end
disp('end 3')
%% transforming into ned frame
for i=1:1:l
    r1_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r1_b(:,i);
    r2_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r2_b(:,i);
    r3_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r3_b(:,i);
    r4_n(:,i)=rot3d(roll_est(i),pitch_est(i),yaw_est(i))*r4_b(:,i);
end
disp('end 4')
%%  calculating sea bottom in four points
for i=1:1:l
    seaB1(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r1_n(:,i);
    seaB2(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r2_n(:,i);
    seaB3(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r3_n(:,i);
    seaB4(:,i)=[north_est(i) east_est(i) depth_est(i)]'+r4_n(:,i);
end
disp('end 5')
%%
seaB=[seaB1,seaB2,seaB3,seaB4];
%moreData=[x';y';z'];
%seaB=[seaB,moreData];
figure

F=TriScatteredInterp(seaB(1,:)',seaB(2,:)',seaB(3,:)','linear');
disp('end 6')
%break
hold on

% claculate mesh data
tx = -15:.1:13;
ty = -25:.1:5;
[qx,qy] = meshgrid(tx,ty);
%[qx,qy] = meshgrid(seaB(1,1:10:9012),seaB(2,1:10:9012));
qz = F(qx,qy);
% Plot mesh
mesh(qx,qy,-qz);
axis equal
hidden off
hold on
plot3(EstStates(:,1),EstStates(:,2),-(EstStates(:,3)+EstStates(:,13)),'b','linewidth',1);

%% end
% for i=2253*0+1:1:2253*4
%    plot3(seaB(1,i),seaB(2,i),-seaB(3,i),'ro') 
%     
% end



%plot3(x,y,-z)