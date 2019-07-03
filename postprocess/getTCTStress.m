function [Gpeak,speak,tout] = getTCTStress
% get the crack propagation stress (and toughness) for a TCT specimen

try
  % get thickness from geom.m

  geom
  h = 2 * ( max(zs)-min(zs) );
  t = 2 * ( zs(find(diff(zs)==0,1,'first')) - min(zs) );
catch
  % get thickness from nodoubled.geo
  
  try 
    t = findInGeo('t');
    h = findInGeo('h');
  catch ex
    disp('searched for geom.m and *.geo but did not find suitable information')
    rethrow(ex)
  end
end



if abs(h/t-5) > 1.e-6
  warning(['ratio is not equal to 5, but rather: ' num2str(h/t)])
end

geomlist = dir('geom.m');
meshlist = dir('*.mesh');
if meshlist.datenum < geomlist.datenum
  warning(['need to run makemesh in ' pwd])
end

dl = DL;
[Fpeak,Fflat] = getLimitValues(dl);

E     = findInPro('young1');

speak = Fpeak / (h/2);
Gpeak = speak^2*h*t / ( 4*E*(h-t) );
sflat = Fflat / (h/2);
Gflat = sflat^2*h*t / ( 4*E*(h-t) );

if nargout > 2
  tout = t;
end

function [fpeak,fflat] = getLimitValues(dl)

dload = diff(dl(:,3));
ddiss = diff(dl(:,2));
rc = dload./ddiss;

if ( min(rc) < 0 )

  imax = find(rc<0,1,'first'); % first maximum
  imin = imax + find(rc((imax+1):end)>0,1,'first'); % minimum following maximum
  if ( isempty(imin) ) imin = size(dl,1); end
  fpeak = dl(imax,3);
  fflat = dl(imin,3);

else

  % in case there is no load drop: return value from flattest step 

  [~,iflat] = min(rc);
  fpeak = dl(iflat,3);
  fflat = fpeak;

end
  

