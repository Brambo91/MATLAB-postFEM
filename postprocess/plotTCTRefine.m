function OUT = plotTCTRefine
% plot maximum stress as a function of mesh size 
    % NB: assuming relevant peak is in first 100 steps
% assuming this path contains subdirectories with different simulations
% where the mesh size has been varied
% output: out with out(:,1)=dx, out(:,2)=Gpeak

if nargin < 1
  p = pwd;
end

old = pwd;

l   = subdirNames(p);
n   = length(l);
out = zeros(n,2);

if n == 0
  disp('no subdirectories found, nothing to plot.')
end

for i=1:n

  try
    cd(l{i})
    fprintf('plotSizeEffect: analyzing data [...]/%s\n',getDirName(2,l{i}))
    try
      out(i,1) = findInGeo('fi');
      h        = findInGeo('h');
      dl       = DL;
      % NB: assuming relevant peak is in first 100 steps
      if ( size(dl,1) > 100 )
        out(i,2) = max(dl(1:100,3));
      else
        out(i,2) = max(dl(:,3));
      end
    catch ex
      out(i,2) = NaN;
      cd(old)
      rethrow(ex)
    end
  catch err
    cd(old)
    rethrow(err)
  end

end
cd(old)


out = sortrows(out);
plot(out(:,1),out(:,2),'.-','color',dblue);

if nargout > 0
  OUT = out;
end

nameFig
