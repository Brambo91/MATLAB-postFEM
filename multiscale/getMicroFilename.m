function filename = getMicroFilename ( imicro )
% get file name corresponding to i^th micromodel
% argument: imicro

pattern = ['*micro' num2str(imicro) '.dat'];
candidates = dir(pattern);
if ( length(candidates)>1 )
  error('multiple candidate files found')
elseif ( isempty(candidates) )
  error(['no file found with pattern `' pattern ''''])
end
filename = candidates.name;



