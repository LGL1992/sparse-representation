function [ class,class_num ] = cluster2D( loc )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

class=[];
class_num=1;
[length,~]=size(loc);

count=1;
class(class_num,count,:)=loc(1,:);
for i=2:length
    temp=loc(i-1,:);
    cur=loc(i,:);
    close=isClose(temp,cur);
    if close==1         %������ڣ�����뵽ԭ����
        count=count+1;
        class(class_num,count,:)=cur;
    else                %��������ڣ��򴴽��¼���
        class_num=class_num+1;
        count=1;
        
        cur=loc(i,:);
        class(class_num,count,:)=cur;
    end
        
    
    
end


end


function close=isClose(x,y)


if abs(x(1,1)-y(1,1))<=2
    close=1;
else
    close=0;
end

end

