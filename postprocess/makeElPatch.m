function h = makeElPatch(coords,data,conn)
% plot mesh with element quantities 
% args: coords, data, connectivity
% where data is a vector with element values

%% get global variables or default values

global pxLW

if ( isempty(pxLW) )
  lw = .1;
else
  lw = pxLW;
end

nn = size(conn,2);
rank = size(coords,2);

midnodes = ( nn == 6 && rank == 2 );
if ( midnodes )
  v = [1 2 6 1 ; 3 4 2 3; 5 6 4 5 ; 2 4 6 2]';
  v0 = [ 1:6, 1];
  % conn = conn(:,[1 4 2 5 3 6]);
elseif ( nn == 3 )
  v = [1 2 3 1];
else
  v = 1:nn;
end

nel = size(conn,1);
x = reshape ( coords(conn,1), size(conn) );
y = reshape ( coords(conn,2), size(conn) );

assert ( length(data) == nel );

if ( rank > 2 )
  z = reshape ( coords(conn,3), size(conn) );
  % subconnectivity of faces (for 3d)
  np2 = nn/2;
  vbot = 1:np2;
  vtop = np2+1:nn;
  for iface = 1:np2;
    n1 = mod(iface,np2)+1;
    vside(iface,:) = [ iface , n1 , n1+np2 , iface+np2  ];
  end
end

%% make plot

if lw
  set(gca,'defaultpatchlinewidth',lw)
else
  set(gca,'defaultpatchedgecolor','none')
end
set(gca,'defaultpatchfacecolor','interp')

if midnodes
  xv = reshape(x(:,v)',4,nel*4)';
  yv = reshape(y(:,v)',4,nel*4)';
  tmp = patch(xv',yv',data,'edgecolor','none');
  hold on
  if ( lw ) 
    patch(x(:,v0)',y(:,v0)',0.,'linewidth',lw,'facecolor','none'); 
  end
else
  if ( rank == 2 )
    tmp = patch(x(:,v)',y(:,v)',data);
  else
    tmp = patch(x(:,vbot)',y(:,vbot)',z(:,vbot)',data);
    patch(x(:,vtop)',y(:,vtop)',z(:,vtop)',data);
    for iface = 1:size(vside,1)
      v = vside(iface,:);
      patch(x(:,v)',y(:,v)',z(:,v)',data);
    end   
  end
end

inan = isnan(data);
if ( ~lw && any(inan) )
  if ( rank == 2 )
    h2 = patch(x(inan,:)',y(inan,:)',data(inan)); 
  else
    h2 = patch(x(inan,:)',y(inan,:)',z(inan,:)',data(inan));
  end
  % set(h2,'edgecolor','k','linewidth',.1)
  set(h2,'facecolor',[.7 .7 .7])
end

if nargout > 0
  h = tmp;
end

