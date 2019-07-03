function xmlWriter(fid,type,name,data)

if ischar(fid)
  filename = fid
  fid = fopen(filename)
end

fprintf(fid,'\n<%s name="%s">\n',type,name);
nr = size(data,1);
nc = size(data,2);
for i = 1:nr
  fprintf(fid,' ');
  for j = 1:nc
    fprintf(fid,' %g',data(i,j));
  end
  fprintf(fid,';\n');
end
fprintf(fid,'</%s>\n\n',type);

