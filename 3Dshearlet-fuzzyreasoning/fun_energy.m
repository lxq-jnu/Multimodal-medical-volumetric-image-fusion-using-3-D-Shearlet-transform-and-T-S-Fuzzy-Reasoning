%% 求滑动窗口中元素的平方和，即区域能量
function c = fun_energy(x)
y = 0;
% window = [1 2 1;
%           2 4 2;
%           1 2 1];
% x = (window/16).*x;  
for i = 1:numel(x)    
    
    y = x(i).^2+y;
    
end
c = y;