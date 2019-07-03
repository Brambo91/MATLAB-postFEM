function coords = getMicroLocation(filename)
% get global coordinates for this micromodel,
% supposing they are on the first line, between brackets
% Args: filename

if ( ~ischar(filename) )
  error('getMicroLocation needs a string as argument')
end

fid = fopen(filename);

line = fgetl(fid);

coords = str2num(regexp(line,'\[.*\]','match','once'));

fclose(fid);

