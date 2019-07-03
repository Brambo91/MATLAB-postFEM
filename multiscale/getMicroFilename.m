function filename = getMicroFilename ( imicro )
% get file name corresponding to i^th micromodel
% argument: imicro, folder

global fPath

if( isempty(fPath) ) %Bram
   fPath = './'; 
end %Bram

%pattern = [ '*micro' num2str(imicro) '.dat' ]; %Commented
pattern = [fPath '*micro' num2str(imicro) '.dat']; %Bram

candidates = dir(pattern);
if ( length(candidates)>1 )
  error('multiple candidate files found')
elseif ( isempty(candidates) )
  error(['no file found with pattern `' pattern ''''])
end

%filename = candidates.name; %Commented
filename = [fPath candidates.name]; %Bram
