function [ f,q ] = fouriorTransform( sig,fs,isPlot)
%fouriorTransform �˴���ʾ�йش˺�����ժҪ
%   ˵�������źŽ��п��ٸ���Ҷ�任������ͼ
% input:
%     sig:�����ź�
%     fs:����Ƶ��
%     isPlot:�Ƿ�ͼ��1Ϊ�ǣ�0Ϊ��
%     
% output:
%     f:Ƶ��ͼƵ�ʷ�Χ
%     q:��Ƶ�ʷ���
%     
% e.g.:
%     [f,q]=fouriorTransform(sig,10240,1);


%%
[ ~,nfft]=size(sig');
f=(0:nfft/2-1)/nfft*fs;
q=abs(fft(sig,nfft))/(nfft/2);
q=q(1:nfft/2);

if(isPlot)
    figure();
    plot(f,q(1:nfft/2));grid on;
    title('ԭʼ����Ƶ��ͼ');
    xlabel('Ƶ�� Hz');
    ylabel('��ֵ A(m/s^2)');
end

end

