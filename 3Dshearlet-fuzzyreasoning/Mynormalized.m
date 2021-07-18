function new_aH = Mynormalized(aH,E_aH,E_bH)
%% 实现区域特征的归一化操作
[m,n] = size(aH);
new_aH  = zeros(m,n);
for i = 1:m
    for j = 1:n
        if (E_aH(i,j)+E_bH(i,j) ~= 0)
         new_aH(i,j) = E_aH(i,j)/(E_aH(i,j)+E_bH(i,j));
        else
            new_aH(i,j) = 0.5;
        end
    end
end

end