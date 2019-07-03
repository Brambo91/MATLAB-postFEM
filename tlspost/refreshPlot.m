function refreshPlot(func,interval,wait)
% for continuous plotting of data that is being generated
% args 1. function handle (e.g. @postTLS)
%      2. wait time for new info in *.log to find end of job [9999]
%      3. wait time to look again for fresh time step data [.01]

if nargin < 3
  wait = .01;
end
if nargin < 2
  interval = 9999.;
end

h = gcf;

nt = getNT;

while ( running(interval,'*.log') )

  it = nt;
  func(it)
  drawnow;

  while ( it == nt )
   
    pause(wait);

    if ishandle(h)
      set(0,'currentfigure',h)
    else
      fprintf('\nFigure closed. Exiting refreshPlot\n')
      return
    end

    try
      % this fails if the lodi.dat is written to exactly now
      nt = getNT;
    end

  end

end

