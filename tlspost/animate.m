function animate(its,command)

for i=its
  eval(command)
  drawnow
end
