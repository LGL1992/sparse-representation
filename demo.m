clc;clear all;close all;
%% ������

fs=2000;                %����Ƶ��
total_time=1;           %����ʱ��
len=fs*total_time;   %��������
point=1:len;         %����������
t=point/fs;             %ʱ��

damp=0.05;              %����ϵ��
f_vibrate=300;          %��Ƶ��
t0=0.05;                %ʱ��
T=0.1;                  %�ź�����


while (t0-T>0)
    t0=t0-T;
end
sig_laplacewavelet=exp(-(damp/sqrt(1-damp^2))*2*pi*f_vibrate*t).*sin(2*pi*f_vibrate*t);
Wss=round(t0*fs);

A1=1;                   %��ֵ
A2=0.5;                 %��ֵ

sig=zeros(len,1);
for k=1:len
    if k<=Wss
        sig(k)=0;
    else
        sig(k)=A1*sig_laplacewavelet(k-Wss);
    end
end

count=0;
for i=1:len/(T*fs)
    Wss=round(T*fs*i+t0*fs);
    for k=1:len      
        if k>Wss
            if mod(count,2)==0
                sig(k)=sig(k)+A2*sig_laplacewavelet(k-Wss);
            else
                sig(k)=sig(k)+A1*sig_laplacewavelet(k-Wss);
            end
        end
    end
    count=count+1;
end

%% ��������
SNR=-3;
[signal,noise]=noisegen(sig,SNR);

figure()
subplot(2,1,1);
plot(t,sig);
title('��������ź�');
xlabel('ʱ�� t/s');
ylabel('��ֵ A(m/s^2)');
ylim([-1,1]);

subplot(2,1,2);
plot(t,signal);
title('�����ź�');
xlabel('ʱ�� t/s');
ylabel('��ֵ A(m/s^2)');
ylim([-1,1]);

%%
fouriorTransform(signal,fs,1);

%% ��ʱ����Ҷ
figure()
WINDOW = 128;
NOVERLAP = 120;
NFFT = 256;
% MINDB = 20;
% [B, F, T, P] = spectrogram(signal,WINDOW,NOVERLAP,NFFT,fs);
% imagesc(T,F,abs(B));
% set(gca,'YDir','normal')
% colorbar;
% xlabel('ʱ�� t/s');
% ylabel('Ƶ�� f/Hz');
% title('��ʱ����ҶʱƵͼ');

time_frequency_transform_sfft(signal,WINDOW,NOVERLAP,NFFT,fs,1);


%% С�� ʱƵͼ
% totalscal=256;
% wavename='cmor3-3';
% Fc=centfrq(wavename); % С��������Ƶ��  ���Fc = 3
% c=2*Fc*totalscal;    % ���c = 1536
% scals=c./(1:totalscal);
% f=scal2frq(scals,wavename,1/fs); % ���߶�ת��ΪƵ��
% coefs = cwt(signal,scals,wavename); % ������С��ϵ��
% t=0:1/fs:size(signal)/fs;
% figure()
% imagesc(t,f,abs(coefs));
% set(gca,'YDir','normal')
% colorbar;
% xlabel('ʱ�� t/s');
% ylabel('Ƶ�� f/Hz');
% title('С��ʱƵͼ');

time_frequency_transform_wavelet(signal,256,fs,1);


