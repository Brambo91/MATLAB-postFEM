function npp=nplaspts
% compute number of plastic gpoints / total number of pts, per time step
% (hisv(4)==fevent)

disp('NB: Is hh the same as in the FEAP input file?')
hh = -.1; % !!! NB: material parameter !!!

load hisv.dat
nels = max(hisv(:,1));
np = nels*8;
nt = length(hisv)/np;

npp = zeros(1,nt);

% check state
hisv(:,5) = hisv(:,3) > 1+hh*hisv(:,4) + 1e-10;

for it=1:nt
  line0 = (it-1) * np;
  npp(it) = sum(hisv(line0+(1:np),5)) / np;
end


load zreac.dat

clf
plot(zreac(:,1),npp)
xlabel('u')
ylabel('rel. number of plastic elements')
ylim([0 1.2])
