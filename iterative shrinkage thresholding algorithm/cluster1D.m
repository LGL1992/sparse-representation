function [ class,class_num,eachClass ] = cluster1D( ceo,distance )
%cluster1D ����ժҪ
%   
% input:
%     ceo;ϡ��ϵ������
%     distance:���룬��������Ϊ5
% output:
%     class:�������
%     class_num:�ܹ�����
%     eachClass:ÿ����м���


[length,~]=size(ceo);

class=[];
class_num=1;

count=1;
class(class_num,count)=ceo(1,1);
for i=2:length
    temp=ceo(i-1,1);
    cur=ceo(i,1);
    
    if abs(temp-cur)<=distance             %������ڣ������ԭ����
        count=count+1;
        class(class_num,count)=cur;
        
    else                            %��������ڣ��򴴽��¼���
        eachClass(class_num)=count;
        
        class_num=class_num+1;
        count=1;
        
        class(class_num,count)=cur;
    end
    
        
end

eachClass(class_num)=count;

end

