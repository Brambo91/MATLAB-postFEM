function items = getColumnItems(header)
% find column number in table written by jemjive
% arguments: table header and component name

% if a number is given, increment with 1 (for node number column)

iq = find(header=='"');

purged = header(iq(1)+1:iq(2)-1);
items = regexp(purged,'\w*\w','match');

