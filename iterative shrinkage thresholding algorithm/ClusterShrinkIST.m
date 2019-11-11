function [ theta,err ] = ClusterShrinkIST( y,dic,lamda,distance,ts,max_iter )  
% ClusterShrinkIST ������ֵ�����㷨
%   ���������
%     y:�����ź�
%     A:�ֵ�
%     lamda:����
%     distance:�������߶�
%     ts:ԭ����ѡ��ض���ֵ
%     maxIter:����������

    if nargin<6
        max_iter = 10;%SĬ��ֵΪ10  
    end
    if nargin< 5 
        ts = 0.6;%ԭ����ض���ֵ
    end
    if nargin < 4  
        distance=5;
    end  
    
    [dic_rows,dic_cols] = size(dic);%���о���AΪM*N����
    
    if nargin < 3  
        lamda=0.05*sqrt(2*log(dic_cols));
    end
    
    [y_rows,y_columns] = size(y);  
    if y_rows<y_columns  
        y = y';            %y should be a column vector  
    end
    
    theta = zeros(dic_cols,1);%�����洢�ָ���theta(������)  
    Pos_theta = [];%�������������д洢A��ѡ��������  
    r_n = y;%��ʼ���в�(residual)Ϊy  
    
    err=[r_n];
    
    for ss=1:max_iter%������S��  
        product = dic'*r_n;%���о���A������в���ڻ�  
        sigma = norm(r_n)/sqrt(dic_rows);%�μ��ο����׵�3ҳRemarks(3)  
        Js = find(abs(product)>ts*sigma);%ѡ��������ֵ����  
        
        %% ������ ��ѡ����ԭ�ӽ��ж���ɸѡ
        [Js_row,~]=size(Js);
        if Js_row==0
            break;
        end
        
        [class,class_num,eachClass]=cluster1D(Js,distance);
        
        Js_new=[];
        for i=1:class_num
            selected=[];
            c=class(i,1:eachClass(i));
            selected(c)=product(c);
            [~,index]=max(abs(selected));
            Js_new(i,1)=index;
        end
        
        %%
        Is = union(Pos_theta,Js_new);%Pos_theta��Js����  
        if length(Pos_theta) == length(Is)  
            if ss==1  
                theta_ls = 0;%��ֹ��1�ξ���������theta_ls�޶���  
            end  
            break;%���û���µ��б�ѡ��������ѭ��  
        end  
        %At������Ҫ������������Ϊ��С���˵Ļ���(�������޹�)  
        if length(Is)<=dic_rows  
            Pos_theta = Is;%��������ż���  
            At = dic(:,Pos_theta);%��A���⼸����ɾ���At  
        else%At�����������������б�Ϊ������ص�,At'*At��������  
            if ss==1  
                theta_ls = 0;%��ֹ��1�ξ���������theta_ls�޶���  
            end  
            break;%����forѭ��  
        end  
        %y=At*theta��������theta����С���˽�(Least Square)  

        
        % CcStOMP���õ�����С���˽�
        % theta_ls = (At'*At)\(At'*y);%��С���˽�  
        % ������Խ���С���˽��Ż�Ϊ��ֵ���������㷨
        theta_ls=ist(y,At,lamda);
        

        %At*theta_ls��y��At�пռ��ϵ�����ͶӰ  
        pre_r_n=r_n;
        r_n = y - At*theta_ls;%���²в�  
        
        err=[err r_n];
        
        if norm(r_n-pre_r_n)/length(r_n)<5e-4%Repeat the steps until r=0  
            break;%����forѭ��  
        end 
    end  
    theta(Pos_theta)=theta_ls;%�ָ�����theta  
end