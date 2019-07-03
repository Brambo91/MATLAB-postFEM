function OUT = plotSizeEffect(p)
% plot toughness as a function of thickness (using getTCTStrength)
% assuming this path contains subdirectories with different simulations
% where the thickness has been varied
% input: path, output: out with out(:,1)=dx, out(:,2)=Gpeak, out(:,3)=Gflat

if nargin < 1
  p = pwd;
end

old = pwd;

l   = subdirNames(p);
n   = length(l);
out = zeros(n,3);

if n == 0
  disp('no subdirectories found, nothing to plot.')
end

for i=1:n

  try
    cd(l{i})
    fprintf('plotSizeEffect: analyzing data [...]/%s\n',getDirName(2,l{i}))
    try
      [out(i,2),out(i,3),out(i,1)] = getTCTStress;
    catch ex
      warning('something went wrong with getTCTStress')
      out(i,2) = NaN;
      out(i,3) = NaN;
      rethrow(ex)
    end
    cd(old)
  catch err
    cd(old)
    rethrow(err)
  end

end


if 1 % ( max(mod(out(:,1),0.127)) < 1.e-8 )
  out(:,1) = out(:,1)/0.127;
end

out = sortrows(out);
plot(out(:,1),out(:,2),'.-','color',dblue);
hold on
% plot(out(:,1),out(:,3),'.-r');
hold off

if nargout > 0
  OUT = out;
end

nameFig
