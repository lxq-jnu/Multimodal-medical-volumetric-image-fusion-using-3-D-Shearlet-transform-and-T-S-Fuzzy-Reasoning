function L=fusionrulesenergy(A)
% ZA=(LA-min(min(LA)))./(max(max(LA))-min(min(LA)));
% ZB=(LB-min(min(LB)))./(max(max(LB))-min(min(LB)));
windowSize = [3,3];
fun = @(x) sum(sum(x.^2))./(3*3);
% % % % % 
L = nlfilter(A, windowSize, fun);
% LEB = nlfilter(B, windowSize, fun);
% LEA = A.*A;
% LEB = B.*B;
% omega = zeros(size(A));
% % omega(LEA == LEB) = 0.5;
% omega(LEA >= LEB) = 1;
% 
% L = omega .* A + (1 - omega) .* B;
% 