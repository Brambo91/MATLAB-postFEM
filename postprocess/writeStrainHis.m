function writeStrainHis ( filename, ip, imodel )
% this function writes the strain history to a file
% strain data is extracted from *.locOut and written in XML format
% strain functions can subsequently be read by jive::app::InputModule
% arguments: filename [strainhis.data], ip [1], imodel [1]

if ( nargin < 3 )
  imodel = 1;
end
if ( nargin < 2 )
  ip = 1;
end
if ( nargin < 1 )
  filename = 'strainhis.data';
end

dat = getLocOutput ( ip, imodel );

nt = size(dat,1);
strCount = floor(size(dat,2)/2);
state = '';
dim = 3;

if strCount == 3
  dim = 2;
  state = findInPro('state',imodel);
end

strains = {'strain_xx';'strain_yy';'strain_zz';'strain_xy';'strain_yz';'strain_zx'};

for i = 1:strCount
  strainHis{i} = dat(:,i);
end

if dim == 2
  if strcmp(state,'"PLANE_STRESS"')
    % remove zz strain in case of plane stress (this component is unknown)
    strains = strains{[1,2,4,5,6]};
  else
    % reorder to keep xy before zz 
    strains = strains([1,2,4,3,5,6]);
  end
end
    
for i = strCount+(1:(length(strains)-strCount))
  % fill zero strain components
  strainHis{i} = [0;0];
end

strCount = length(strains);

fid = fopen(filename,'w');

for i = 1:strCount
  if ( length(strainHis{i}) == 2 )
    its = [1,nt];
  else
    assert(length(strainHis{i})==nt);
    its = 1:nt;
  end
  dat = [its',strainHis{i}];
  xmlWriter(fid,'Function',strains{i},dat);
end
fclose(fid);

