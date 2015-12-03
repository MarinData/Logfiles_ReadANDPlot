function [X,Y,Z]=rotateCube(X,Y,Z,phi,theta,psi)
[l1,l2]=size(X);
R=rot3d(phi,theta,psi);
for i=1:1:l1
    for j=1:1:l2
        p=[X(i,j);Y(i,j);Z(i,j)];
        p1=R*p;
        X(i,j)=p1(1);
        Y(i,j)=p1(2);
        Z(i,j)=p1(3);
    end
end


end


