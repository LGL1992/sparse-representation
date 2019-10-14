function [ t,f,coefs ] = time_frequency_transform_wavelet( signal,totalScal,fs,isPlot )
%time_frequency_transform_wavelet С���任ʱƵͼ
% input:
%     signal:�����ź�
%     totalScal:�߶�b
%     fs:����Ƶ��  
%     isPlot:�Ƿ���ͼ,1��ʾ��ͼ
%     
% output:
%     t:ʱ��
%     f:Ƶ��
%     coefs:ϵ��

wavename='cmor3-3';
Fc=centfrq(wavename); % С��������Ƶ��
c=2*Fc*totalScal;
scals=c./(1:totalScal);
f=scal2frq(scals,wavename,1/fs); % ���߶�ת��ΪƵ��
coefs = cwt(signal,scals,wavename); % ������С��ϵ��
t=0:1/fs:size(signal)/fs;

if(isPlot)
    figure()
    imagesc(t,f,abs(coefs));
    set(gca,'YDir','normal')
    colorbar;
    xlabel('ʱ�� t/s');
    ylabel('Ƶ�� f/Hz');
    title('С��ʱƵͼ');
end

end

