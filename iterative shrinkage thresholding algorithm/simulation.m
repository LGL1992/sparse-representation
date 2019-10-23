 clc;clear all;close all;
%% StOMP�㷨���� �����źŷ���

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

% figure();
% plot(t,sig);

%% ��������
SNR=-3;
[signal,noise]=noisegen(sig,SNR);

% figure()
% subplot(2,1,1);
% plot(t,sig);
% title('��������ź�');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% ylim([-1,1]);
% 
% subplot(2,1,2);
% plot(t,signal);
% title('��������ź�');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% ylim([-1,1]);

%% �����ֵ�
f_min=299;                  %(��Ҫ����ʵ���������)
f_max=301;                  %(��Ҫ����ʵ���������)
zeta_min=0.049;              %(��Ҫ����ʵ���������)
zeta_max=0.051;              %(��Ҫ����ʵ���������)
W_step=4;
[Dic,rows,cols]=dic(len,f_min,f_max,zeta_min,zeta_max,W_step,fs);
Dic=dictnormalize(Dic);
%% �ڽ�����ֵ���������㷨ʱ����Ҫ���ֵ�ľ����������һ����1�����������㷨��ͨ����������ԭ�ӹ�һ������Ȼ������ֻ��Ϊ�˺ÿ�����������ֵ���������㷨������ʹ�õ���majorization-minimization��ܣ���˶��ֵ�߶���Ӳ�Ե�Ҫ��
% ��������������Һþã������ƹ�ʽ��ʱ��ŷ��ֵ�
Dic=Dic/norm(Dic); 
%% ϡ��ָ� 

maxIter=1000;           %��������
maxErr=1e-2;
ts=3;               %����ϵ��
distance=5;         %�������߶ȣ���Ҫ��������

% bpdn

% theta=bpdn(signal,Dic,lamda);
% sig_recovery=Dic*theta;

% ist
sigma = 0.025;
lamda = sigma*sqrt(2*log(len));
theta=ist(signal,Dic,lamda,maxErr,maxIter);
sig_recovery=Dic*theta;

figure();
plot(t,sig_recovery);


% iht �����ж�ihtЧ��û��ist�ã�Ӧ��������ֵ����������
% theta=iht(signal,Dic,lamda,maxErr,maxIter);
% sig_recovery=Dic*theta;
% 
% figure();
% plot(t,sig_recovery);

% ixt �µĸĽ��ĵ�����ֵ�㷨
% sigma = 0.1;
% lamda = sigma*sqrt(2*log(len));
% theta=ixt(signal,Dic,lamda,maxErr,maxIter);
% sig_recovery=Dic*theta;
% 
% figure();
% plot(t,sig_recovery);


% gist
% sigma = 0.025;
% lamda = sigma*sqrt(2*log(len));
% theta=gist(signal,Dic,lamda);
% sig_recovery=Dic*theta;
% 
% figure();
% plot(t,sig_recovery);


