
function grayEnvelope ( data )
% draws gray band around data cloud
% input: nx2 matrix with n points of (x,y)-data

[low,up] = envelopeX(data)
upinv = length(up):-1:1);

x = [ low(:,1) ; up(upinv,1) ];
y = [ low(:,2) ; up(upinv,2) ];

patch(x,y,'facecolor',[.7 .7 .7],'edgecolor','none')



