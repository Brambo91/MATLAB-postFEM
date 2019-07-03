function rwbmap(small)
% define red-white-blue colormap
% give argument to center around 0

if ( nargin > 0 )
  old=caxis;
  val=max(abs(caxis));
  val=max(val,small);
  caxis([-val val])
end

%%


cm = [
         0         0    0.4549
         0         0    0.4890
         0         0    0.5230
         0         0    0.5571
         0         0    0.5912
         0         0    0.6252
         0         0    0.6593
         0         0    0.6934
         0         0    0.7275
         0         0    0.7615
         0         0    0.7956
         0         0    0.8297
         0         0    0.8637
         0         0    0.8978
         0         0    0.9319
         0         0    0.9659
         0         0    1.0000
    0.0625    0.0625    1.0000
    0.1250    0.1250    1.0000
    0.1875    0.1875    1.0000
    0.2500    0.2500    1.0000
    0.3125    0.3125    1.0000
    0.3750    0.3750    1.0000
    0.4375    0.4375    1.0000
    0.5000    0.5000    1.0000
    0.5625    0.5625    1.0000
    0.6250    0.6250    1.0000
    0.6875    0.6875    1.0000
    0.7500    0.7500    1.0000
    0.8125    0.8125    1.0000
    0.8750    0.8750    1.0000
    0.9375    0.9375    1.0000
    1.0000    1.0000    1.0000
    1.0000    0.9412    0.9412
    1.0000    0.8824    0.8824
    1.0000    0.8235    0.8235
    1.0000    0.7647    0.7647
    1.0000    0.7059    0.7059
    1.0000    0.6471    0.6471
    1.0000    0.5882    0.5882
    1.0000    0.5294    0.5294
    1.0000    0.4706    0.4706
    1.0000    0.4118    0.4118
    1.0000    0.3529    0.3529
    1.0000    0.2941    0.2941
    1.0000    0.2353    0.2353
    1.0000    0.1765    0.1765
    1.0000    0.1176    0.1176
    1.0000    0.0588    0.0588
    1.0000         0         0
    0.9626         0         0
    0.9252         0         0
    0.8878         0         0
    0.8505         0         0
    0.8131         0         0
    0.7757         0         0
    0.7383         0         0
    0.7009         0         0
    0.6635         0         0
    0.6261         0         0
    0.5888         0         0
    0.5514         0         0
    0.5140         0         0
    0.4766         0         0
    0.4392         0         0
];

  colormap(cm)
