function [SbH,SH] = dstrehis(iel)
disp('Nom stress evolution within a damaging element (both coord frames)')
disp('Are elastic parameters and theta and A in dstrehis.m correct?')
% output: sig ( time step , gauss point , component )

global T Ti

%%

% input (yang3)
E1 = 140e3;
E2 = 10e3;
nu12 = 0.21;
nu23 = 0.21;
G12 = 5e3;
theta = 90;
A1 = 15;
A2 = 2;

% % input (offax)
% E1 = 38.9e3;
% E2 = 13.3e3;
% nu12 = 0.258;
% nu23 = 0.4;
% G12 = 5.13e3;
% theta = -10;
% A1 = 100;
% A2 = 15;

nu21 = nu12*E2/E1;

C0=zeros(6);
C0(1,1)=1/E1;
C0(1,2)=-nu21/E2;
C0(1,3)=C0(1,2);
C0(2,1)=C0(1,2);
C0(2,2)=1/E2;
C0(2,3)=-nu23/E2;
C0(3,1)=C0(1,2);
C0(3,2)=C0(2,3);
C0(3,3)=C0(2,2);
C0(4,4)=1/G12;
C0(5,5)=2*(1+nu23)/E2;
C0(6,6)=1/G12;

% rotation matrix
co = cosd(theta);
si = sind(theta);
T = zeros(6);
T(1,1) = co^2;
T(1,2) = si^2;
T(1,4) = 2*si*co;
T(2,1) = si^2;
T(2,2) = co^2;
T(2,4) = -2*si*co;
T(3,3) = 1;
T(4,1) = -si*co;
T(4,2) = si*co;
T(4,4) = co^2-si^2;
T(5,5) = co;
T(5,6) = -si;
T(6,5) = si;
T(6,6) = co;

Ti = T^(-1);

EH = strahis(iel);
nt = size(EH,1);

EbH = zeros(nt,8,6);

for it=1:nt
  for ip=1:8
    EbH(it,ip,1:6) = Ti' * squeeze( EH(it,ip,1:6) );
  end
end

DH1 = hisvhis(iel,1);
DH2 = hisvhis(iel,2);
D1 = min ( 0.9999 , A1 ./ ( (A1-1) + 1 ./ DH1 ) );
D2 = min ( 0.9999 , A2 ./ ( (A2-1) + 1 ./ DH2 ) );
SbH = zeros(nt,8,6);
SH = zeros(nt,8,6);

for it = 1:nt
  for ip = 1:8
    C = C0;
    C(1,1) = C(1,1) / ( 1 - D1(it,ip) );
    for j = 2:6
      C(j,j) = C(j,j) / ( 1 - D2(it,ip) );
    end
    De = C^(-1);
    SbH(it,ip,:) = De * squeeze( EbH(it,ip,:) );
    SH(it,ip,:) = Ti * squeeze( SbH(it,ip,:) );
  end 
end
  

% plot sigma4 in each gauss point
plot(SbH(:,:,1))