function [arr_rov,arr_cam,fill_rov,fill_cam,cam_line]=drawROV(position,attitude)

%% draw ROV
%close all
hold on

transROVX=position(1);
transROVY=position(2);
transROVZ=position(3);
phi=attitude(1);
theta=attitude(2);
psi=attitude(3);

theta=-theta;
phi=phi;


 psi=psi*180/pi;
 psi=-psi+90;
 psi=psi*pi/180;

X=[0.7,0.7,0.7,0.7;
   0.7,0.7,-0.7,-0.7;
   -0.7,-0.7,-0.7,-0.7;
   0.7,0.7,-0.7,-0.7;
   0.7,0.7,-0.7,-0.7;
   0.7,0.7,-0.7,-0.7]';
Y=[0.4,-0.4,-0.4,0.4;
    0.4,0.4,0.4,0.4;
    0.4,0.4,-0.4,-0.4;
    -0.4,-0.4,-0.4,-0.4;
    -0.4,0.4,0.4,-0.4;
    -0.4,0.4,0.4,-0.4]';
Z=[-0.4,-0.4,0.4,0.4;
    -0.4,0.4,0.4,-0.4;
    -0.4,0.4,0.4,-0.4;
    -0.4,0.4,0.4,-0.4;
    -0.4,-0.4,-0.4,-0.4;
    0.4,0.4,0.4,0.4]';
C=ones(4,6);

[X,Y,Z]=rotateCube(X,Y,Z,-phi,-theta,psi);
X=X+transROVX;
Y=Y+transROVY;
Z=Z+transROVZ;
fill_rov=fill3(X,Y,-Z,'green');

%R=rot3d(-phi,-theta,psi);
R=rot3d(phi,theta,psi);
p1=R*[0,0,0]';
p1=p1+[transROVX transROVY -transROVZ]';
p2=R*[2,0,0]';
p2=p2+[transROVX transROVY -transROVZ]';
%text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'x_b','FontSize',10,'fontWeight','bold');
[varargout,arr_rov.a1,arr_rov.b1,arr_rov.c1,arr_rov.d1]=arrow3d(p1',p2','green');
p2=R*[0,-2,0]';
p2=p2+[transROVX transROVY -transROVZ]';
%text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'y_b','FontSize',10,'fontWeight','bold');
[varargout,arr_rov.a2,arr_rov.b2,arr_rov.c2,arr_rov.d2]=arrow3d(p1',p2','green');
p2=R*-[0,0,2]';
p2=p2+[transROVX transROVY -transROVZ]';
%text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'z_b','FontSize',10,'fontWeight','bold');
[varargout,arr_rov.a3,arr_rov.b3,arr_rov.c3,arr_rov.d3]=arrow3d(p1',p2','green');


hold on
X=[0.1,0.1,0.1,0.1;0.1,0.1,-0.1,-0.1;-0.1,-0.1,-0.1,-0.1;0.1,0.1,-0.1,-0.1;0.1,0.1,-0.1,-0.1;0.1,0.1,-0.1,-0.1]'+0.7;
Y=[0.1,-0.1,-0.1,0.1;0.1,0.1,0.1,0.1;0.1,0.1,-0.1,-0.1;-0.1,-0.1,-0.1,-0.1;-0.1,0.1,0.1,-0.1;-0.1,0.1,0.1,-0.1]'-0.4;
Z=[-0.1,-0.1,0.1,0.1;-0.1,0.1,0.1,-0.1;-0.1,0.1,0.1,-0.1;-0.1,0.1,0.1,-0.1;-0.1,-0.1,-0.1,-0.1;0.1,0.1,0.1,0.1]'+0.4;
C=0.5*ones(4,6);
[X,Y,Z]=rotateCube(X,Y,Z,-phi,-theta,psi);
X=X+transROVX;
Y=Y+transROVY;
Z=Z+transROVZ;
fill_cam=fill3(X,Y,-Z,'red');


axCamX=[0.7 0.7]';
axCamY=-[0.4 0.4]';
axCamZ=[0.4 2.4]';
[axCamX,axCamY,axCamZ]=rotateCube(axCamX,axCamY,axCamZ,-phi,-theta,psi);
axCamX=axCamX+transROVX;
axCamY=axCamY+transROVY;
axCamZ=axCamZ+transROVZ;
cam_line=line(axCamX,axCamY,-axCamZ,'LineWidth',1.5,'LineStyle','--','color','r');

%%

%R=rot3d(-phi,-theta,psi);
R=rot3d(phi,theta,psi);
p1=R*[0.7,-0.4,-0.4]';
p1=p1+[transROVX transROVY -transROVZ]';
p2=R*[2.7,-0.4,-0.4]';
p2=p2+[transROVX transROVY -transROVZ]';
%text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'x_b','FontSize',10,'fontWeight','bold');
[varargout,arr_cam.a1,arr_cam.b1,arr_cam.c1,arr_cam.d1]=arrow3d(p1',p2','red');
p2=R*[0.7,-2.4,-0.4]';
p2=p2+[transROVX transROVY -transROVZ]';
% %text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'y_b','FontSize',10,'fontWeight','bold');
[varargout,arr_cam.a2,arr_cam.b2,arr_cam.c2,arr_cam.d2]=arrow3d(p1',p2','red');
p2=R*[0.7,-0.4,-1.6]';
p2=p2+[transROVX transROVY -transROVZ]';
% %text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'z_b','FontSize',10,'fontWeight','bold');
[varargout,arr_cam.a3,arr_cam.b3,arr_cam.c3,arr_cam.d3]=arrow3d(p1',p2','red');




 end