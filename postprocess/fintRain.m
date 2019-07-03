function fintRain
% plot development of internal force 

ffile = findFile('fint',1);

fFile = fopen(ffile);

eval(['!grep -b internal ' ffile ' > fpointers.dat'])

load fpointers.dat

for i = 1:size(fpointers,1)
  fseek(fFile,fpointers(i,1),'bof');
  fgetl(fFile);

  fintDat = fscanf(fFile,'%g %g %g %g %g %g %g',[7,inf])'; 

  clf
  semilogy(abs(fintDat(:,6)),'.')
  hold all
  semilogy(abs(fintDat(:,7)),'.')
  drawnow
end

fclose('all');
