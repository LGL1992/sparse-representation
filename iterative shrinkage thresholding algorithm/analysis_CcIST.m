clc;clear all;close all;
%% StOMP算法性能 仿真信号分析

fs=2000;                %采样频率
total_time=1;           %采样时间
len=fs*total_time;   %采样点数
point=1:len;         %采样点序列
t=point/fs;             %时间

damp=0.05;              %阻尼系数
f_vibrate=300;          %震荡频率
t0=0.05;                %时延
T=0.1;                  %信号周期


while (t0-T>0)
    t0=t0-T;
end
sig_laplacewavelet=exp(-(damp/sqrt(1-damp^2))*2*pi*f_vibrate*t).*sin(2*pi*f_vibrate*t);
Wss=round(t0*fs);

A1=1;                   %幅值
A2=0.5;                 %幅值

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
%% 加入噪声
SNR=-5;


% figure()
% subplot(2,1,1);
% plot(t,sig);
% title('无噪仿真信号');
% xlabel('时间 t/s');
% ylabel('幅值 A(m/s^2)');
% ylim([-1,1]);
% 
% subplot(2,1,2);
% plot(t,signal);
% title('无噪仿真信号');
% xlabel('时间 t/s');
% ylabel('幅值 A(m/s^2)');
% ylim([-1,1]);

%% 构造字典
f_min=299;                  %(需要根据实际情况调整)
f_max=301;                  %(需要根据实际情况调整)
zeta_min=0.049;              %(需要根据实际情况调整)
zeta_max=0.051;              %(需要根据实际情况调整)
W_step=4;
[Dic,rows,cols]=generate_dic(len,f_min,f_max,zeta_min,zeta_max,W_step,fs);
Dic=dictnormalize(Dic);
Dic=Dic/norm(Dic); 



%% 稀疏恢复算法 CcIST
% 算法中共有四个参数 分别讨论
%     lamda:乘子                  （重点参数）
%     distance:聚类距离尺度        （重点参数）
%     ts:原子挑选相关度阈值
%     maxIter:最大迭代次数


exp_num=50; %每组实验次数


%% 参数:sigma
% cc=[];
% sigma_range=0.01:0.0025:0.05;
% for sigma=sigma_range
%     lamda=sigma*sqrt(2*log(cols));
%     
%     temp=[];
%     for i=1:exp_num
%         [signal,noise]=noisegen(sig,SNR);
%         theta=ClusterShrinkIST(signal,Dic,lamda,20);
%         sig_recovery=Dic*theta;
%         % 相关系数
%         r=corrcoef(sig,sig_recovery);
%         temp=[temp r(1,2)];
%     end
%     % 取均值
%     cc=[cc mean(temp)];
% end
% 
% figure()
% plot(sigma_range,cc);
%% 参数:ts
cc=[];
ts_range=0.5:0.01:0.8;
for ts=ts_range
    
    sigma=0.03;
    lamda=sigma*sqrt(2*log(cols));
    temp=[];
    for i=1:exp_num
        [signal,noise]=noisegen(sig,SNR);
        theta=ClusterShrinkIST(signal,Dic,lamda,20,ts);
        sig_recovery=Dic*theta;
        % 相关系数
        r=corrcoef(sig,sig_recovery);
        temp=[temp r(1,2)];
    end
    % 取均值
    cc=[cc mean(temp)]; 
end

figure()
plot(ts_range,cc);

