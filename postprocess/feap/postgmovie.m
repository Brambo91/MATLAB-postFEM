function postgmovie

j=0;
its = 4:4:lzr;
for i=its
  j=j+1;
  disp(['postgmovie ' num2str(j) ' of ' num2str(length(its))]);
  figure(1)
  lodit(i)
  figure(2)
  pg(i,2)
  refresh
  F(j)=getframe;
end

assignin('base','F',F);

% consider saving the movie with the command:
% % save('movie.mat','F')
