function [ result ] = kurtosis( x )
%   �˴���ʾ��ϸ˵��
% This function simply calculates the summed kurtosis of the input
% input:x;
% ouput:result;

result = mean( (sum((x-ones(size(x,1),1)*mean(x)).^4)/(size(x,1)-2))./(std(x).^4) );

end

