% required data from:
% post_pro_minerva
% seaBottomApprox
% navDataPic
% those functions save the data contained in the .mat files below

%clear all

load navData.mat % includes northROV &b yawRow and so on--- load('navData.mat', 'northROV')
load linLocApproxData.mat
load seaBottomApprox.mat
%% plot function

% 1. plot sea bottom bathymetry data from DVL and ROV line
% 2. plot linear approximation of all area
% 3. plot rov in a position related to a picture and camera axis
% 4. plot point nearer the camera axis and points set
% 5. plot linear approximation of area
% 6. plot frames

close all
figure
hold on
axis equal
grid on
xlabel('east');
ylabel('north');
zlabel('depth');
%axis([-25,5,-15,15,-80,-65])
plotOnlyOneShot=1;
picNum=100;
step=40;
l=l_t;

%% settings
plotBathymetry=1;
plotMosPlane=0;
plotROV=1;
plotPointsSet=0;
plotLocLinApprox=0;
plotFrames=0;
plotTrace=1;
plotMosFrame=0;
plotNED=0;
plotSeaBottomFrame=0;

EstStates=States.Eta_Est.Data;
%% 1. Plot Bathymetry
%plot3(seaB(2,:),seaB(1,:),-seaB(3,:),'g')

if plotBathymetry
    hold on
    
    tx = min(seaB(1,:)):.1:max(seaB(1,:));
    ty = min(seaB(2,:)):.1:max(seaB(2,:));
    [qx,qy] = meshgrid(tx,ty);  
    qz = F(qx,qy);
    mesh(qy,qx,-qz);
    hold on
    plot3(seaB(2,:)',seaB(1,:)',-seaB(3,:)','o','linewidth',0.1)
    axis([min(seaB(2,:)) max(seaB(2,:)) min(seaB(1,:)) max(seaB(1,:)) -max(seaB(3,:)) -min(seaB(3,:))+3 ])
end

if plotTrace
    plot3(EstStates(start:start+l_t,2),EstStates(start:start+l_t,1),-EstStates(start:start+l_t,3),'b','linewidth',1);
end
%% 2. Plot Mosaic Plane
if plotMosPlane
    hold on
    mesh(ty_allArea,tx_allArea,-tz_allArea-2);
end
%% 3. Plot ROV
if plotROV
    if plotOnlyOneShot
        hold on
        phi=rollROV(picNum)*pi/180;        %in radians
        theta=pitchROV(picNum)*pi/180;
        psi=yawROV(picNum)*pi/180;
        
        transROVX=eastROV(picNum);
        transROVY=northROV(picNum);
        transROVZ=depthROV(picNum);
        attitude=[phi theta psi];
        
        position=[transROVX transROVY transROVZ];
        drawROV(position,attitude);
    else
        for picNum=1:step:l
            
            hold on
            %%
            
            phi=rollROV(picNum)*pi/180;        %in radians
            theta=pitchROV(picNum)*pi/180;
            psi=yawROV(picNum)*pi/180;
            
            transROVX=eastROV(picNum);
            transROVY=northROV(picNum);
            transROVZ=depthROV(picNum);
            
            transROVX=eastROV(picNum);
            transROVY=northROV(picNum);
            %   transROVX=northROV(picNum);
            %  transROVY=eastROV(picNum);
            transROVZ=depthROV(picNum);
            
            attitude=[phi theta psi];
            
            position=[transROVX transROVY transROVZ];
            drawROV(position,attitude);
        end
    end
    
    aa=2
    bb=1
    
    plot3(seaB1(aa,picNum),seaB1(bb,picNum),-seaB1(3,picNum),'or','linewidth',5)
    plot3(seaB2(aa,picNum),seaB2(bb,picNum),-seaB2(3,picNum),'or','linewidth',5)
    plot3(seaB3(aa,picNum),seaB3(bb,picNum),-seaB3(3,picNum),'or','linewidth',5)
    plot3(seaB4(aa,picNum),seaB4(bb,picNum),-seaB4(3,picNum),'or','linewidth',5)
    
    
end
%% 4. Plot Points Set
if plotPointsSet
    if plotOnlyOneShot
        hold on
        plot3(closest(2,picNum),closest(1,picNum),-closest(3,picNum),'*r','linewidth',5);
        hold on
        points=closestSets{picNum};
        plot3(points(2,:),points(1,:),-points(3,:),'.b');
    else
        for picNum=1:step:l
            hold on
            plot3(closest(2,picNum),closest(1,picNum),-closest(3,picNum),'*r','linewidth',5);
            hold on
            points=closestSets{picNum};
            plot3(points(2,:),points(1,:),-points(3,:),'.b');
        end
    end
end
%% 5. Plot Local Approximation
if plotLocLinApprox
    if plotOnlyOneShot
        %         points=closestSets{picNum};
        %         plot3(points(2,:),points(1,:),-points(3,:),'.g');
        surf(ty(picNum,:),tx(picNum,:),-tz(:,:,picNum));
        plot3(O(2,picNum),O(1,picNum),O(3,picNum),'*g','linewidth',10)
        hold on
    else
        for picNum=1:step:l
            surf(ty(picNum,:),tx(picNum,:),-tz(:,:,picNum));
            hold on
        end
    end
end
%plot3(closest(2,picNum),closest(1,picNum),-closest(3,picNum),'*r','linewidth',1);

%% 6. Plot Frames
if plotFrames
    hold on
    
    if plotNED
        % NED frame
        p1=[2,0,-70]';
        p2=[4,0,-70]';
        %text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'y_n','FontSize',10,'fontWeight','bold');
        arrow3d(p1',p2','black');
        p2=[2,2,-70]';
        %text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'x_n','FontSize',10,'fontWeight','bold');
        arrow3d(p1',p2','black');
        p2=[2,0,-72]';
        %text(p2(1)+0.2,p2(2)+0.2,p2(3)+0.2,'z_n','FontSize',10,'fontWeight','bold');
        arrow3d(p1',p2','black');
    end
    
    if plotSeaBottomFrame
        % SEA BOTTOM frame
        P2=[ty(picNum,10),tx(picNum,20),-tz(20,10,picNum)]';
        Os=[O(2,picNum) O(1,picNum) O(3,picNum)]';
        Zs=Os+[Oz(2,picNum) Oz(1,picNum) Oz(3,picNum)]';
        Ys=P2;
        v = cross(Ys-Os,Zs-Os);
        v = v/norm(v);
        Xs=Os+v;
        
        arrow3d(Os',Zs','magenta');
        %text(Zs(1)+0.1,Zs(2)+0.1,Zs(3)+0.1,'z_s','FontSize',10,'fontWeight','bold','color','magenta');
        arrow3d(Os',Ys','magenta');
        %text(Ys(1)+0.1,Ys(2)+0.1,Ys(3)+0.1,'y_s','FontSize',10,'fontWeight','bold','color','magenta');
        arrow3d(Os',Xs','magenta');
        %text(Xs(1)+0.1,Xs(2)+0.1,Xs(3)+0.1,'x_s','FontSize',10,'fontWeight','bold','color','magenta');
    end
    
    if plotMosFrame
        % MOSAIC frame
        % normal to the plane (ricorda che in figura i punti rappresentati sono [y x -z])
        %  mesh(ty_allArea,tx_allArea,-tz_allArea-2);
        P1=[ty_allArea(1),tx_allArea(1),-tz_allArea(1)-2];
        P2=[ty_allArea(10),tx_allArea(3),-tz_allArea(3,10)-2];
        P3=[ty_allArea(10),tx_allArea(1),-tz_allArea(1,10)-2];
        u = cross(P2-P1,P3-P1);
        u = u/(norm(u)/3);
        
        I=[P3(1),P3(2),P3(3)];
        
        P2=(P2-I)/(norm(P2-I)/3)+I;
        P1=(P1-I)/(norm(P1-I)/3)+I;
        Os=P3;
        Zs=Os+u;
        Ys=P2;
        Xs=P1;
        
        arrow3d(Os,Zs,'blue');
        % text(Zs(1)+0.1,Zs(2)+0.1,Zs(3)+0.1,'z_m','FontSize',10,'fontWeight','bold','color','blue');
        arrow3d(Os,Ys,'blue');
        % text(Ys(1)+0.1,Ys(2)+0.1,Ys(3)+0.1,'y_m','FontSize',10,'fontWeight','bold','color','blue');
        arrow3d(Os,Xs,'blue');
        %  text(Xs(1)+0.1,Xs(2)+0.1,Xs(3)+0.1,'x_m','FontSize',10,'fontWeight','bold','color','blue');
    end
end