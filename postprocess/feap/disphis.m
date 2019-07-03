function DH = disphis(iel)

disp('Nodal displacement evolution within an element')

if nargin<1
  disp('Input number of element as argument')
  return
end

%% load data

fclose('all');

load ix.dat
load coord.dat
fn = fopen('ndis.dat');
nodes = ix(iel,:);

% number of nodes
nn = length(coord);

% bits per line in ndis
l1 = fgetl(fn);
nbn = length(l1)+1;

% number of lines in ndis
fseek(fn, 0, 'eof');
nln = ftell(fn)/nbn;

% number of time steps
nt = nln/nn;

DH = zeros(nt,8,3);

for it=1:nt

  % read ndis for time step it
  for i = 1 : 8
    fseek( fn , nbn*(nn*(it-1)+nodes(i)-1) , 'bof' );
    DH(it,i,:) = str2num( fgetl(fn) ); %#ok<ST2NM>
  end

end


% close files
fclose(fn);

DH=reshape(DH,[nt 24]);

clf
plot(DH)