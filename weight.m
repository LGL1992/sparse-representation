function [ W ] = weight( y,dic )
%weight ȫָ����
%   




    % �ֵ�dicΪdic_rows*dic_cols����,�źų���Ϊdic_rows,ԭ�Ӹ���Ϊdic_cols
    [dic_rows,dic_cols]=size(dic);
    
    %% ��Ȩ������Ҫ̽��
    % ����һ���������ϵ����Ȩ
%     c=w_inner_product(y,dic);
    % �������������Ͷ�ָ��
    c=w_kurt(y,dic);
    
    
    % ��һ��������Ҫ̽��
    % c=zscore(inner_product)+1;
    % ��һ����01����
%     c=mapminmax(c,0,1);
    % ��ֵ��Ϊ1
    c=c-mean(c)+1;
    
    
    
    W=diag(c);

end

%% �������ϵ�����м�Ȩ
function c=w_inner_product(y,dic)

    c=abs(y'*dic);

end

%% �����ͶȽ��м�Ȩ
function c=w_kurt(y,dic)
    
    [dic_rows,dic_cols]=size(dic);
    for i=1:dic_cols
        atom=dic(:,i);
        
        c(i)=kurtsis(y(find(atom~=0)));
        
    end
    
%     c=(1./c).^2;

    

end


