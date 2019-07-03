function val = findInGeo(name,i)
% this function finds the value of a variable in a geo file
% input: name, i
% value specified for i^th occurrance of 'name' is returned
% only the first *.geo file in the directory is used
% returns a double if possible, otherwise a string

try
  filename = ls('*.geo');
catch
  error(['no *.geo file found in directory ' pwd])
end

fh = fopen(strtok(filename));

% read file as one long string without white space and line breaks
contents = fscanf(fh,'%s',[Inf]); 

% find match
expr = [name '=[^;]*'];
[i1,i2] = regexp(contents,expr);
offset = length(name)+1;

if nargin < 2
  i = 1;
else
  if i < 1
    error('second argument should be > 0')
  end
end

% read value
if length(i1)>=i
  j1 = i1(i)+offset;
  j2 = i2(i);
  strOut = contents(j1:j2);
else
  if ( i == 1 )
    disp(['variable ' name ' not found in ' filename])
  else
    n = num2str(i);
%     disp(['variable ' name ' not found ' n ' times in ' filename])
  end
  strOut = '';
end

number = str2double(strOut);

if isnan(number)
  val = strOut;
else
  val = number;
end

fclose(fh);
