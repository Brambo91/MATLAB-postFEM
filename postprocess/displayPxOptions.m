function displayPxOptions

disp('use setPxOption with one of these values as argument');
disp('  0 ... plot shear nonlinearity');
disp('  1 ... plot fiber damage');
disp(' [2]... plot equivalent matrix stress');
disp('  3 ... give each layer it''s own color');
disp('  4 ... give each layer it''s own color and make cracked elems darker');
disp('        (currently not working)');
disp('  5 ... plot u_z (only for 3d)');
disp('  6 ... matrix damage')
disp('  7 ... plot u_x')
disp('  8 ... plot u_y')
disp('  9 ... plot lagrange multiplier');
disp(' 13 ... combination of 1 and 3');
disp('')

global pxOption

if isempty(pxOption)
  disp('  currently not set')
else
  disp(['  current value: ' num2str(pxOption)])
end


