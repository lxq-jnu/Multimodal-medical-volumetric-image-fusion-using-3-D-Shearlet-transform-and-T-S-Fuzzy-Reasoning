%% �󻬶�������Ԫ�ص�ƽ���ͣ�����������
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