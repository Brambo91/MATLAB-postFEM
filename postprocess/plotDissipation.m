function out=plotDissipation(its)

% get data
global prepend

if ~isempty(prepend)
  fid = fopen([prepend '.dissipation.dat']);
  disp(prepend)
  eval(['lodi = ' prepend ';'])
else
  fid = fopen('dissipation.dat');
end

str = fgetl(fid);
names = regexp(str, '\w*\w*', 'match');

values = fscanf(fid, '%g' ,[length(names),inf])';

if nargin < 1
  its = 1:size(values,1);
end
nm = size(values,2);

% values = [zeros(1,nm);values];

% make plots

if ( nm > 1 )
  colors = get(gca,'colororder');
  nc = size(colors,1);
  set(gcf,'defaultAxesLineStyleOrder','-|--|:')

  clf
  hold all

  for im = 1:nm-1
  %   plot(values(:,nm),values(:,im),'color',colors(mod(im-1,nc)+1,:),'linestyle',ls)

    icol = names{im}(regexp(names{im},'[0-9]'))+1;
    lw = .5;
    if ( regexp(names{im},'\w*[XBM]') ) % either X, B or M
      ls = ':';
      lw = 2;
    elseif ( regexp ( names{im}, '\w*S' ) )
      ls = '-.';
    elseif ( regexp ( names{im}, 'interface.' ) )
      ls = '--';
    else
      ls = '-';
    end
  %   if ( icol )
    if 0
      plot(values(its,nm),values(its,im),'color',colors(mod(icol,nc)+1,:),...
        'linestyle',ls,'linewidth',lw)
    else
      plot(values(its,nm),values(its,im))
    end

  end

  set(gcf,'defaultAxesLineStyleOrder','-')

  set(gcf,'paperposition',[0 0 3 2])
  set(gca,'fontsize',8)

  gcl=legend(names(1:nm-1),2);
  set(gcl,'fontsize',8)

  xlabel('total dissipation')
  ylabel('dissipation per model')

  assignin('base','dissipation',values)
  assignin('base','models',names)

  nameFig
end

fclose(fid);

if nargout > 0
  out = values;
end
