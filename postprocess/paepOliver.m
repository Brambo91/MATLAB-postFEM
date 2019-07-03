function OUT = paepOliver(gam,c,g12,limitH)
% compute nonlinear evolution of shear stress 
% following C. Oliver (Van der Meer et al., CST 2010)
% input: gam, c(length=4), G12; output: tau

% default input 

if ( nargin < 4 )
  limitH = 0.;
end

if ( nargin < 1 )
  error('paepOliver needs one input argument: gamma_max')
else
  if ( length(gam) == 1 )
    dd = [ 0:30 0 30:50 0 50:70 0 70:90 0 90:100 ]' / 100;
    gam = dd * gam;
  end
end

if ( nargin < 3 )
  c = zeros(4,1);
  assert(nargin~=2);
  old = pwd;
  try
    try
      found = findInPro('shear12')
    catch 
      found = '';
    end
    while ( isempty(found) )
      l = subdirNames;
      if ( length(l)==0 ) cd(old); error('no default information found'); end
      cd(l{1})
      try
        found = findInPro('shear12');
      catch 
        found = '';
      end
    end
    g12  = findInPro('shear12');
    c(1) = findInPro('c1');
    c(2) = findInPro('c2');
    c(3) = findInPro('c3');
    c(4) = findInPro('c4');
    cd(old)
  catch ex
    cd(old)
    rethrow(ex)
  end
end

% evaluate stress, first try

np = length(gam);

gamp = -log(1-.5*c(1)*c(2)*gam.^2)./c(2);
dam  = -log(1-c(3)*c(4)*gam)./c(4);

mgam(1) = 0;

for i = 2:np
  if ( gam(i) < mgam(i-1) )
    gamp(i) = gamp(i-1);
    dam (i) = dam (i-1);
    mgam(i) = mgam(i-1);
  else
    mgam(i) = gam(i);
  end
end

tau = (1-dam).*g12.*(gam-gamp);

% correct for perfect plasticity

pp = 0;
limitr = 1.;
for i = 2:np
  % if ( pp || ( tau(i) <= tau(i-1) && gam(i) > gam(i-1) ) )
  if ( pp || ( (tau(i)-tau(i-1))/(gam(i)-gam(i-1)) < limitH ) )
    pp = 1;
    dam (i) = dam (i-1);
    limitr = 1 - limitH / ( g12 * ( 1 - dam(i) ) );
    gamp(i) = gamp(i-1) + ( mgam(i) - mgam(i-1) ) * limitr;
  end
end
tau = (1-dam).*g12.*(gam-gamp);

plot(gam,tau)
ylim([0 max(tau)*1.2])

if nargout > 0
  OUT = [gam,tau];
end

