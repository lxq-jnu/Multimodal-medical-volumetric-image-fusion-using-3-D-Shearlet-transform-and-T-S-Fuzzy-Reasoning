function [EA,EB]=type2(A,B)
% [m,n]=size(EdgePDFA);
% [s,t]=size(coefsA);
% xA = nlfilter(EdgeA, [3 3], @fun_energy);
% xB = nlfilter(EdgeB, [3 3], @fun_energy);
c1=mean(mean(A));
c2=mean(mean(B));
a1=min(min(A));
a2=min(min(B));
% a1=min(min(coefsA));
% a2=min(min(coefsB));
% b1=max(max(coefsA));
% b2=max(max(coefsB));
% d1=std2(coefsA);
% d2=std2(coefsB);
% d1=std2(EdgeA);
% d2=std2(EdgeB);
% 
muA = 1 ./ (1 + abs((A - c1) ./ a1).^2);
muB = 1 ./ (1 + abs((B - c2) ./ a2).^2);
% muA=(EdgeA-min(min(EdgeA)))/(max(max(EdgeA))-min(min(EdgeA)));
% muB=(EdgeB-min(min(EdgeB)))/(max(max(EdgeB))-min(min(EdgeB)));


% muA=exp(-(muA-c1)^2/(2*0.1*0.1));
% muB=exp(-(muB-c2)^2/(2*0.1*0.1));


muAl = muA .^ 2;
muAu = muA .^ 0.5;
muBl = muB .^ 2;
muBu = muB .^ 0.5;

EA = compute_type2(muAu, muAl);
EB = compute_type2(muBu, muBl);

% f = A;
% f(EA < EB) = B(EA < EB);

%  pI=zeros(s+2,t+2);
%  vpa(pI,15);
%  k=0;
% for i=1:s+2
%     for j=1:t+2
%        EA1=zeros(i,j);
%        EB1=zeros(i,j);
%        EA2=zeros(i,j);
%        EB2=zeros(i,j);
%        EA=zeros(i,j);
%        EB=zeros(i,j);
%     end
% end
% for q=1:s
%     z(q)=0;
% end
% muAl=[muAl;z];
% muAl=[z;muAl];
% muAu=[muAu;z];
% muAu=[z;muAu];
% muBl=[muBl;z];
% muBl=[z;muBl];
% muBu=[muBu;z];
% muBu=[z;muBu];
% for q=1:s+2
%     z(q)=0;
% end
% z=z';
% muAl=[muAl z];
% muAl=[z muAl];
% muAu=[muAu z];
% muAu=[z muAu];
% muBl=[muBl z];
% muBl=[z muBl];
% muBu=[muBu z];
% muBu=[z muBu];
% for i=2:s+1
%     for j=2:t+1
%         windowAl=muAl(i-1:i+1,j-1:j+1);
%         windowAu=muAu(i-1:i+1,j-1:j+1);
%         windowBl=muBl(i-1:i+1,j-1:j+1);
%         windowBu=muBu(i-1:i+1,j-1:j+1);
%         for m=1:3
%             for n=1:3
%                EA1(i,j)=EA1(i,j)+(windowAu(m,n)-windowAl(m,n));
%                EA2(i,j)=EA2(i,j)+((min(windowAl(m,n),1-windowAu(m,n)))/(max(windowAl(m,n),1-windowAu(m,n))));
%                EB1(i,j)=EB1(i,j)+(windowAu(m,n)-windowAl(m,n));
%                EB2(i,j)=EB2(i,j)+((min(windowAl(m,n),1-windowAu(m,n)))/(max(windowAl(m,n),1-windowAu(m,n)))); 
%             end
%         end
%         EA(i,j)=EA1(i,j)+EA2(i,j);
%         EB(i,j)=EB1(i,j)+EB2(i,j);
%         if EA(i,j)>=EB(i,j)
%             f(i-1,j-1)=coefsA(i-1,j-1);
%         else f(i-1,j-1)=coefsB(i-1,j-1);
%         end    
%     end
% end
