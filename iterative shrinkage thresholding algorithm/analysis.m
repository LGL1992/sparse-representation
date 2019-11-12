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
A2=1;                 %��ֵ

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
SNR=-5;


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
[Dic,rows,cols]=generate_dic(len,f_min,f_max,zeta_min,zeta_max,W_step,fs);
Dic=dictnormalize(Dic);
Dic=Dic/norm(Dic); 



%% ϡ��ָ��㷨


%% �Ƚ϶����㷨�ع�Ч��ͼ

% SNR=-6;
% [signal,noise]=noisegen(sig,SNR);
% figure();
% subplot(3,1,1);
% plot(t,sig);
% title('��������ź�');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% ylim([-1,1]);
% subplot(3,1,2);
% plot(t,noise);
% title('����');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% ylim([-1,1]);
% subplot(3,1,3);
% plot(t,signal);
% title('�����ź�');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% ylim([-1,1]);
% 
% % CcIST
% sigma=0.02;
% lamda=sigma*sqrt(2*log(cols));
% ts=0.7;
% distance=20;
% theta_CcIST=ClusterShrinkIST(signal,Dic,lamda,distance,ts);
% sig_CcIST=Dic*theta_CcIST;
% 
% % IST
% sigma=0.02;
% lamda=sigma*sqrt(2*log(cols));
% theta_IST=ist(signal,Dic,lamda);
% sig_IST=Dic*theta_IST;
% 
% % CcStOMP
% ts=0.7;
% distance=20;
% maxIter=30;
% [theta_CcStOMP,err_CcStOMP]=ClusterShrinkStOMP(signal,Dic,maxIter,ts,distance);
% sig_CcStOMP=Dic*theta_CcStOMP;
% 
% % ��ͼ
% figure();
% subplot(3,1,1);
% plot(t,sig_CcIST);
% title('CcIST');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% % ylim([-1,1]);
% subplot(3,1,2);
% plot(t,sig_IST);
% title('IST');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% % ylim([-1,1]);
% subplot(3,1,3);
% plot(t,sig_CcStOMP);
% title('CcStOMP');
% xlabel('ʱ�� t/s');
% ylabel('��ֵ A(m/s^2)');
% % ylim([-1,1]);
%% �Ƚ϶�������������ϵ����ָ�������
SNR_range=0:-0.5:-7;
ex_num=50;% ÿ��ʵ�����

cc=[];
for SNR=SNR_range
    [signal,noise]=noisegen(sig,SNR);
    
    temp=[];
    for i=1:ex_num
        
        % CcIST
        sigma=0.03;
        lamda=sigma*sqrt(2*log(cols));
        ts=0.7;
        distance=20;
        theta_CcIST=ClusterShrinkIST(signal,Dic,lamda,distance,ts);
        sig_CcIST=Dic*theta_CcIST;

        % IST
        sigma=0.03;
        lamda=sigma*sqrt(2*log(cols));
        theta_IST=ist(signal,Dic,lamda);
        sig_IST=Dic*theta_IST;

        % CcStOMP
        ts=0.7;
        distance=20;
        maxIter=30; 
        [theta_CcStOMP,err_CcStOMP]=ClusterShrinkStOMP(signal,Dic,maxIter,ts,distance);
        sig_CcStOMP=Dic*theta_CcStOMP;
        
        % ����ض�
        r_CcIST=corrcoef(sig,sig_CcIST);
        r_IST=corrcoef(sig,sig_IST);
        r_CcStOMP=corrcoef(sig,sig_CcStOMP);
        
        temp=[temp;r_CcIST(1,2) r_IST(1,2) r_CcStOMP(1,2)];
        
    end
    
    cc=[cc;mean(temp)];
    

end

figure()
plot(SNR_range,cc(:,1),'xr-');
hold on;
plot(SNR_range,cc(:,2),'og-');
plot(SNR_range,cc(:,3),'*b-');
legend('CcIST','IST','CcStOMP');

%%



