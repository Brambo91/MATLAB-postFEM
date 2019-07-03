function nmodels = getNModels

i = 0;
filename = ' ';

while 1
  i = i + 1;
  try 
    % filename = findFile('cracks',i);
    filename = findFile('elems',i);
  catch
    break
  end
end

nmodels = i - 1;
