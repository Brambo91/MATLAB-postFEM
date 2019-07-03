function lodit(it,its)

clf
load zreac.dat
lzr = length(zreac);
if abs(zreac(2,3))>abs(zreac(2,1))
  zreac(:,1:2)=zreac(:,3:4);
end
zreac(:,2) = zreac(:,2)/1000;
if nargin<1
  plot([0;zreac(:,1)],[0;zreac(:,2)],'-x')
elseif nargin<2
  plot([0;zreac(:,1)],[0;zreac(:,2)],zreac(it,1),zreac(it,2),'b.')
else
  hold on
  box on
  plot([0;zreac(1:it,1)],[0;zreac(1:it,2)])
  plot(zreac(it:lzr,1),zreac(it:lzr,2),'b:')
%   plot(zreac(it:lzr,1),zreac(it:lzr,2),'color',[.8 .8 .8])
%   plot(zreac(its,1),zreac(its,2),'color',[.8 .8 .8],'linestyle','.')
  plot(zreac(it,1),zreac(it,2),'b.')
end

xlabel('u (mm)')
ylabel('F (kN)')
