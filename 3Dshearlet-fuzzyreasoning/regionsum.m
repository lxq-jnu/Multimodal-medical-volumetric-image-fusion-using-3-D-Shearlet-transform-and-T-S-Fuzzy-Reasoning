function E_aH = regionsum(aH)
%%����ϵ��aH����������
dH = Myextend(aH);
t = zeros(3,3);
[m,n] = size(aH);
E_aH = zeros(m,n);
for i = 1:m
    for j = 1:n
        for p = -1:1
            for q = -1:1
                t(p+2,q+2) = dH(i+1+p,j+1+q);
            end
        end
       E_aH(i,j) = sum(abs(t(:)));
    end
end
end