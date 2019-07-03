function SH = strehis(iel)
disp('Effective stress evolution within an element')
disp('Are elastic parameters and theta in strehis.m correct?')
% output: sig ( time step , gauss point , component )

% elastic parameters (yang3)
E1 = 140e3;
E2 = 10e3;
nu12 = 0.21;
nu23 = 0.21;
G12 = 5e3;
nu21 = nu12*E2/E1;

C=zeros(6);
C(1,1)=1/E1;
C(1,2)=-nu21/E2;
C(1,3)=C(1,2);
C(2,1)=C(1,2);
C(2,2)=1/E2;
C(2,3)=-nu23/E2;
C(3,1)=C(1,2);
C(3,2)=C(2,3);
C(3,3)=C(2,2);
C(4,4)=1/G12;
C(5,5)=2*(1+nu23)/E2;
C(6,6)=1/G12;
De=C^(-1);

% rotation matrix
theta = 90
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


SbH = zeros(nt,8,6);
SH = zeros(nt,8,6);

for it = 1:nt
  for ip = 1:8
    SbH(it,ip,:) = De * squeeze( EbH(it,ip,:) );
    SH(it,ip,:) = Ti * squeeze( SbH(it,ip,:) );
  end 
end
  

% plot sigma1 in each gauss point
plot(EbH(:,:,4))