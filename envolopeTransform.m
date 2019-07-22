function [ f,p ] = envolopeTransform( sig,fs,isPlot )
%UNTITLED7 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% input:
%     sig:�����ź�,������
%     fs:����Ƶ��
%     isPlot:�Ƿ�ͼ��1Ϊ�ǣ�0Ϊ��
%     
% output:
%     f:������Ƶ�ʷ�Χ
%     q:��Ƶ�ʷ���
%     
% e.g.:
%     [f,p]=envolopeTransform(sig,10240,1);

%%
[sig_rows,sig_columns] = size(sig);  
    if sig_rows<sig_columns  
        sig = sig';            %y should be a column vector  
    end  



[ ~,nfft]=size(sig');
f=(0:nfft/2-1)/nfft*fs;

y=abs(hilbert(sig));
p=abs(fft(y,nfft))/(nfft/2);
p=p(1:nfft/2);


if(isPlot)
    figure();
    plot(f,p);grid on;
    title('������ͼ');
    xlabel('Ƶ�� Hz');
    ylabel('��ֵ A(m/s^2)'); 
end


end

