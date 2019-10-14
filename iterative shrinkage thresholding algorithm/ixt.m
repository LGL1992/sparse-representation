function [ x ] = ixt( y,A,lamda,maxErr,maxIter )
%IXT �Ľ��ĵ�����ֵ�����㷨
% 'x' means something new
%   ���������
%     y:�����ź�
%     A:�ֵ�
%     lamda:����
%     err:�������
%     maxIter:����������

    if nargin < 5    
        maxIter = 10000;    
    end    
    if nargin < 4      
        maxErr = 1e-2;      
    end     
    if nargin < 3      
        lamda = 0.1*max(abs(A'*y));     
    end     
    [y_rows,y_columns] = size(y);      
    if y_rows<y_columns      
        y = y';%y should be a column vector      
    end 
    %soft = @(x,T) sign(x).*max(abs(x) - T,0);
    n = size(A,2);    
    x = zeros(n,1);%Initialize x=0  
    f = 0.5*(y-A*x)'*(y-A*x)+lamda*sum(abs(x));
    iter = 0; 
    while 1    
        x_pre = x;
        x = threshold_function(x + A'*(y-A*x),lamda);%update x        
        iter = iter + 1;  
        f_pre = f;
        f = 0.5*(y-A*x)'*(y-A*x)+lamda*sum(abs(x));
        if abs(f-f_pre)/f_pre<maxErr
            fprintf('abs(f-f_pre)/f_pre<%f\n',maxErr);
            fprintf('IST loop is %d\n',iter);
            break;
        end
        if iter >= maxIter
            fprintf('loop > %d\n',maxIter);
            break;
        end
        if norm(x-x_pre)<maxErr
            fprintf('norm(x-x_pre)<%f\n',maxErr);
            fprintf('IST loop is %d\n',iter);
            break;
        end
    end  
end

%% ��ֵ����
function [ x ]=threshold_function(b,lamda)
    x=b./(1+lamda);
end
