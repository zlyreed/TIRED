function [H2Lratio,H2Mratio,M2Lratio,areaL,areaM,areaH]=HLpowerRatio(f,pxx)

% f: a frequency vector, f
% pxx: periodogram power spectral density (PSD)
% lower frequency (15-45Hz), mid (45-95Hz)and high (>95 Hz and <450Hz)

indL=find(f>15&f<45);
areaL=0;
for nL=1:length(indL)-1
    k=indL(nL);
    areaL=areaL+0.5*(f(k+1)-f(k))*(pxx(k+1)+pxx(k));
end
clear k
    


indM=find(f>=45&f<95);
areaM=0;
for nM=1:length(indM)-1
    k=indM(nM);
    areaM=areaM+0.5*(f(k+1)-f(k))*(pxx(k+1)+pxx(k));
end
clear k


indH=find(f>=95&f<450);
areaH=0;
for nH=1:length(indH)-1
    k=indH(nH);
    areaH=areaH+0.5*(f(k+1)-f(k))*(pxx(k+1)+pxx(k));
end
clear k


H2Lratio=areaH/areaL;
H2Mratio=areaH/areaM;
M2Lratio=areaM/areaL;


    
    

