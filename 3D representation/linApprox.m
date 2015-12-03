function [a,b,c]=linApprox(p)
err_new=0;
err_old=10;
l=length(p);

kf_H=[ones(l,1),p(1,:)',p(2,:)'];   %matrice enorme
kf_y=p(3,:)';                       %vettore enorme
kf_u=zeros(l,1);

kf_time=l;
kf_x_0=[1 1 1]';
kf_P_0=eye(3);
kf_Q=0;
kf_R=1;
kf_Phi=eye(3);
kf_Delta=zeros(3,1);
kf_Gamma=zeros(3,1);

while abs(err_new-err_old)>10^-6
    err_old=err_new;
    [~,kf_x_est,~]=DKF(kf_x_0,kf_P_0,kf_Q,kf_R,kf_Phi,kf_Delta,kf_Gamma,kf_H,kf_time,kf_y,kf_u);
    a=kf_x_est(1);
    b=kf_x_est(2);
    c=kf_x_est(3);
    err_new=0;
    for i=1:1:l
        err_new=err_new+(p(3,i)-(a+b*p(1,i)+c*p(2,i)))^2;
    end
    kf_x_0=kf_x_est;
end
end