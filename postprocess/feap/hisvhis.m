function HH = hisvhis(iel,comp)

disp('History variable evolution within an element')

if nargin<1
  disp('Input number of element as argument')
  return
elseif nargin<2
  disp('Default component: 1')
  comp = 3;
else
  comp = comp+2;
end

%% load data

fclose('all');

load ix.dat
load coord.dat
fh = fopen('hisv.dat');
fn = fopen('ndis.dat');

% number of nodes
nn = length(coord);

% bits and words per line in hisv
l1 = fgetl(fh);
nbh = length(l1)+1;
nwh = length(str2num(l1)); %#ok<ST2NM>

% number of lines in hisv
fseek(fh, 0, 'eof');
nlh = ftell(fh)/nbh;

% bits and words per line in ndis
l1 = fgetl(fn);
nbn = length(l1)+1;
nwn = length(str2num(l1)); %#ok<ST2NM>

% number of lines in ndis
fseek(fn, 0, 'eof');
nln = ftell(fn)/nbn;

% number of time steps
nt = nln/nn;

% number of gauss points in hisv
np = nlh/nt;

% find line where information on iel starts
line1 = 0;
fseek(fh, 0, 'bof');
for ip = 1 : np
  lh = str2num( fgetl (fh) );
  if lh(1) == iel
    line1 = ip;
    break
  end
end
if line1 == 0
  disp('Element iel not in hisv.dat')
  return
end

HH = zeros(nt,8);

for it=1:nt

  % read hisv for time step it
  line = nbh*(np*(it-1)+line1-1);
  fseek( fh , line , 'bof' );
  
  for i = 1 : 8
    lh = str2num( fgetl(fh) ); %#ok<ST2NM>
%     lh(3) = 1 - lh(3);
    HH(it,i) = lh(comp);
  end

end

% close files
fclose(fh);
fclose(fn);

clf
plot(HH)