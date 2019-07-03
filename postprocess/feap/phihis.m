function PH=phihis(iel)

disp('Phi evolution in damage element')
disp('Are strength parameters in phihis.m correct?')

% only for theta=0 !!!

F1t = 2280;
F1c = 1725;
F2t = 76;
F2c = 228;
F6 = 76;
F4=sqrt(F2t*F2c/3);                               %  Tsai Wu

SH = strehis(iel);

nt = size(SH,1);

PH = zeros(nt,8,4);

for it=1:nt
  for ip=1:8
    
    sige = squeeze(SH(it,ip,:));

    f1t = sige(1)/F1t;
    f1c = -sige(1)/F1c;

    phi2 = (sige(5)^2-sige(2)*sige(3))/F4^2 + (sige(4)^2+sige(6)^2)/F6^2;
    f2t = (sige(2)+sige(3))^2/F2t^2 + phi2;
    f2c = ((F2c/2/F4)^2-1)*(sige(2)+sige(3))/F2c + (sige(2)+sige(3))^2/4/F4^2 + phi2;
    
    phi = zeros(2,1);
    event = zeros(2,1);

    [phi(1),event(1)] = max([f1t,f1c]);
    [phi(2),event(2)] = max([f2t,f2c]);    % different from hashin80 and dhash.f: pick maximum
    if phi(2)>0
      phi(2) = sqrt(phi(2));
    end
    
    PH(it,ip,1) = phi(1);
    PH(it,ip,2) = phi(2);
    PH(it,ip,3) = event(1);
    PH(it,ip,4) = event(2);

  end

end

plot(PH(:,:,1))
