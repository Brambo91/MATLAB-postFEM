function useSlowGmshReader(arg)
% function to set global flag for using readGmshSlow
% give false argument to use standard readGmsh

global gmshSlow

if ( nargin < 1 )
  arg = 1;
end

gmshSlow = arg;

