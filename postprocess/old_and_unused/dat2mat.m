function dat2mat(name)

% convert ascii interface data file to .mat-file. Arg: name (without extension)

disp('dat2mat: converting interface data to .mat-file')
if nargin < 1
  disp('give filename (without extension) as input')
  return
end

%% initialize

tic

datfilename = [name '.dat'];
matfilename = [name '.mat'];

fi = fopen(datfilename);

% read first line which says 'coordinates' 
line0 = fgetl(fi);
if ( ~strcmp(line0,'ipCoords') )
  disp('is this an interface output file?')
  return
end

% read second line which has the rank;
rank = str2double(fgetl(fi));

%% read coordinates (hopefully newton-cotes integration!)

if exist(matfilename,'file')

  load(matfilename,'coords')
  nel = max(coords(:,1))+1;
  np = max(coords(:,2))+1;
  if np*nel ~= length(coords)
    disp('something''s wrong! is number of ip''s per element constant?')
  end
%   x = reshape(coords(:,3),np,nel)';
%   y = reshape(coords(:,4),np,nel)';
  disp('Coordinates have been loaded (mat). ')
  toc

else

  ip = 0;
  while 1
    ip = ip+1;
    line = fgetl(fi);
    if ~ischar(line) || line(1) == 'n',   break,   end
    coords(ip,:) = str2num(line);   %#ok<ST2NM>
  end

  nel = max(coords(:,1))+1;
  np = max(coords(:,2))+1;
  if np*nel ~= length(coords)
    disp('something''s wrong! is number of ip''s per element constant?')
  end
%   x = reshape(coords(:,3),np,nel)';
%   y = reshape(coords(:,4),np,nel)';
  disp('Coordinates have been read (dat). ')
  toc
  save(matfilename,'coords')
  disp(['Coordinates have been stored in ' matfilename])
  toc
  
end

%% read data from correct time step

% find pointers to time step data and number of time steps

disp(['Storing data per timestep in ' matfilename])

eval(['!grep -b new ' datfilename ' > ipointers.dat'])
load ipointers.dat
!rm ipointers.dat
nt = length(ipointers);

for it = 1:nt

  disp([num2str(it) ' of ' num2str(nt)])

  varname = ['idata' num2str(it)];
  

  warning off MATLAB:load:variableNotFound
  load(matfilename,varname)

  if ~exist(varname,'var')

    % jump to correct position

    fseek(fi,ipointers(it),'bof'); fgetl(fi);

    % read data

    c = zeros(nel,np,7);

    for iel = 1:nel

      for ip = 1:np
        line = str2num( fgetl(fi) ); %#ok<ST2NM>
        c(iel,ip,:) = line(3:9);
      end

    end

    str = [varname '=c;'];
    eval(str)
    save(matfilename,varname,'-append')
    str = ['clear ' varname];
    eval(str)

  end
end

disp('Done.')
toc

