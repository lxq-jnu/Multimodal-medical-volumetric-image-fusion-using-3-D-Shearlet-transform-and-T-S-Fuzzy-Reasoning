function [ E ] = compute_type2(U, L)

M = 3;
N =3;
[H, W] = size(U);

padU = padarray(U, [floor(M/2), floor(N/2)], 'symmetric');
padL = padarray(L, [floor(M/2), floor(N/2)], 'symmetric');

E = zeros(H, W);

for i = 1 : H
    for j = 1 : W
%         XU = padU(i:i+M, j:j+N);
%         XL = padL(i:i+M, j:j+N);
    e = 0;
        for m = 1 : M
            for n = 1 : N
                u = padU(i+m-1, j+n-1);
                l = padL(i+m-1, j+n-1);
                if l < 0.5 && u > 0.5
                    e = e + (u - l);
                else
                    e = e + (min(l,1-u) / max(l,1-u));
                end
%                e = e + (u - l);
%                  e = e + min(l,u) / min(l,u);
            end
        end
        E(i, j) = e;
    end
end

end

