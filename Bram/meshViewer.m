function meshViewer(file)

% Reads and plots mesh data from gmsh file
% Currently only triangle elements are supported
% argument: filename
% default: first file in this directory that matches *.msh


%clc; close all; clear all;

%-----------------------------------------------------------------------%
% dlmread(filename,delimiter,[R1 C1 R2 C2]) reads only the range 
% bounded by row offsets R1 and R2 and column offsets C1 and C2.
%-----------------------------------------------------------------------%
%file    =  'bone.msh'; %('your GMsh file in .msh format');

% no of nodes is mentioned in 5th row and first column

N_n      = dlmread ( file,'',[ 4     0  4          0 ] );
N_e      = dlmread ( file,'',[ 7+N_n 0  7+N_n      0 ] );
nodes    = dlmread ( file,'',[ 5     0  4+N_n      3 ] );
elements = dlmread ( file,'',[ 8+N_n 0  7+N_n+N_e  7 ] );

% find the starting indices of 2D elements

two_ind = 1;
for i = 1:N_e
    if(elements(i,2) ~= 2) % elem_type ~= triangle
        two_ind = two_ind+1;
    end
end

elements2d(1:N_e-two_ind,1:3) = 0;
k = 1;
for i = two_ind:N_e
   elements2d(k,1:3) = elements(i,6:8);
   k = k+1;
end

% Plot mesh

Xmin = min(nodes(:,2));
Xmax = max(nodes(:,2));
Ymin = min(nodes(:,3));
Ymax = max(nodes(:,3));
dX   = Xmax * 0.1;
dY   = Ymax * 0.1;

Lmin = min( [ Xmin-dX; ...
              Ymin-dY ] );
Lmax = max( [ Xmax+dX; ...
              Ymax+dY ] );

offsetY = 0;

figure;
hold on;
axis ( [ Lmin Lmax Lmin Lmax ] );
for i = 1:length(elements)
    N1 = elements2d ( i, 1 );
    N2 = elements2d ( i, 2 );
    N3 = elements2d ( i, 3 );
    
    X = [ nodes(N1,2); ...
          nodes(N2,2); ...
          nodes(N3,2) ];
      
    Y = [ nodes(N1,3)+offsetY; ...
          nodes(N2,3)+offsetY; ...
          nodes(N3,3)+offsetY ];
      
    fill(X,Y,'b');
end
hold off;

