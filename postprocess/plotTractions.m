function plotTractions

% plot tractions from tractions.dat. No args

figure(1)

%% per integration point


clf
load tractions.dat

% ylim([0 120])
% xlim([-0.01 0.03])

for i = min( tractions(:,2) ) : max( tractions(:,2) )
  hold on
  rs = find( tractions(:,2)==i );
  plot( tractions(rs,3) , tractions(rs,5) , 'b' , ...
        -tractions(rs,6) , -tractions(rs,8) , 'r' )
  xlim([-0.001 0.03])
  pause(.1)
end

hold off

%%

figure(2)

%% per time step

clf

for i=min( tractions(:,1) ) : max( tractions(:,1) )
  figure(2)
  hold off
  rs = find( tractions(:,1) == i );
  plot( tractions(rs,3), tractions(rs,5), '.', ...
...%         [0 0.024], [80 0], 'b', ...
        [0 0], [120 0], 'k', ...
        -tractions(rs,6), -tractions(rs,8), 'r.' )
  ylim([-10 120])
  xlim([-0.001 0.03])
  pause(.2)
end

