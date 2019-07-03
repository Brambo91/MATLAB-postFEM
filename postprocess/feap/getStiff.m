% function getStiff

% get C and D matrix for initialized E1, E2, G12, nu12, nu23 and theta

E1=38.9;
E2=13.3;
G12=5.13;
nu12=0.258;
nu23=0.258;
% E1=30;
% E2=30;
% G12=30/sqrt(3);

% E1=160;
% E2=10;
% G12=1.5*5.5;
% nu12=0.3;
% nu23=nu12;
theta=10;

Cb=zeros(6);
Cb(1,1)=1/E1;
Cb(1,2)=-nu12/E1;
Cb(1,3)=Cb(1,2);
Cb(2,1)=Cb(1,2);
Cb(2,2)=1/E2;
Cb(2,3)=-nu23/E2;
Cb(3,1)=Cb(1,2);
Cb(3,2)=Cb(2,3);
Cb(3,3)=Cb(2,2);
Cb(4,4)=1/G12;
Cb(5,5)=(1+nu23)/E2/2;
Cb(6,6)=1/G12;

Db=Cb^(-1);

T=zeros(6);

c=cosd(theta);
s=sind(theta);
T(1,1) = c^2;
T(1,2) = s^2;
T(1,6) = 2*c*s;
T(2,1) = s^2;
T(2,2) = c^2;
T(2,6) = -2*c*s;
T(3,3) = 1;
T(4,4) = c;
T(4,5) = -s;
T(5,4) = s;
T(5,5) = c;
T(6,1) = -s*c;
T(6,2) = s*c;
T(6,6) = c^2-s^2;

Ti = T^(-1);

D = Ti*Db*Ti';
C = D^(-1);
