function [rawTime,time,SensData,EstStates,DesStates,ControlF,ThrustRPM,dvl,raw,MT_SINGLE,Theta_JS,logInfo,MRU6_DATA]=readLogFile(path) 


fid=fopen(path);
i=0;
stop=0;
while stop==0
    i=i+1;
    h1=fgetl(fid);
    lh=length(h1);
    
    if lh >= 1 && h1(1)=='!'
        stop=1;
    end
    logInfo(i,1)={h1};
end

logInfo=logInfo(1:i-1,:);
check=logInfo{1,:};
l_c=length(check);
%!time  x_m   y_m   z_m  psi_m   u_m   v_m   w_m*   r_m   x_hat y_hat z_hat  psi_hat   u_hat   v_hat   w_hat   r_hat  x_des   y_des   z_des   psi_des   u_des   v_des   w_des   r_des   X    Y    Z    N    s _rpm    v_rpm    l_rpm    r_rpm  b1  b2  b3  b4 dvl1  dvl2  dvl3  dvl4  a_sonar  a_hat a_des
disp('i''m reading the file')
rawData=textscan(fid,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %f %f %f %f %f %f %f %f %f %f');
                        
rawTime=rawData{1};
[r,c]=size(rawTime); 

x_m=rawData{2};
y_m=rawData{3};
z_m=rawData{4};
psi_m=rawData{5};
u_m=rawData{6};
v_m=rawData{7};
w_m=rawData{8};
r_m=rawData{9};

x_hat=rawData{10};
y_hat=rawData{11};
z_hat=rawData{12};
psi_hat=rawData{13};
u_hat=rawData{14};
v_hat=rawData{15};
w_hat=rawData{16};
r_hat=rawData{17};

x_des=rawData{18};
y_des=rawData{19};
z_des=rawData{20};
psi_des=rawData{21};
u_des=rawData{22};
v_des=rawData{23};
w_des=rawData{24};
r_des=rawData{25};

X=rawData{26};
Y=rawData{27};
Z=rawData{28};
N=rawData{29};

s_rpm=rawData{30};
v_rpm=rawData{31};
l_rpm=rawData{32};
r_rpm=rawData{33};

b_1=rawData{34};
b_2=rawData{35};
b_3=rawData{36};
b_4=rawData{37};

dvl_1=rawData{38};
dvl_2=rawData{39};
dvl_3=rawData{40};
dvl_4=rawData{41};

a=rawData{42};
a_hat=rawData{43};
a_des=rawData{44};

raw_d=rawData{45};
raw_a=rawData{46};
raw_psi=rawData{47};
raw_r=rawData{48};
raw_e=rawData{49};
raw_n=rawData{50};
raw_v=rawData{51};
raw_u=rawData{52};

MT_DATA=zeros(r,55);
for i=1:55
MT_DATA(:,i)=rawData{i+52};  
end

JS_AXIS=zeros(r,4);
for i=1:4
JS_AXIS(:,i)=rawData{i+107};
end

Theta_JS=JS_AXIS; % Logitech freedom 2.4 joystick
%Theta_JS=[JS_AXIS(:,1) -JS_AXIS(:,2) -JS_AXIS(:,4) -JS_AXIS(:,3)]; %convert to paper joystick reference frame coord

psi_comp=rawData{112};

MRU6_DATA=zeros(r,8);
for i=1:8
MRU6_DATA(:,i)=rawData{i+113};
end

SensData=[x_m,y_m,z_m,psi_m,u_m,v_m,w_m,r_m,a,psi_comp];
EstStates=[x_hat,y_hat,z_hat,psi_hat,u_hat,v_hat,w_hat,r_hat,b_1,b_2,b_3,b_4,a_hat];
DesStates=[x_des,y_des,z_des,psi_des,u_des,v_des,w_des,r_des,a_des];
ControlF=[X,Y,Z,N];
ThrustRPM=[s_rpm,v_rpm,l_rpm,r_rpm];
%raw=[raw_d,raw_a,raw_psi,raw_r,raw_e,raw_n,raw_v,raw_u]; %org..
raw=[raw_n,raw_e,raw_d,raw_psi,raw_u,raw_v,raw_r,raw_a];

dvl=[dvl_1 dvl_2 dvl_3 dvl_4];

%IMU measurements
%MT_SINGLE=[acc_x (m/s^2),acc_y (m/s^2),acc_z (m/s^2),gyr_x (rad/s),gyr_y (rad/s),gyr_z (rad/s),mag_x (AU), mag_y (AU), mag_z (AU), roll (degs), pitch (degs), pitch (degs)]
%NOTE: values in MTi reference frame. 
% convert from bits to single:
MT_SINGLE=zeros(r,12);
for i=1:r 
    for j=1:12    
        temp=uint8([MT_DATA(i,7+(4*j-3):-1:4+(4*j-3))]);
        MT_SINGLE(i,j)=typecast(temp, 'single');
    end
end

%creating the time vector
%[r,c]=size(rawTime);

actTime=cell2mat(rawTime(1));
hh=str2num(actTime(1:2));
mm=str2num(actTime(4:5));
ss=str2num(actTime(7:8));
fraction=str2num(actTime(10:13));
FIRSTindexTime=fraction+ss*10000+mm*60*10000+hh*3600*10000;

for i=1:1:r
    
%   sigma(i)=str2num(sigmaRaw{i});
    actTime=cell2mat(rawTime(i));
    hh=str2num(actTime(1:2));
    mm=str2num(actTime(4:5));
    ss=str2num(actTime(7:8));
    fraction=str2num(actTime(10:13));
    time(i,1)=(fraction+ss*10000+mm*60*10000+hh*3600*10000-FIRSTindexTime)/10000;
end

fclose(fid);
end

