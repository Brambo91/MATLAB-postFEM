function truncdat(nt)

disp('Truncate .dat files in current directory')
disp('Initial number of time steps:')
nt1 = lzr;

if nargin<1
  disp('Input new number of time steps as argument')
  return
elseif nt>nt1
  disp('Invalid input! This is not a data extrapolation routine.')
  return  
else
  disp('Files will be changed irrevocably!')
  proceed = input('Press ''y'' to continue. ','s');
  if proceed ~= 'y'
    return
  end
end

load ix.dat
fh = fopen('hisv.dat');

% number of nodes
load coord.dat
nn = length(coord);

% bits per line in hisv
l1 = fgetl(fh);
nbh = length(l1)+1;

% number of lines in hisv
fseek(fh, 0, 'eof');
nlh = ftell(fh)/nbh;

% number of gauss points in hisv
np = nlh/nt1;

if mod(np,1) ~=0
  disp('no integer number of points, something''s wrong');
  return
end

nln = nn*nt;
nlh = np*nt;


disp('This may take a while...')

str = ['!sed -n 1,' int2str(nt) 'p zreac.dat > zreac.tmp'];
eval(str);
!mv zreac.tmp zreac.dat
disp('Truncated zreac.dat')

str = ['!sed -n 1,' int2str(nln) 'p ndis.dat > ndis.tmp'];
eval(str);
!mv ndis.tmp ndis.dat
disp('Truncated disp.dat')

str = ['!sed -n 1,' int2str(nlh) 'p hisv.dat > hisv.tmp'];
eval(str);
!mv hisv.tmp hisv.dat
disp('Truncated hisv.dat')

if exist('intf.dat','file')
  fi = fopen('intf.dat');

  % bits per line in intf
  l1 = fgetl(fi);
  nbi = length(l1)+1;
  
  % number of lines in hisv
  fseek(fi, 0, 'eof');
  nli = ftell(fi)/nbi;

  ni = nli/nt1;
  nli = ni*nt;

  str = ['!sed -n 1,' int2str(nli) 'p intf.dat > intf.tmp'];
  eval(str);
  !mv intf.tmp intf.dat
  disp('Truncated intf.dat')
  
end
