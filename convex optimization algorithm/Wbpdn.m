function [ x ] = Wbpdn( y,dic,lamda )
%Wbpdn һ���ؼ�Ȩ���㷨
%   ���������
% %     y:�����ź�
%     A:�ֵ�
%     lamda:����

    fprintf('-------��ʼwbpdn�㷨-------\n');

    [y_rows,y_columns] = size(y);  
    if y_rows<y_columns  
        y = y';%y should be a column vector  
    end

    % �ֵ�dicΪdic_rows*dic_cols����,�źų���Ϊdic_rows,ԭ�Ӹ���Ϊdic_cols
    [dic_rows,dic_cols]=size(dic);

    W=weight(y,dic);
    new_w=W*ones(dic_cols,1);
    
    b=dic'*y;
    
    c=lamda*[new_w;new_w]+[-b;b];
    B=[dic'*dic,-dic'*dic;-dic'*dic,dic'*dic];
    lb = zeros(2*dic_cols,1);
    ans=quadprog(B,c,[],[],[],[],lb);
    x=ans(1:dic_cols)-ans(dic_cols+1:2*dic_cols);

end