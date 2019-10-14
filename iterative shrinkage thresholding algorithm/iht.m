function [ x ] = iht( y,A,lamda,maxErr,maxIter )
%IHT ������ֵ�����㷨 Ӳ��ֵ �����㷶������
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
    n = size(A,2);    
    x = zeros(n,1);%Initialize x=0  
    f = 0.5*(y-A*x)'*(y-A*x)+lamda*sum(abs(x));
    iter = 0; 
    while 1    
        x_pre = x;
        x=hard_threshold(x + A'*(y-A*x),lamda); %update x          
        iter = iter + 1;  
        f_pre = f;
        f = 0.5*(y-A*x)'*(y-A*x)+lamda*sum(abs(x));
        if abs(f-f_pre)/f_pre<maxErr
            fprintf('abs(f-f_pre)/f_pre<%f\n',maxErr);
            fprintf('IHT loop is %d\n',iter);
            break;
        end
        if iter >= maxIter
            fprintf('loop > %d\n',maxIter);
            break;
        end
        if norm(x-x_pre)<maxErr
            fprintf('norm(x-x_pre)<%f\n',maxErr);
            fprintf('IHT loop is %d\n',iter);
            break;
        end
    end  
end

%% Ӳ��ֵ����
function [ x ]=hard_threshold(b,lamda)
    sel=(abs(b)>sqrt(lamda));
    x=b.*sel;
end

