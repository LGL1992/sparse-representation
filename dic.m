function [A,rows,cols]=dic(N,f_min,f_max,zeta_min,zeta_max,W_step,fs)
% fs=10240;         %����Ƶ��
t=1:N;          %ʱ�䳤��Ϊ10s
rows=length(t); %�ֵ������
A1=1;           %��Ч�źŷ�ֵ
A=[];
%Wss=round(T*fs);
l1=0;
for Wss=0:W_step:N-1
    l1=l1+1;
    l2=0;
   for  zeta0=zeta_min:.01:zeta_max     %(��Ҫ����ʵ���������)
       l2=l2+1;
       l3=0;
       for f0=f_min:f_max
           l3=l3+1;
         sig1=exp(-(zeta0/sqrt(1-zeta0^2))*2*pi*f0*(t/fs)).*sin(2*pi*f0*(t/fs));
          for k=1:N
               if k<=Wss
                   sig2(k)=0;
               else
                   sig2(k)=sig1(k-Wss);
               end
          end
            atom=sig2;
            A=[A atom'];
       end
   end
end
cols=l1*l2*l3;         %�ֵ������
end
