function [ theta , err ] = gist( y,dic,lamda,max_reco_iter,max_err,ts,max_sel_iter )
%GIST ̰�����������㷨
%   ���������
%     y:�����ź�
%     A:�ֵ�
%     lamda:����
%     err:�������
%     maxIter:����������
%   ���������
%     x:ϡ��ϵ������
%     err:�в�������仯���

    fprintf('-------��ʼgist�㷨-------\n');

    if nargin<7
        max_sel_iter=10;% ԭ��ѡ���еĵ�������
    end
    
    if nargin<6
        ts=1;%ts��Χ[2,3],Ĭ��ֵΪ2.5 
    end

    if nargin<5
        max_err=1e-2;% �������ж�
    end
    
    if nargin<4
       max_reco_iter=10000;% ��ֵ���������еĵ�������
    end
    
    if nargin<3
        lamda=0.01;% �������ճ���
    end
    
    [y_rows,y_cols]=size(y);
    % ȷ�� y ��һ��������
    if y_rows<y_cols
        y=y';
    end
    
    % �ֵ�dicΪdic_rows*dic_cols����,�źų���Ϊdic_rows,ԭ�Ӹ���Ϊdic_cols
    [dic_rows,dic_cols]=size(dic);
    
    % ��ʼ��theta����
    theta=zeros(dic_cols,1);
    
    % ���汻ѡ��ԭ�������
    index_theta=[];
    
    % ��ʼ���в�
    res=y;
    err=[res];
    
    % ������max_sel_iter��
    for sel_iter=1:max_sel_iter
        product=dic'*res;% �����ֵ���ԭ����в���ڻ�
        
        % ��ѡ��������ֵ����
        sigma=norm(res)/sqrt(dic_rows);
        selected=find(abs(product)>ts*sigma);
        % ͨ���ĵ���ֹͣ�����������û����ѡ���µ�ԭ��ʱֹͣ����
        if isempty(selected)
            fprintf('sel_iter:%f-����֧�ż�Ϊ�գ�����ѭ��������ع�\n',sel_iter);
            break;
        end
        index_theta=union(index_theta,selected);
        
        % ����̰���ֵ䣬�ô��ֵ���е�����ֵ����
        greedy_dic=dic(:,index_theta);
        [~,greedy_dic_cols]=size(greedy_dic);
        sel_theta=zeros(greedy_dic_cols,1);
        
        % Ŀ�꺯��������
        obj_f=0.5*(y-greedy_dic*sel_theta)'*(y-greedy_dic*sel_theta)+lamda*sum(abs(sel_theta));
        
        for reco_iter=1:max_reco_iter
            sel_theta_pre=sel_theta;
            
            % ϵ�����½׶�
            sel_theta=shrinkage_function(sel_theta+greedy_dic'*(y-greedy_dic*sel_theta),lamda);
            
            obj_f_pre=obj_f;
            obj_f=0.5*(y-greedy_dic*sel_theta)'*(y-greedy_dic*sel_theta)+lamda*sum(abs(sel_theta));
            
            if abs((obj_f-obj_f_pre)/obj_f_pre)<max_err
                fprintf('sel_iter:%f-abs((obj_f-obj_f_pre)/obj_f_pre)<%f\n',sel_iter,max_err);
                break; 
            end
            
            if norm(sel_theta-sel_theta_pre)<max_err
                fprintf('sel_iter:%f-norm(x-x_pre)<%f\n',sel_iter,max_err);
                break;
            end
            
            % ���������Ҫ����������������
            
        end
        
        res_pre=res;
        res=y-greedy_dic*sel_theta;
        
        err=[err res];
        
        if abs((norm(res)-norm(res_pre))/norm(res_pre))<max_err
            fprintf('sel_iter:%f-�в�����������ѭ��������ع�\n',sel_iter);
            break;
        end    
    end
    
    % �ָ�����theta
    theta(index_theta)=sel_theta;

end

%% ��������
function [x] =shrinkage_function(b,lamda)
     x=sign(b).*max(abs(b) - lamda,0);
end

