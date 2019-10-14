function [ t,f,coefs ] = time_frequency_transform_sfft( signal,window,noverlap,nfft,fs,isPlot )
%time_frequency_transform_wavelet С���任ʱƵͼ
% input:
%     signal:�����ź�
%     window:����С
%     noverlap:�ص���С
%     nfft:��ɢ����Ҷ�任����
%     fs:Ƶ��
%     isPlot:�Ƿ���ͼ,1��ʾ��ͼ
%     
% output:
%     t:ʱ��
%     f:Ƶ��
%     coefs:ϵ��


[coefs, f, t, p] = spectrogram(signal,window,noverlap,nfft,fs);

if(isPlot)
    imagesc(t,f,abs(coefs));
    set(gca,'YDir','normal')
    colorbar;
    xlabel('ʱ�� t/s');
    ylabel('Ƶ�� f/Hz');
    title('��ʱ����ҶʱƵͼ');
end

end

