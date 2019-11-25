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



%% ϡ��ָ��㷨 CcIST
% �㷨�й����ĸ����� �ֱ�����
%     lamda:����                  ���ص������
%     distance:�������߶�        ���ص������
%     ts:ԭ����ѡ��ض���ֵ
%     maxIter:����������


exp_num=10; %ÿ��ʵ�����


%% ����:sigma
% cc=[];
% sigma_range=0.01:0.01:0.1;
% for sigma=sigma_range
%     lamda=sigma*sqrt(2*log(cols));
%     
%     temp=[];
%     for i=1:exp_num
%         [signal,noise]=noisegen(sig,SNR);
%         theta=sist(signal,Dic,lamda);
%         sig_recovery=Dic*theta;
%         % ���ϵ��
%         r=corrcoef(sig,sig_recovery);
%         temp=[temp r(1,2)];
%     end
%     % ȡ��ֵ
%     cc=[cc mean(temp)];
% end
% 
% figure()
% plot(sigma_range,cc);

%% ��ist�㷨�Ա�
SNR_range=0:-1:-7;
cc=[];
for SNR=SNR_range
    [signal,noise]=noisegen(sig,SNR);
    
    temp=[];
    
    for i=1:exp_num
        % sist
        sigma=0.03;
        lamda=sigma*sqrt(2*log(cols));
        theta_sist=sist(signal,Dic,lamda);
        sig_sist=Dic*theta_sist;
        
        % ist
        sigma=0.03;
        lamda=sigma*sqrt(2*log(cols));
        theta_ist=ist(signal,Dic,lamda);
        sig_ist=Dic*theta_ist;
        
        
        % ��ضȱȽ�
        r_sist=corrcoef(sig,sig_sist);
        r_ist=corrcoef(sig,sig_ist);
        
        temp=[temp; r_sist(1,2) r_ist(1,2)];
        
    end
    
    cc=[cc;mean(temp,1)];
     
end

figure()
plot(SNR_range,cc(:,1),'xr-');
hold on;
plot(SNR_range,cc(:,2),'og-');
legend('sist','ist');





