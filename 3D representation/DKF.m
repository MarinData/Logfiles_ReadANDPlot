%% Implementation of Discrete Kalman Filter
%Mauro Candeloro 2013

%%
function [P_est,x_est,K_dyn]=DKF(x_0,P_0,Q,R,Phi,Delta,Gamma,H,time,y,u)
C=H;    
P_bar=P_0;
x_bar=x_0;

I=eye(3);

x_est=x_bar;
P_est=P_bar;
K_dyn=[0;0;0];


for i=1:1:time
    H=C(i,:);
    K=P_bar*H'*(H*P_bar*H'+R)^-1;
   
    x_hat=x_bar+K*(y(i)-H*x_bar);
    P_hat=(I-K*H)*P_bar*(I-K*H)'+K*R*K';
   
    x_bar=Phi*x_hat+Delta*u(i);
    P_bar=Phi*P_hat*Phi'+Gamma*Q*Gamma';
    
    x_est=[x_bar];
    P_est=[P_est,P_bar];
    K_dyn=[K_dyn,K];
    
    
end

