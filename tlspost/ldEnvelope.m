function OUT = ldEnvelope

load lodi.dat
load loadScale.dat

nt = min(size(loadScale,1),size(lodi,1));

out = zeros(nt+1,2);

for i = 1:nt
  if i > 1 && lodi(i,3) < 0.001*lodi(i-1,3)
    % remove post failure time step
    out = out(1:(i-1),:);
    break;
  end
  if isinf( loadScale(i,2) )
    out(i+1,:) = out(i,:);
  else
    out(i+1,:) = abs(lodi(i,2:3)) * loadScale(i,2);
  end
end

clf
plot(out(:,1),out(:,2),'color',dblue);

if nargout > 0
  OUT = out;
end

nameFig
