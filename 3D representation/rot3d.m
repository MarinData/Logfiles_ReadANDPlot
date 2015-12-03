function [R]=rot3d(phi,theta,psi) 
% Rotation matrix

R=[ cos(psi)*cos(theta)         -sin(psi)*cos(phi)+cos(psi)*sin(theta)*sin(phi)         sin(psi)*sin(phi)+cos(psi)*cos(phi)*sin(theta);
    sin(psi)*cos(theta)          cos(psi)*cos(phi)+sin(phi)*sin(theta)*sin(psi)        -cos(psi)*sin(phi)+sin(theta)*sin(psi)*cos(phi);
   -sin(theta)                   cos(theta)*sin(phi)                                    cos(theta)*cos(phi)];


end