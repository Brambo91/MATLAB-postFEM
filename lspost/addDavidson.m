function addDavidson(in,varargin)

% this function draws the crack front according to davidon90, Fig. 7
% argument: 0 or 45

if ischar(in)
  in = str2num(in);
end

if in == 45
  dat = [ 1.80282 0
          1.80551 0.125
          1.80953 0.25
          1.81839 0.375
          1.83385 0.5
          1.85239 0.625
          1.88809 0.75
          1.92952 0.875
          2       1    ];
elseif in == 00
  dat = [ 1.95775 0
          1.95824 0.125
          1.95918 0.25
          1.96055 0.375
          1.96237 0.5
          1.96638 0.625
          1.97436 0.75
          1.98454 0.875
          2       1    ];
else
  error('addDavidson needs input ''45'' or ''00''')
end

x = dat(:,1)*25.4;
y = dat(:,2)*25.4/2;

line(x,y,'color','k','linewidth',1,varargin{:})
