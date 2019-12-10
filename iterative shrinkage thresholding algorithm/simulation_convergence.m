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
SNR=-10;
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

%% �����ֵ�
f_min=299;                  %(��Ҫ����ʵ���������)
f_max=301;                  %(��Ҫ����ʵ���������)
zeta_min=0.049;              %(��Ҫ����ʵ���������)
zeta_max=0.051;              %(��Ҫ����ʵ���������)
W_step=4;
[Dic,rows,cols]=generate_dic(len,f_min,f_max,zeta_min,zeta_max,W_step,fs);
Dic=dictnormalize(Dic);
%% �ڽ�����ֵ���������㷨ʱ����Ҫ���ֵ�ľ����������һ����1�����������㷨��ͨ����������ԭ�ӹ�һ������Ȼ������ֻ��Ϊ�˺ÿ�����������ֵ���������㷨������ʹ�õ���majorization-minimization��ܣ���˶��ֵ�߶���Ӳ�Ե�Ҫ��
% ��������������Һþã������ƹ�ʽ��ʱ��ŷ��ֵ�
Dic=Dic/norm(Dic); 
%% ϡ��ָ� 

maxErr=1e-3;
maxIter=100;
window=100;

sigma = 0.025;
lamda = sigma*sqrt(2*log(cols));


[theta_ist,conv_ist]=ist(signal,Dic,lamda,maxErr,maxIter);
sig_recovery_ist=Dic*theta_ist;


[theta_sist,conv_list]=sist(signal,Dic,lamda,maxErr,maxIter,window);
sig_recovery_sist=Dic*theta_sist;


figure()
subplot(4,1,1);
plot(t,sig);
title('signal without noise');
xlabel('Time(s)');
ylabel('Amplitude(m/s^2)');
ylim([-1,1]);

subplot(4,1,2);
plot(t,signal);
title('simulation signal');
xlabel('Time(s)');
ylabel('Amplitude(m/s^2)');
% ylim([-1,1]);

subplot(4,1,3);
plot(t,sig_recovery_sist);
title('LIST');
xlabel('Time(s)');
ylabel('Amplitude(m/s^2)');
ylim([-1,1]);

subplot(4,1,4);
plot(t,sig_recovery_ist);
title('IST');
xlabel('Time(s)');
ylabel('Amplitude(m/s^2)');
ylim([-1,1]);


figure()
subplot(2,1,1);
plot(theta_sist);
title('LIST');
ylabel('Amplitude(m/s^2)');
subplot(2,1,2);
plot(theta_ist);
title('IST');
ylabel('Amplitude(m/s^2)');


figure()
plot(conv_list,'xr-');
hold on;
plot(conv_ist,'og-');
title('convergence');
xlabel('iterations');
% ylabel('');
legend('LIST','IST');
