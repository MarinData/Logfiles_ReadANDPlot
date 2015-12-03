%% Find indexes
% from picture number find index of x-y position on path
% need variable or function indTag to work

%% transects:
% 1:  20-168
% 2:  180-290
% 3:  300-480
% 4:  500-650
% 5:  670-830
% 6:  870-1170
% 7:  1220-1410
% 8:  1490-1720
% 9:  1760-1950
% 10: 2010-2177

step=round((indTag(168)-indTag(20))/1000);
j=1;
start=20;
for i=1:1:1000
    tr1(j)=indTag(start)+(i-1)*step;
    x1(j)=north_est(tr1(j));
    y1(j)=east_est(tr1(j));
    z1(j)=depth_est(tr1(j))+alt_est(tr1(j));
    depth1(j)=depth_est(tr1(j));
    alt1(j)=alt_est(tr1(j));
    j=j+1;
end
step=round((indTag(290)-indTag(180))/1000)
j=1;
start=180;
for i=1:1:1000
    tr2(j)=indTag(start)+(i-1)*step;
    x2(j)=north_est(tr2(j));
    y2(j)=east_est(tr2(j));
    z2(j)=depth_est(tr2(j))+alt_est(tr2(j));
    j=j+1;
end
step=round((indTag(480)-indTag(300))/1000)
j=1;
start=300;
for i=1:1:1000
    tr3(j)=indTag(start)+(i-1)*step;
    x3(j)=north_est(tr3(j));
    y3(j)=east_est(tr3(j));
    z3(j)=depth_est(tr3(j))+alt_est(tr3(j));
    j=j+1;
end
step=round((indTag(650)-indTag(500))/1000)
j=1;
start=500;
for i=1:1:1000
    tr4(j)=indTag(start)+(i-1)*step;
    x4(j)=north_est(tr4(j));
    y4(j)=east_est(tr4(j));
    z4(j)=depth_est(tr4(j))+alt_est(tr4(j));
    j=j+1;
end
step=round((indTag(830)-indTag(670))/1000)
j=1;
start=670;
for i=1:1:1000
    tr5(j)=indTag(start)+(i-1)*step;
    x5(j)=north_est(tr5(j));
    y5(j)=east_est(tr5(j));
    z5(j)=depth_est(tr5(j))+alt_est(tr5(j));
    j=j+1;
end
step=round((indTag(1170)-indTag(870))/1000)
j=1;
start=870;
for i=1:1:1000
    tr6(j)=indTag(start)+(i-1)*step;
    x6(j)=north_est(tr6(j));
    y6(j)=east_est(tr6(j));
    z6(j)=depth_est(tr6(j))+alt_est(tr6(j));
    j=j+1;
end
step=round((indTag(1410)-indTag(1220))/1000)
j=1;
start=1220;
for i=1:1:1000
    tr7(j)=indTag(start)+(i-1)*step;
    x7(j)=north_est(tr7(j));
    y7(j)=east_est(tr7(j));
    z7(j)=depth_est(tr7(j))+alt_est(tr7(j));
    j=j+1;
end
step=round((indTag(1720)-indTag(1490))/1000)
j=1;
start=1490;
for i=1:1:1000
    tr8(j)=indTag(start)+(i-1)*step;
    x8(j)=north_est(tr8(j));
    y8(j)=east_est(tr8(j));
    z8(j)=depth_est(tr8(j))+alt_est(tr8(j));
    j=j+1;
end
step=round((indTag(1950)-indTag(1760))/1000)
j=1;
start=1760;
for i=1:1:1000
    tr9(j)=indTag(start)+(i-1)*step;
    x9(j)=north_est(tr9(j));
    y9(j)=east_est(tr9(j));
    z9(j)=depth_est(tr9(j))+alt_est(tr9(j));
    j=j+1;
end
step=round((indTag(2177)-indTag(2010))/1000)
j=1;
start=2010;
for i=1:1:1000
    tr10(j)=indTag(start)+(i-1)*step;
    x10(j)=north_est(tr10(j));
    y10(j)=east_est(tr10(j));
    z10(j)=depth_est(tr10(j))+alt_est(tr10(j));
    j=j+1;
end



x=[x1,x2,x3,x4,x5,x6,x7,x8,x9,x10]';
y=[y1,y2,y3,y4,y5,y6,y7,y8,y9,y10]';
z=[z1,z2,z3,z4,z5,z6,z7,z8,z9,z10]';

plot3(x,y,z)
close all

figure
%%
F=TriScatteredInterp(x,y,z);
%F=scatteredInterpolant(x,y,z);

tx = -15:.1:13;
ty = -25:.1:5;
[qx,qy] = meshgrid(tx,ty);
qz = F(qx,qy);
mesh(qx,qy,-qz);
hidden off
%colormap gray
grid on
axis equal
xlabel('East');
ylabel('North');
zlabel('Bottom Depth');
%break;

hold on;

plot3(north_est(:),east_est(:),-(depth_est(:)+alt_est(:)),'b','linewidth',1);
%legend('ROV Estimated Path');

plot3(x,y,-z);




break
%%
I=imread('pic6.jpg'); %An image already in Matlabnott
I=imrotate(I,270);
%[x,y]=meshgrid([1:400],[1:563]); 
%z=x.^2-y.^2;%z values
%[qx,qy]=meshgrid([1:200],[1:100]); 
%qz=qx.^2-qy.^2;%z values
warp(qx,qy,-qz,I) %Place the image on the axis

%%
% close all
% figure;
% plot3(x1,y1,-z1)
% hold on;
% 
% a = 1;
% b = [1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20 1/20];
% z1f = filter(b,a,z1);
% hold on;
% 
% plot3(x1(21:length(z1f)),y1(21:length(z1f)),-z1f(21:length(z1f)),'r')

% %%
% figure
% plot(alt1);
% figure
% plot(depth1);
