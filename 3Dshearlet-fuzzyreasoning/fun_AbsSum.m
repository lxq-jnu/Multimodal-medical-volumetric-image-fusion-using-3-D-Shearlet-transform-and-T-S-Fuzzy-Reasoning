%% 求滑动窗口中元素的绝对值和
function c = fun_AbsSum(x)
y = 0;
for i = 1:numel(x)    
    
    y = abs(x(i))+y;

end
c = y;