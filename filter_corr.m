%%
clc;clear all;close all
%������������������������������������������������������������������������������������������������
fs=10240;                             %���źŲ���Ƶ��(�޸�)
dt=1/fs;
load '�����Ȧ1x0.5����ͨ��4.mat';
sig_x=Data(1:1024*2);                          %ȡ�ź�
N=length(sig_x);
t=1:N;
t1=t/fs;
Ws=200;           %LaplaceС��֧�ų��ȣ��Ե�����ʾ��
%%
%����FFT�任����Ƶ��ͼ
mag=abs(fft(sig_x));%����fft�任
figure(1)
plot(t1,sig_x);
title('��й����ź�');
xlabel('ʱ�� t/s');
ylabel('��ֵ A(m/s^2)');
figure(2)
plot((0:N/2-1)/N*fs,mag(1:N/2));%����Ƶ��ͼ
xlabel('Ƶ�� F/(Hz)');ylabel('��ֵ A/(m/s^2)');
title('�ź�Ƶ��(FFT)')
%%
display_step=1 %����ִ�е���ʵ��־

f_kr=1900:2500;   %С��ԭ�ӵ�Ƶ�ʷ�Χ
zeta_kr=[0.12:0.005:0.13];     

t_kr_all=N/fs;
t_kr_step=t_kr_all/N;  
t_kr=0:t_kr_step:t_kr_all;
%t_kr=0:t_kr_step:0.015; %%С��ԭ�ӵ�ʱ�䷶Χ

i=0;j=0;k=0;
maxkr=0;
maxkr_f=min(f_kr);
maxkr_zeta=min(zeta_kr);
maxkr_T0=min(t_kr);
display_step=2.1  %����ִ�е���ʵ��־
for f=f_kr
    i=i+1;
    j=0;
    for zeta=zeta_kr
        j=j+1;
        k=0;
        sig1=exp(-(zeta/sqrt(1-zeta^2))*2*pi*f*(t/fs));
        for T0=t_kr
            k=k+1;
            Wss=round(T0*fs);
            for m=1:N           %����LaplaceС��ԭ�ӣ���ʱT0
                if m>Wss
                    if m<Wss+Ws
                        sig2(m)=sig1(m-Wss);
                    else 
                        sig2(m)=0;
                    end

                else
                    sig2(m)=0;
                end
            end
            sig=sig2.*sin(2*pi*f*(t/fs));
            kr(i,j,k)=abs(dot(sig_x,sig))/(sqrt(sum(sig_x.*sig_x))*sqrt(sum(sig.*sig)));
            if kr(i,j,k)>maxkr
                maxkr=kr(i,j,k);
                maxkr_f=f;          
                maxkr_zeta=zeta;    
                maxkr_T0=T0;                                  
            end     
        end
    end
    display_f_kr=f %����ִ�е���ʾ��־
end
%%
display_f=maxkr_f
display_zeta= maxkr_zeta
display_To=maxkr_T0
%% matched basis
sig11=exp(-(maxkr_zeta/sqrt(1-maxkr_zeta^2))*2*pi*maxkr_f*(t/fs)).*sin(2*pi*maxkr_f*(t/fs)); %�ҵ��Ļ���
 Wss=round(maxkr_T0*fs);
 for m=1:N
    if m<=Wss
        sig_basis(m)=0;
    else
        sig_basis(m)=sig11(m-Wss); %����ʱ�Ļ���
    end
 end
figure(3)
plot(t1,sig_basis)
title('basis');
xlabel('time ')
ylabel('amplitude')