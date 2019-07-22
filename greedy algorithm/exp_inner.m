clc;clear all;close all;
%% ʵ���о� �������õ��Գ���
% �汾1�� W_step=3;           %ͨ������Ϊ3  ts=3;               %����ϵ��


% load '��������1����ͨ��4.mat';
% load '�����Ȧ1x0.5����ͨ��4.mat';
fs=10240;   %����Ƶ�ʣ��ֶ�����
total_t=0.5;   %����ʱ��   �����Լ��趨
total_N=fs*total_t;   %�ܲ�������
point_N=1:total_N;   %��������
bias_t=fs*10.6;    % ʱ��ƫ��   10, 10.5
t=point_N/fs;   %ʱ��

% signal=Data(point_N+bias_t);
%% �˲�



% figure();
% plot(signal);
% fouriorTransform( signal,fs,1);


% bpFilt = designfilt('bandpassfir','FilterOrder',30, ...
%          'CutoffFrequency1',100,'CutoffFrequency2',1500, ...
%          'SampleRate',10240);
% filtered_signal=filter(bpFilt,signal);


% filtered_signal=signal;

% figure();
% plot(filtered_signal);
% fouriorTransform( filtered_signal,fs,1);






%%

length=total_N;

% A_noise=2;
% noise=A_noise*randn(length,1);
% filtered_signal=filtered_signal+noise;

load 'inner_data7.mat';  % 7,

%% �����ֵ�
%��Ȧ�źţ�ԭ����Ƶ��1263�������0.12
%��Ȧ�źţ�ԭ����Ƶ��1272�������0.17

f_min=1270;          %��Ȧ��ԭ����Ƶ��1272
f_max=1274;
zeta_min=0.17;
zeta_max=0.173;
W_step=3;           %ͨ������Ϊ3
[Dic,rows,cols]=dic(length,f_min,f_max,zeta_min,zeta_max,W_step,fs);
Dic=dictnormalize(Dic);
%% �ֶν����ź��ع�

% sig_recover=[];
% ceo_recover=[];

maxIter=100;           %��������
ts=3;               %����ϵ��
distance=50;         %�������߶ȣ���Ҫ��������
[theta1]=ClusterShrinkStOMP(filtered_signal,Dic,maxIter,ts,distance);
sig_recover1=Dic*theta1;

[theta2]=StOMP(filtered_signal,Dic,maxIter,ts);
sig_recover2=Dic*theta2;


%%

% figure();
% plot(t,filtered_signal);
% 
% [f0,p0]=envolopeTransform( filtered_signal,fs,0 );
% figure();
% plot(f0,p0)
% xlim([0,1000]);
% ylim([0,0.7]);
% 
% figure();
% plot(t,sig_recover1);
% 
% [f1,p1]=envolopeTransform( sig_recover1,fs,0 );
% figure();
% plot(f1,p1)
% xlim([0,1000]);
% ylim([0,0.7]);
% 
% 
% figure();
% plot(f0,p0,'b');
% hold on;
% plot(f1,p1,'r')
% xlim([0,1000]);
% ylim([0,0.7]);

%%
figure();
subplot(2,1,1);

plot(t,filtered_signal)
title('(a)');
xlabel('Time(s)');
ylabel('Amplitude');


% [fre2,q2]=fouriorTransform(filtered_signal,fs,0);
% 
% subplot(3,1,2);
% plot(fre2,q2);
% title('(b)');
% xlabel('Frequency(Hz)');
% ylabel('Amplitude');


[f0,p0]=envolopeTransform( filtered_signal,fs,0 );
subplot(2,1,2);
plot(f0,p0);
title('(c)');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
xlim([0,1000]);
ylim([0,0.5]);




figure();
subplot(3,1,1);
plot(t,sig_recover1);
title('(a)');
xlabel('Time(s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(theta1);
title('(b)');

[f1,p1]=envolopeTransform( sig_recover1,fs,0 );
subplot(3,1,3);
plot(f1,p1);
title('(c)');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
xlim([0,1000]);
ylim([0,0.5]);


figure();
subplot(3,1,1);
plot(t,sig_recover2);
title('(a)');
xlabel('Time(s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(theta2);
title('(b)');

[f2,p2]=envolopeTransform( sig_recover2,fs,0 );
subplot(3,1,3);
plot(f2,p2);
title('(c)');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
xlim([0,1000]);
ylim([0,0.5]);


