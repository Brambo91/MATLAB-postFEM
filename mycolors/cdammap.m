function cdammap
% bonemap like map from blue-gray to white, nice for continuum damage

%%


cm = [
    0.3686    0.3922    0.4941
    0.3772    0.4039    0.5027
    0.3857    0.4156    0.5112
    0.3943    0.4274    0.5198
    0.4029    0.4391    0.5283
    0.4114    0.4508    0.5368
    0.4200    0.4625    0.5454
    0.4286    0.4743    0.5539
    0.4371    0.4860    0.5625
    0.4457    0.4977    0.5710
    0.4542    0.5095    0.5796
    0.4628    0.5212    0.5881
    0.4714    0.5329    0.5967
    0.4799    0.5447    0.6052
    0.4885    0.5564    0.6138
    0.4970    0.5681    0.6223
    0.5056    0.5799    0.6308
    0.5142    0.5916    0.6394
    0.5227    0.6033    0.6479
    0.5313    0.6151    0.6565
    0.5398    0.6268    0.6650
    0.5484    0.6385    0.6736
    0.5570    0.6503    0.6821
    0.5655    0.6620    0.6907
    0.5741    0.6737    0.6992
    0.5827    0.6855    0.7078
    0.5912    0.6972    0.7163
    0.5998    0.7089    0.7248
    0.6083    0.7207    0.7334
    0.6169    0.7324    0.7419
    0.6255    0.7441    0.7505
    0.6340    0.7558    0.7590
    0.6426    0.7676    0.7676
    0.6537    0.7748    0.7748
    0.6649    0.7821    0.7821
    0.6761    0.7894    0.7894
    0.6873    0.7966    0.7966
    0.6984    0.8039    0.8039
    0.7096    0.8112    0.8112
    0.7208    0.8184    0.8184
    0.7319    0.8257    0.8257
    0.7431    0.8329    0.8329
    0.7543    0.8402    0.8402
    0.7654    0.8475    0.8475
    0.7766    0.8547    0.8547
    0.7878    0.8620    0.8620
    0.7990    0.8693    0.8693
    0.8101    0.8765    0.8765
    0.8213    0.8838    0.8838
    0.8325    0.8911    0.8911
    0.8436    0.8983    0.8983
    0.8548    0.9056    0.9056
    0.8660    0.9128    0.9128
    0.8771    0.9201    0.9201
    0.8883    0.9274    0.9274
    0.8995    0.9346    0.9346
    0.9106    0.9419    0.9419
    0.9218    0.9492    0.9492
    0.9330    0.9564    0.9564
    0.9442    0.9637    0.9637
    0.9553    0.9709    0.9709
    0.9665    0.9782    0.9782
    0.9777    0.9855    0.9855
    0.9888    0.9927    0.9927
    1.0000    1.0000    1.0000
];

colormap(cm)
