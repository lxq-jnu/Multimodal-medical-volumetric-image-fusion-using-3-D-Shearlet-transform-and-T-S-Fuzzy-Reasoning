function [y] = FuzzyReasoning6(u,h,j)

R1=u+h+j;
R2=u+h+j;
R3=u+h+j;
R4=u+h+j;
R5=u+h+j; 
R6=u+h+j;
R7=u+h+j;
R8=u+h+j;

uR1=SubjectionA(u).* SubjectionA(h).* SubjectionA(j);%SubjectionA是隶属度计算函数
uR2=SubjectionB(u).* SubjectionB(h).* SubjectionA(j);
uR3=SubjectionA(u).* SubjectionA(h).* SubjectionB(j);
uR4=SubjectionB(u).* SubjectionB(h).* SubjectionB(j);
uR5=SubjectionA(u).* SubjectionB(h).* SubjectionA(j);
uR6=SubjectionB(u).* SubjectionA(h).* SubjectionB(j);
uR7=SubjectionB(u).* SubjectionA(h).* SubjectionA(j);
uR8=SubjectionA(u).* SubjectionB(h).* SubjectionB(j);



% temp2 = max(d,e);
sum=uR1+uR2+uR3+uR4+uR5+uR6+uR7+uR8;
if sum==0
    y=0;
else
y=(R1.*uR1+R2.*uR2+R3.*uR3+R4.*uR4+R5.*uR5+R6.*uR6+R7.*uR7+R8.*uR8)./(uR1+uR2+uR3+uR4+uR5+uR6+uR7+uR8);
end
% y2=(R2.*uR3+R4.*uR4+R6.*uR6+R8.*uR8)./(uR2+uR4+uR6+uR8);
% uRA = max(temp1,temp2);


end