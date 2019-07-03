cd ~/tmpres
!rm I* O* R* *.m
!tar -zxvf new.tgz
!rm lodi.m

if exist('Ioffd','file') || exist('Ioffp','file')
  !cp ~/feap_new/main/input/offaxis/D3f/postg_settings.m .
elseif exist('Iyang3dd','file') || exist('Iyang3ds','file')
  !cp ~/feap_new/main/input/yang3ress/postg_settings.m .  
end

lodi

pg
