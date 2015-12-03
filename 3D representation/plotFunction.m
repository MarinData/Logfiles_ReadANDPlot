% required data from:
% post_pro_minerva
% seaBottomApprox
% navDataPic
% those functions save the data contained in the .mat files below

%clear all

load navData.mat
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
plotOnlyOneShot=0;
picNum=100;
step=3;
l=l_t;
animate=1;
speedFactor=1;
FramePeriod=0.08;

aa=2
            bb=1

%% settings
plotBathymetry=1;
plotMosPlane=0;
plotROV=1;
plotPointsSet=0;
plotLocLinApprox=0;
plotFrames=0;
plotTrace=0;
plotMosFrame=0;
plotNED=0;
plotSeaBottomFrame=0;

EstStates=States.Eta_Est.Data;


%% 1. Plot Bathymetry
%plot3(seaB(2,:),seaB(1,:),-seaB(3,:),'g')

if plotBathymetry
    mmm=[min(seaB(1,:));min(seaB(2,:));0]
    hold on
    for i=1:1:length(seaB)
        seaB(:,i)=seaB(:,i)-mmm;
        
    end
    for i=1:1:length(seaB1)
        seaB1(:,i)=seaB1(:,i)-mmm;
        seaB2(:,i)=seaB2(:,i)-mmm;
        seaB3(:,i)=seaB3(:,i)-mmm;
        seaB4(:,i)=seaB4(:,i)-mmm;
    end
    
     F=TriScatteredInterp(seaB(1,:)',seaB(2,:)',seaB(3,:)','natural');
    tx = min(seaB(1,:)):0.1:max(seaB(1,:));
    ty = min(seaB(2,:)):0.1:max(seaB(2,:));
    [qx,qy] = meshgrid(tx,ty);
    qz = F(qx,qy);
    if not(animate)
        mesh(qy,qx,-qz);
        hold on
        plot3(seaB(2,:)',seaB(1,:)',-seaB(3,:)','o','linewidth',0.1)
        axis([min(seaB(2,:)) max(seaB(2,:)) min(seaB(1,:)) max(seaB(1,:)) -max(seaB(3,:)) -min(seaB(3,:))+3 ])
    end
end


if plotTrace&&not(animate)
    
    plot3(EstStates(start:start+l_t,2),EstStates(start:start+l_t,1),-EstStates(start:start+l_t,3),'b','linewidth',1);
    
end
%% 2. Plot Mosaic Plane
if plotMosPlane
    hold on
    mesh(ty_allArea,tx_allArea,-tz_allArea-2);
end
%% 3. Plot ROV
if plotROV
    if animate
        
        axis([min(seaB(2,:))-2 max(seaB(2,:))+2 min(seaB(1,:))-2 max(seaB(1,:))+2 -max(seaB(3,:)) -min(seaB(3,:))+3 ])
        
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
            northROV=northROV-mmm(1);
            eastROV=eastROV-mmm(2);
            
            picNum=1;
            phi=rollROV(picNum)*pi/180;        %in radians
            theta=pitchROV(picNum)*pi/180;
            psi=yawROV(picNum)*pi/180;
            
            transROVX=eastROV(picNum);
            transROVY=northROV(picNum);
            transROVZ=depthROV(picNum);
            
            transROVX=eastROV(picNum);
            transROVY=northROV(picNum);
            transROVZ=depthROV(picNum);
            
            attitude=[phi theta psi];
            position=[transROVX transROVY transROVZ];
            
            [arr_rov,arr_cam,fill_rov,fill_cam,cam_line]=drawROV(position,attitude);
            
            dvl_b1=plot3(seaB1(aa,picNum),seaB1(bb,picNum),-seaB1(3,picNum),'or','linewidth',5)
            dvl_b2=plot3(seaB2(aa,picNum),seaB2(bb,picNum),-seaB2(3,picNum),'or','linewidth',5)
            dvl_b3=plot3(seaB3(aa,picNum),seaB3(bb,picNum),-seaB3(3,picNum),'or','linewidth',5)
            dvl_b4=plot3(seaB4(aa,picNum),seaB4(bb,picNum),-seaB4(3,picNum),'or','linewidth',5)
            
            trace= plot3(EstStates(start:start,2),EstStates(start:start,1),-EstStates(start:start,3),'b','linewidth',1);
            
            
            tx = min(seaB(1,:))-5:0.1:northROV(picNum)+5;
            ty = min(seaB(2,:))-5:0.1:eastROV(picNum)+5;
            [qx,qy] = meshgrid(tx,ty);
            qz = F(qx,qy);
            
            threeD_bott=mesh(qy,qx,-qz);
            
            
            notePosition=text(northROV(picNum), eastROV(picNum) ,depthROV(picNum), 'STARTING', 'Color', 'k');
            noteDistance=text(northROV(picNum), eastROV(picNum) ,depthROV(picNum), 'STARTING', 'Color', 'k');
            distanceDone=0;
            
            for picNum=2:step:l
                tic
                distanceDone=distanceDone+sqrt((northROV(picNum)-northROV(picNum-1))^2+(eastROV(picNum)-eastROV(picNum-1))^2);
                
                
                % vel=space/time
                %framePeriod=sqrt((abs(States.eta_est.Data(picNum,1))-abs(States.eta_est.Data(picNum-1,1)))^2+(abs(States.eta_est.Data(picNum,2))-abs(States.eta_est.Data(picNum-1,2)))^2+abs((States.eta_est.Data(picNum,3))-abs(States.eta_est.Data(picNum-1,3)))^2)/sqrt(States.nu_est.Data(picNum,1)^2+States.nu_est.Data(picNum,2)^2+States.nu_est.Data(picNum,3)^2);
           %     freamePeriod=framePeriod/speedFactor;
                delete(arr_rov.a1,arr_rov.b1,arr_rov.c1,arr_rov.d1,arr_rov.a2,arr_rov.b2,arr_rov.c2,arr_rov.d2,arr_rov.a3,arr_rov.b3,arr_rov.c3,arr_rov.d3,arr_cam.a1,arr_cam.b1,arr_cam.c1,arr_cam.d1,arr_cam.a2,arr_cam.b2,arr_cam.c2,arr_cam.d2,arr_cam.a3,arr_cam.b3,arr_cam.c3,arr_cam.d3,fill_rov,fill_cam,cam_line);
                delete(trace);
            
                    delete(threeD_bott);
           
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
                transROVZ=depthROV(picNum);
                
                attitude=[phi theta psi];
                position=[transROVX transROVY transROVZ];
                
                [arr_rov,arr_cam,fill_rov,fill_cam,cam_line]=drawROV(position,attitude);
                refreshdata(arr_rov.a1,'caller');
                refreshdata(arr_rov.b1,'caller');
                refreshdata(arr_rov.c1,'caller');
                refreshdata(arr_rov.d1,'caller');
                refreshdata(arr_rov.a2,'caller');
                refreshdata(arr_rov.b2,'caller');
                refreshdata(arr_rov.c2,'caller');
                refreshdata(arr_rov.d2,'caller');
                refreshdata(arr_rov.a3,'caller');
                refreshdata(arr_rov.b3,'caller');
                refreshdata(arr_rov.c3,'caller');
                refreshdata(arr_rov.d3,'caller');
                refreshdata(arr_cam.a1,'caller');
                refreshdata(arr_cam.b1,'caller');
                refreshdata(arr_cam.c1,'caller');
                refreshdata(arr_cam.d1,'caller');
                refreshdata(arr_cam.a2,'caller');
                refreshdata(arr_cam.b2,'caller');
                refreshdata(arr_cam.c2,'caller');
                refreshdata(arr_cam.d2,'caller');
                refreshdata(arr_cam.a3,'caller');
                refreshdata(arr_cam.b3,'caller');
                refreshdata(arr_cam.c3,'caller');
                refreshdata(arr_cam.d3,'caller');
                refreshdata(fill_rov,'caller');
                refreshdata(fill_cam,'caller');
                refreshdata(cam_line,'caller');
                
               delete(dvl_b1,dvl_b2,dvl_b3,dvl_b4);
                
                dvl_b1=plot3(seaB1(aa,picNum),seaB1(bb,picNum),-seaB1(3,picNum),'or','linewidth',5);
                dvl_b2=plot3(seaB2(aa,picNum),seaB2(bb,picNum),-seaB2(3,picNum),'or','linewidth',5);
                dvl_b3=plot3(seaB3(aa,picNum),seaB3(bb,picNum),-seaB3(3,picNum),'or','linewidth',5);
                dvl_b4=plot3(seaB4(aa,picNum),seaB4(bb,picNum),-seaB4(3,picNum),'or','linewidth',5);
                
                refreshdata(dvl_b1,'caller');
                refreshdata(dvl_b2,'caller');
                refreshdata(dvl_b3,'caller');
                refreshdata(dvl_b4,'caller');
%                 
                trace= plot3(EstStates(start:start+picNum,2),EstStates(start:start+picNum,1),-EstStates(start:start+picNum,3),'b','linewidth',1);
                
                refreshdata(trace,'caller');
                
                
                stepB=(northROV(picNum)-northROV(1))/100;
                tx = northROV(1):stepB:northROV(picNum);
                
                stepB=(eastROV(picNum)-eastROV(1))/100;
                ty = eastROV(1):stepB:eastROV(picNum);
                
%                 delete(notePosition);
%                 notePosition=text(northROV(picNum), eastROV(picNum) ,depthROV(picNum), 'PROVA', 'Color', 'k');
%                 refreshdata(notePosition,'caller');
                
                [qx,qy] = meshgrid(tx,ty);
                qz = F(qx,qy);
                
                threeD_bott=mesh(qy,qx,-qz);
                %                    hold on
                %                     plot3(seaB(2,:)',seaB(1,:)',-seaB(3,:)','o','linewidth',0.1)
                axis([min(seaB(2,:)) max(seaB(2,:)) min(seaB(1,:)) max(seaB(1,:)) -max(seaB(3,:)) -min(seaB(3,:))+3 ])
                refreshdata(threeD_bott,'caller');
                
                
                delete(notePosition);
                delete(noteDistance);       
                posLabel=strcat('(',num2str(northROV(picNum)+mmm(1)),',',num2str(eastROV(picNum)+mmm(2)),')');
                disLabel=strcat('Distance: ',num2str(distanceDone));
                notePosition=text( eastROV(picNum)+1, northROV(picNum)+1 ,-depthROV(picNum)+0.5, posLabel, 'Color', 'k','FontSize',12);
                noteDistance=text( eastROV(picNum)+1, northROV(picNum)+1 ,-depthROV(picNum), disLabel, 'Color', 'k','FontSize',12);
               
                
                
                drawnow;
                pause(FramePeriod);
                toc
            end
        end
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
            
            transROVX=transROVX-mmm(2);
             transROVY=transROVY-mmm(1);
    %        transROVZ=transROVZ-min(depthROV);
            
            attitude=[phi theta psi];
            position=[transROVX transROVY transROVZ];
            
            drawROV(position,attitude);
         
        end

    end
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