function f=Ftype2new(muAl,muAu,muBl,muBu,coefsA,coefsB)
% [m,n]=size(EdgePDFA);
[s,t]=size(muAl);
% c1=median(median(EdgePDFA));
% c2=median(median(EdgePDFB));
% a1=min(min(EdgePDFA));
% a2=min(min(EdgePDFB));
% b1=max(max(EdgePDFA));
% b2=max(max(EdgePDFB));
% d1=std2(EdgePDFA);
% d2=std2(EdgePDFB);
% for i=1:s
%     for j=1:t
%         EdgePDFA1(i,j)=EdgePDFA(i,j);
%         EdgePDFB1(i,j)=EdgePDFB(i,j);
%     end
% end
% for q=1:s
%     z(q)=0;
% end
% EdgePDFA=[EdgePDFA;z];
% EdgePDFA=[z;EdgePDFA];
% EdgePDFB=[EdgePDFB;z];
% EdgePDFB=[z;EdgePDFB];
% for q=1:s+2
%     z(q)=0;
% end
% z=z';
% EdgePDFA=[EdgePDFA z];
% EdgePDFA=[z EdgePDFA];
% EdgePDFB=[EdgePDFB z];
% EdgePDFB=[z EdgePDFB];
% for i=1:s
%     for j=1:t
%         EdgePDFEA=zeros(i,j);
%         EdgePDFEB=zeros(i,j);
%     end
% end
% 
% for i=2:s+1
%     for j=2:t+1
%         windowA= EdgePDFA(i-1:i+1,j-1:j+1);
%         windowB= EdgePDFB(i-1:i+1,j-1:j+1);
%        for m=1:3
%            for n=1:3
%                EdgePDFEA(i-1,j-1)= EdgePDFEA(i-1,j-1)+windowA(m,n);
%                 EdgePDFEB(i-1,j-1)= EdgePDFEB(i-1,j-1)+windowB(m,n);
%            end
%        end
%         EdgePDFEA(i-1,j-1)= EdgePDFEA(i-1,j-1)/(m*n);
%         EdgePDFEB(i-1,j-1)= EdgePDFEB(i-1,j-1)/(m*n);
%     end
% end
% for i=1:s
%     for j=1:t
% % muA(i,j)=exp(-(EdgePDFA(i,j)-c1)^2/(2*0.1*0.1));
% % muB(i,j)=exp(-(EdgePDFB(i,j)-c2)^2/(2*0.1*0.1));        
% % muA(i,j)=1/(1+(abs(EdgePDFA(i,j)-c1)/a1));
% % muB(i,j)=1/(1+(abs(EdgePDFB(i,j)-c2)/a2));
% muAl(i,j)=muA(i,j)^0.5;
% muAu(i,j)=muA(i,j)^2;
% muBl(i,j)=muB(i,j)^0.5;
% muBu(i,j)=muB(i,j)^2;
%     end
% end

 pI=zeros(s+2,t+2);
 vpa(pI,15);
 k=0;
for i=1:s+2
    for j=1:t+2
       EA1=zeros(i,j);
       EB1=zeros(i,j);
       EA2=zeros(i,j);
       EB2=zeros(i,j);
%        NA=zeros(i,j);
%        NB=zeros(i,j);
    end
end
for q=1:s
    z(q)=0;
end
muAl=[muAl;z];
muAl=[z;muAl];
muAu=[muAu;z];
muAu=[z;muAu];
muBl=[muBl;z];
muBl=[z;muBl];
muBu=[muBu;z];
muBu=[z;muBu];
for q=1:s+2
    z(q)=0;
end
z=z';
muAl=[muAl z];
muAl=[z muAl];
muAu=[muAu z];
muAu=[z muAu];
muBl=[muBl z];
muBl=[z muBl];
muBu=[muBu z];
muBu=[z muBu];
for i=2:s+1
    for j=2:t+1
        windowAl=muAl(i-1:i+1,j-1:j+1);
        windowAu=muAu(i-1:i+1,j-1:j+1);
        windowBl=muBl(i-1:i+1,j-1:j+1);
        windowBu=muBu(i-1:i+1,j-1:j+1);
        for m=1:3
            for n=1:3
               EA1(i,j)=EA1(i,j)+(windowAu(m,n)-windowAl(m,n));
               EA2(i,j)=EA2(i,j)+((min(windowAl(m,n),1-windowAu(m,n)))/(max(windowAl(m,n),1-windowAu(m,n))));
               EB1(i,j)=EB1(i,j)+(windowAu(m,n)-windowAl(m,n));
               EB2(i,j)=EB2(i,j)+((min(windowAl(m,n),1-windowAu(m,n)))/(max(windowAl(m,n),1-windowAu(m,n)))); 
            end
        end
        EA(i,j)=EA1(i,j)+EA2(i,j);
        EB(i,j)=EB1(i,j)+EB2(i,j);

   end
end


for i=1:s
    for j=1:t
        if EA(i,j)>=EB(i,j)
            f(i,j)=coefsA(i,j);
        else f(i,j)=coefsB(i,j);
        end    
    end
end
