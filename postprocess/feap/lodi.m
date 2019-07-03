figure(1)
clf
load zreac.dat
if abs(zreac(2,3))>abs(zreac(2,1))
  zreac(:,1:2)=zreac(:,3:4);
end
plot([0;zreac(:,1)],[0;zreac(:,2)]/1000,'.-')

zreac(1,3)=zreac(1,1);
zreac(1,4)=zreac(1,2)/zreac(1,1);
for i=2:size(zreac,1)
  zreac(i,3)=zreac(i,1)-zreac(i-1,1);
  zreac(i,4)=(zreac(i,2)-zreac(i-1,2))/zreac(i,3);
end

set(gca,'fontsize',7)
xlabel('u')
ylabel('F')
set(gcf,'paperposition',[0 0 4 3])
