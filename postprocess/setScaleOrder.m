function setScaleOrder(value)
% set the order with which nodal data is scaled by the loadScale
% data <-- data * loadScale^order
% if order > 0, displacements scale linearly with the loadScale
% (that is not defined here, but in addOutTable and addPostTable)

global scaleOrder

scaleOrder = value;

