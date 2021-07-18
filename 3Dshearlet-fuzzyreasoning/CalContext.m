function [V ,context] = CalContext(coefs)
%% The Values of the Context Variable is represented by a two-bit binary string [Vp��Vn��Vc]
% ���������ı���Context��ֵ����0��1�ִ���ʾ[Parent Contexts|Neighbor Contexts|Cousins Contexts]��
% �ڶ�����������Ʒ������ڸ�ϵ��(�߶ȼ�)��8�������ϵ��(�߶��ڼ��ռ�������)������������ֵ�ϵ��(�����)�����������������ϵ��������ԡ�
% Input:
%   coefs  ��the Contourlet Coefficients which we use to Calculate Contexts.
%
% Output:
%   V      ��The Values of the Context Variable(Context Design Procedure)
%   context��the derived values to estimate the Energy Mutual Information
%   ����ֵ  �����ڹ�����������ϢEMI������ϵ��ƽ����context֮��������
%
%% ��������ͼ��(����)������Ĺ��ܺ���--padarray()��ʹ��˵��
% B = padarray(A,padsize,padval,direction)
% AΪ����ͼ��BΪ�����ͼ��padsize��������������������ͨ����[r c]����ʾ��
% padval��direction�ֱ��ʾ��䷽���ͷ������ǵľ���ֵ���������£�
%     padval: 'symmetric'��ʾͼ���Сͨ��Χ�Ʊ߽���о���������չ��
%             'replicate'��ʾͼ���Сͨ��������߽��е�ֵ����չ��
%             'circular'ͼ���Сͨ����ͼ�񿴳���һ����ά���ں�����һ��������������չ��
%     direction: 'pre'��ʾ��ÿһά�ĵ�һ��Ԫ��ǰ��䣻
%                'post'��ʾ��ÿһά�����һ��Ԫ�غ���䣻
%                'both'��ʾ��ÿһά�ĵ�һ��Ԫ��ǰ�����һ��Ԫ�غ���䣬����ΪĬ��ֵ��
% �������в�����direction����Ĭ��ֵΪ'both'���������в�����padval����Ĭ����������䡣
% �������в������κβ�������Ĭ�����Ϊ���ҷ���Ϊ'both'���ڼ������ʱ��ͼ��ᱻ�޼���ԭʼ��С��

%%
% NAi, NBi��P��C1 and C2 denote direct, diagonal/counter-diagonal(either NBp 
% or NBq) Neighbors, Parent and two cloest Cousins respectively.
% w0 = 1; w1 = 0.6; w2 = 0.2; w3 = 0;    %combined with the Parent
% w0 = 1; w1 = 0.6; w2 = 0; w3 = 0.6;    %combined with the two closest Cousins
% w0 = 1; w1 =1; w2 =1; w3 = 1; w4=1;     %combined with both the Parent and the two Cousins 
% w0 = 0.0247; w1 = 0.8795; w2 = 0.3716; w3 = 0.4780;
% w0 = 0.1; w1 = 0.9; w2 = 0.4; w3 = 0.5;

% w0 = 1; w1 = 0.4; w2 = 0.6; w3 = 0.2;;
% w0 = 1; w1 = 0.6; w2 = 0.2; w3 = 0.6;
% w0 = 1; w1 = 0.8; w2 = 0; w3 = 0.4;
% w0 = 1; w1 = 0.8; w2 = 1; w3 = 0;

% w0 = 1; w1 = 1; w2 = 1; w3 = 1;
%%%%�Ҷ�
% w0 = 0.6; w1 =0.6; w2 =1; w3 = 0.8; w4=1; 
% w0 = 0.8; w1 =0.8; w2 =1; w3 =1; w4=1; 
% w0 = 0.4; w1 =0.4; w2 =1; w3 =0.8; w4=1;
% w0 = 0.4; w1 =0.4; w2 =0.8; w3 =0.6; w4=0.8;
% w0 = 0.4; w1 =0.4; w2 =0.6; w3 =0.4; w4=0.6;
% w0 = 0.2; w1 =0.2; w2 =0.4; w3 =0.2; w4=0.2;
% w0 = 0; w1 =0; w2 =0.001; w3 =0; w4=0;

%%%%%��ɫ
% w0 = 1; w1 =0; w2 =0; w3 = 0; w4=0;     %combined with both the Parent and the two Cousins
% w0 = 1; w1 =1; w2 =0.4; w3 = 0.8; w4=0.6; 
% w0 = 1; w1 =1; w2 =0.6; w3 = 0.8; w4=0.8;
% w0 = 1; w1 =1; w2 =0.6; w3 = 1; w4=0.8;
% w0 = 1; w1 =1; w2 =0.8; w3 = 1; w4=1;
% % % % % % % % % % % w0 = 0.8; w1 =1; w2 =0.4; w3 = 0.6; w4=0.6;
% w0 = 1; w1 =0; w2 =0; w3 = 0; w4=0;
w0 = 0.8; w1 =0.8; w2 =0.2; w3 = 0.6; w4=0.4;
% w0 = 0.4; w1 =0.4; w2 =0.2; w3 = 0.3; w4=0.2;
% w0 = 0.1; w1 =0.1; w2 =0.1; w3 = 0.1; w4=0.1;
% w0 = 0.3; w1 =0.3; w2 =0.1; w3 = 0.2; w4=0.2;
% w0 = 0.1; w1 =0.1; w2 =0.01; w3 = 0.1; w4=0.01;
% w0 = 1; w1 =1; w2 =1; w3 = 0.6; w4=1;
% w0 = 1; w1 =1; w2 =1; w3 = 0.8; w4=1;
% w0 = 1; w1 =0.8; w2 =0.8; w3 = 0.6; w4=0.8;
% w0 = 1; w1 =0.8; w2 =0.6; w3 = 0.4; w4=0.6;
%  w0 = 0.8; w1 =0.8; w2 =0.8; w3 = 0.4; w4=0.8;
% w0 = 1; w1 =1; w2 =0.8; w3 = 0.7; w4=0.8;
% w0 = 1; w1 =1; w2 =1; w3 = 0.9; w4=1;
% w0 = 1; w1 =1; w2 =0.9; w3 = 0.9; w4=0.9;
% w0 = 1; w1 =1; w2 =0.8; w3 = 0.9; w4=0.8;
% w0 = 1; w1 =1; w2 =1; w3 = 0.6; w4=1;
% w0 = 1; w1 =1; w2 =0.8; w3 = 0.7; w4=0.8;
level=3;
% Setting the Structure of the Parent(P) - ��ʼ�����ڵ�ϵ��P�����ṹ
for s=1:level
%     sz=size(coefs{s}{1,1});
    ksz=size(coefs{s});
    for l1=1:ksz(1)
        for l2=1:ksz(2)
            
        % ��߳߶ȼ���ֲ��Ӵ�������ϵ��û�и��ڵ㣬��PΪ��ֵ
        P{s}{l1,l2} = zeros(size(coefs{s}{l1,l2},1),size(coefs{s}{l1,l2},2),size(coefs{s}{l1,l2},3));
       
        end
    end
end
for s=1:level
%     sz=size(coefs{s}{1,1});
    ksz=size(coefs{s});
    for l1=1:ksz(1)
        for l2=1:ksz(2)
           switch s
              
              case{1}
                  
                 P{s}{l1,l2}(1:1.5:end,1:1.5:end,1:1.5:end) = coefs{s+1}{l1,l2};
                  P{s}{l1,l2}(1.5:1.5:end,1:1.5:end,1:1.5:end) = coefs{s+1}{l1,l2};
                   P{s}{l1,l2}(1:1.5:end,1.5:1.5:end,1:1.5:end) = coefs{s+1}{l1,l2};
                    P{s}{l1,l2}(1.5:1.5:end,1.5:1.5:end,1:1.5:end) = coefs{s+1}{l1,l2};
                    
                     P{s}{l1,l2}(1:1.5:end,1:1.5:end,1.5:1.5:end) = coefs{s+1}{l1,l2};
                  P{s}{l1,l2}(1.5:1.5:end,1:1.5:end,1.5:1.5:end) = coefs{s+1}{l1,l2};
                   P{s}{l1,l2}(1:1.5:end,1.5:1.5:end,1.5:1.5:end) = coefs{s+1}{l1,l2};
                    P{s}{l1,l2}(1.5:1.5:end,1.5:1.5:end,1.5:1.5:end) = coefs{s+1}{l1,l2};
              case{2}
                  P{s}{l1,l2}(1:2:end,1:2:end,1:2:end) = coefs{s+1}{l1,l2};
                  P{s}{l1,l2}(2:2:end,1:2:end,1:2:end) = coefs{s+1}{l1,l2};
                   P{s}{l1,l2}(1:2:end,2:2:end,1:2:end) = coefs{s+1}{l1,l2};
                    P{s}{l1,l2}(2:2:end,2:2:end,1:2:end) = coefs{s+1}{l1,l2};
                    
                     P{s}{l1,l2}(1:2:end,1:2:end,2:2:end) = coefs{s+1}{l1,l2};
                  P{s}{l1,l2}(2:2:end,1:2:end,2:2:end) = coefs{s+1}{l1,l2};
                   P{s}{l1,l2}(1:2:end,2:2:end,2:2:end) = coefs{s+1}{l1,l2};
                    P{s}{l1,l2}(2:2:end,2:2:end,2:2:end) = coefs{s+1}{l1,l2};
                 
        % ��߳߶ȼ���ֲ��Ӵ�������ϵ��û�и��ڵ㣬��PΪ��ֵ
           end
        
        end
    end
end
% for s=1:level-1
%     sz=size(coefs{s}{1,1});
%     ksz=size(coefs{s});
%     for l1=1:ksz(1)
%         for l2=1:ksz(2)
%           
%            
%         % �ж����ڳ߶ȷ����Ӵ���Ŀ�Ƿ���ͬ
% %         if(length(coefs{s}(1))==length(coefs{s+1}(1))&&length(coefs{s}(2))==length(coefs{s+1}(2)))
%             % ���ڳ߶ȷ����Ӵ���Ŀ��ͬ������С�����ӽڵ��Ӧ��ϵ(1:4),ÿ����ϵ����4��
%             % ������λ��ͬһ�������Ӵ��У�����������ϵ����4�����ӿ�λ�ڲ�ͬ�ķ����Ӵ��У�
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%                
% %         else
% %             % ���ڳ߶ȷ����Ӵ���Ŀ��ͬ(��Ϊˮƽ����ʹ�ֱ�����Ӵ�)
% %             ratio = size(coefs{s+1}{2*l1,2*l2})./size(coefs{s}{l1,l2});
% %             if(ratio(1)==1)      %The subband is Horizontal - �Ӵ�ˮƽ
% %                 P{s+1}{2*l1-1,l2}(:, 1:2:end) = coefs{s}{l1,l2};
% %                 P{s+1}{2*l1-1,l2}(:, 2:2:end) = coefs{s}{l1,l2};
% %                 P{s+1}{2*l1,l2}(:, 1:2:end) = coefs{s}{l1,l2};
% %                 P{s+1}{2*l1,l2}(:, 2:2:end) = coefs{s}{l1,l2};
% %             elseif(ratio(2)==1)  %The subband is Vertical - �Ӵ���ֱ
% %                 P{lev+1}{2*l1-1,l2}(1:2:end, :) = coefs{s}{l1,l2};
% %                 P{lev+1}{2*l1-1,l2}(2:2:end, :) = coefs{s}{l1,l2};
% %                 P{lev+1}{2*l1,l2}(1:2:end, :) = coefs{s}{l1,l2};
% %                 P{lev+1}{2*l1,l2}(2:2:end, :) = coefs{s}{l1,l2};
%             
%          end
%      end
% end
%    

% ����3*3���򴰿ڲ���8�������ϵ���������Ϣ
a = [0 1 0; 1 0 1; 0 1 0];
b = [1 0 1; 0 0 0; 1 0 1];
 sum=0;
 for s=1:level
%     sz=size(coefs{s}{1,1});
 ksz=size(coefs{s});
    for l1=1:ksz(1)
        for l2=1:ksz(2)
            switch s
            case {1}
                sz1=size(coefs{1}{1,1});
               for l3=1:sz1(3)
                coefstmp0 = double(coefs{s}{l1,l2}(:,:,l3).*coefs{s}{l1,l2}(:,:,l3));
                coefstmp = padarray(coefstmp0,[1,1],'symmetric');
                NA1 = filter2(a,coefstmp,'same');
                NA = NA1(2:end-1,2:end-1);
                NB1 = filter2(b,coefstmp,'same');
                NB = NB1(2:end-1,2:end-1);
                
                l11 = l1-1;
                l12 = l1+1;
                l21 = l2-1;
                l22 = l2+1;
               if(l1==1)
                   l11 =length(coefs{s});
               end
               if (l2==1)
                  l21 = length(coefs{s});
               end
               if (l1==length(coefs{s}))
                  l12=1;
               end
               if (l2==length(coefs{s}))
                   l22=1;
               end
                  
                  C1 = double(coefs{s}{l11,l12}(:,:,l3));
                  C2 = double(coefs{s}{l21,l22}(:,:,l3));
                  
                  if l3==1
                      F1=zeros(size(coefs{s}{l1,l2},1),size(coefs{s}{l1,l2},2));
                      F2=coefs{s}{l1,l2}(:,:,l3+1);
                  elseif l3==12
                       F2=zeros(size(coefs{s}{l1,l2},1),size(coefs{s}{l1,l2},2));
                       F1=coefs{s}{l1,l2}(:,:,l3-1);
                  else 
                       F1=coefs{s}{l1,l2}(:,:,l3-1);
                       F2=coefs{s}{l1,l2}(:,:,l3+1);
                  end
        
        Ptmp = P{s}{l1,l2}(:,:,l3).*P{s}{l1,l2}(:,:,l3);
       

        context{s}{l1,l2}(:,:,l3) = w0*NA+ w1*NB+ w2*Ptmp+w3*(C1.*C1+C2.*C2)+w4*(F1.*F1+F2.*F2)  ;
       
%           normalized_matrix1=Normalized(context{s}{l1,l2}(:,:,l3));
%          normalized_matrix2=Normalized(coefs{s}{l1,l2}(:,:,l3));
%          normalized_matrix11=uint8(normalized_matrix1*255);
%          normalized_matrix22=uint8(normalized_matrix2*255);
%          MI=mi1( normalized_matrix11, normalized_matrix22);
        % E, Ep, Ec1 and Ec2 denote the Average Energy for the Current Subband,
        % the Parent Subband, and the Two Adjacent Directional Subbands at the
        % samelevel,respectively - ����Ex(E, Ep, Ec1 and Ec2)���Ӵ�ϵ��ƽ��������
        E= mean2(coefstmp0);
        
        Ep = mean2(Ptmp);
        
        Ec1 = mean2(C1.*C1);  
        Ec2 = mean2(C2.*C2);
        Ef1=mean2(F1.*F1);
        Ef2=mean2(F2.*F2);
      
%            V{s}{l1,l2}(:,:,l3)=zeros(size(coefs{s}{l11,l21},1),size(coefs{s}{l11,l21},2));       
        % under this design��the Context Value V(j,k,i) is determined as follows:
        % �������Ӳ��þ���ֵ�����ݴ���Ʒ��������������ı���V(j�߶�/(k,i)λ��)��ֵ
        for k = 1:size(context{s}{l1,l2},1)
            for t = 1:size(context{s}{l1,l2},2)
                if(context{s}{l1,l2}(k,t,l3) >= (4*w0*E + 4*w1*E + w2*Ep + w3*(Ec1+Ec2)+w4*(Ef1+Ef2)))
                    V{s}{l1,l2}(k,t,l3) = 1;
                else
                     V{s}{l1,l2}(k,t,l3) = 0;
                end
            end
        end
 
               
               end
              
         
                case {2}
                    sz2=size(coefs{2}{1,1});
                  for l3=1:sz2(3)
                coefstmp0 = double(coefs{s}{l1,l2}(:,:,l3).*coefs{s}{l1,l2}(:,:,l3));
                coefstmp = padarray(coefstmp0,[1,1],'symmetric');
                NA = filter2(a,coefstmp,'same');
                NA = NA(2:end-1,2:end-1);
                NB = filter2(b,coefstmp(:,:,1),'same');
                NB = NB(2:end-1,2:end-1);
                
                l11 = l1-1;
                l12 = l1+1;
                l21 = l2-1;
                l22 = l2+1;
               if(l1==1)
                   l11 =length(coefs{s});
               end
               if (l2==1)
                  l21 = length(coefs{s});
               end
               if (l1==length(coefs{s}))
                  l12=1;
               end
               if (l2==length(coefs{s}))
                   l22=1;
               end
                     
              
                  C1 = coefs{s}{l11,l12}(:,:,l3);
                  C2 = coefs{s}{l21,l22}(:,:,l3);
                  
                  if l3==1
                      F1=zeros(size(coefs{s}{l1,l2},1),size(coefs{s}{l1,l2},2));
                      F2=coefs{s}{l1,l2}(:,:,l3+1);
                  elseif l3==8
                       F2=zeros(size(coefs{s}{l1,l2},1),size(coefs{s}{l1,l2},2));
                       F1=coefs{s}{l1,l2}(:,:,l3-1);
                  else 
                       F1=coefs{s}{l1,l2}(:,:,l3-1);
                       F2=coefs{s}{l1,l2}(:,:,l3+1);
                  end
        
        Ptmp = P{s}{l1,l2}(:,:,l3).*P{s}{l1,l2}(:,:,l3);
       

         context{s}{l1,l2}(:,:,l3) =  w0*NA+ w1*NB+w2*Ptmp+w3*(C1.*C1+C2.*C2)+w4*(F1.*F1+F2.*F2)  ;
        
        % E, Ep, Ec1 and Ec2 denote the Average Energy for the Current Subband,
        % the Parent Subband, and the Two Adjacent Directional Subbands at the
        % samelevel,respectively - ����Ex(E, Ep, Ec1 and Ec2)���Ӵ�ϵ��ƽ��������
        E= mean2(coefstmp0);
        
        Ep = mean2(Ptmp);
        
        Ec1 = mean2(C1.*C1);  
        Ec2 = mean2(C2.*C2);
        Ef1=mean2(F1.*F1);
        Ef2=mean2(F2.*F2);
%            V{s}{l1,l2}(:,:,l3)=zeros(size(coefs{s}{l11,l21},1),size(coefs{s}{l11,l21},2));       
        % under this design��the Context Value V(j,k,i) is determined as follows:
        % �������Ӳ��þ���ֵ�����ݴ���Ʒ��������������ı���V(j�߶�/(k,i)λ��)��ֵ
        for k = 1:size(context{s}{l1,l2},1)
            for t = 1:size(context{s}{l1,l2},2)
                if(context{s}{l1,l2}(k,t,l3) >= (4*w0*E + 4*w1*E + w2*Ep + w3*(Ec1+Ec2)+w4*(Ef1+Ef2)))
                    V{s}{l1,l2}(k,t,l3) = 1;
                else
                     V{s}{l1,l2}(k,t,l3) = 0;
                end
            end
        end
%  
               
                  end
        
                case {3}
                    sz3=size(coefs{3}{1,1});
                        for l3=1:sz3(3)
                coefstmp0 = double(coefs{s}{l1,l2}(:,:,l3).*coefs{s}{l1,l2}(:,:,l3));
                coefstmp = padarray(coefstmp0,[1,1],'symmetric');
                NA1 = filter2(a,coefstmp,'same');
                NA = NA1(2:end-1,2:end-1);
                NB1 = filter2(b,coefstmp(:,:,1),'same');
                NB = NB1(2:end-1,2:end-1);
                Na{s}{l1,l2}(:,:,l3)=NA;
                Nb{s}{l1,l2}(:,:,l3)=NB;
                l11 = l1-1;
                l12 = l1+1;
                l21 = l2-1;
                l22 = l2+1;
               if(l1==1)
                   l11 =length(coefs{s});
               end
               if (l2==1)
                  l21 = length(coefs{s});
               end
               if (l1==length(coefs{s}))
                  l12=1;
               end
               if (l2==length(coefs{s}))
                   l22=1;
               end
                     
              
                  C1 = coefs{s}{l11,l12}(:,:,l3);
                  C2 = coefs{s}{l21,l22}(:,:,l3);
                  if l3==1
                      F1=zeros(size(coefs{s}{l1,l2},1),size(coefs{s}{l1,l2},2));
                      F2=coefs{s}{l1,l2}(:,:,l3+1);
                  elseif l3==4
                       F2=zeros(size(coefs{s}{l1,l2},1),size(coefs{s}{l1,l2},2));
                       F1=coefs{s}{l1,l2}(:,:,l3-1);
                  else 
                       F1=coefs{s}{l1,l2}(:,:,l3-1);
                       F2=coefs{s}{l1,l2}(:,:,l3+1);
                  end
       
        
        Ptmp = P{s}{l1,l2}(:,:,l3).*P{s}{l1,l2}(:,:,l3);
%         ptmp{s}{l1,l2}(:,:,l3)=Ptmp;
%         c1{s}{l1,l2}(:,:,l3)=C1;
%          c2{s}{l1,l2}(:,:,l3)=C2;
%           f1{s}{l1,l2}(:,:,l3)=F1;
%            f2{s}{l1,l2}(:,:,l3)=F2;
        context{s}{l1,l2}(:,:,l3) =  w0*NA+ w1*NB+ w2*Ptmp+ w3*(C1.*C1+C2.*C2)+w4*(F1.*F1+F2.*F2) ;
%           mm1=Normalized(context{s}{l1,l2}(:,:,l3));
%         mm2=Normalized(coefs{s}{l1,l2}(:,:,l3).*coefs{s}{l1,l2}(:,:,l3));
%         mm11=uint8(mm1*255);
%         mm22=uint8(mm2*255);
%         MI=mi1(mm11,mm22);
%         
%        sum=sum+MI;
        % E, Ep, Ec1 and Ec2 denote the Average Energy for the Current Subband,
        % the Parent Subband, and the Two Adjacent Directional Subbands at the
        % samelevel,respectively - ����Ex(E, Ep, Ec1 and Ec2)���Ӵ�ϵ��ƽ��������
        E= mean2(coefstmp0);
        
        Ep = mean2(Ptmp);
        
        Ec1 = mean2(C1.*C1);  
        Ec2 = mean2(C2.*C2);
        Ef1=mean2(F1.*F1);
        Ef2=mean2(F2.*F2);
%            V{s}{l1,l2}(:,:,l3)=zeros(size(coefs{s}{l11,l21},1),size(coefs{s}{l11,l21},2));       
        % under this design��the Context Value V(j,k,i) is determined as follows:
        % �������Ӳ��þ���ֵ�����ݴ���Ʒ��������������ı���V(j�߶�/(k,i)λ��)��ֵ
        for k = 1:size(context{s}{l1,l2},1)
            for t = 1:size(context{s}{l1,l2},2)
                if(context{s}{l1,l2}(k,t,l3) >= (4*w0*E + 4*w1*E + w2*Ep + w3*(Ec1+Ec2)+w4*(Ef1+Ef2)))
                    V{s}{l1,l2}(k,t,l3) = 1;
                else
                     V{s}{l1,l2}(k,t,l3) = 0;
                end
            end
        end
% %  
%                

                        end
%                   result=sum/4;        
            end
             
      
         
       end
    end
     
    
 end
 
 
%  
% for i=1:2
%     for j=1:2
%         for t=1:4   
%            z0{i,j}(t)=mi(im2uint8(coefs{3}{i,j}(:,:,t)).^2,im2uint8(Na{3}{i,j}(:,:,t)));
%            z1{i,j}(t)=mi(im2uint8(coefs{3}{i,j}(:,:,t)).^2,im2uint8(Nb{3}{i,j}(:,:,t)));
%            z2{i,j}(t)=mi(im2uint8(coefs{3}{i,j}(:,:,t)).^2,im2uint8(ptmp{3}{i,j}(:,:,t)));
%            z3{i,j}(t)=mi(im2uint8(coefs{3}{i,j}(:,:,t)).^2,im2uint8(c1{3}{i,j}(:,:,t).*c1{3}{i,j}(:,:,t)+c2{3}{i,j}(:,:,t).*c2{3}{i,j}(:,:,t)));
%            z4{i,j}(t)=mi(im2uint8(coefs{3}{i,j}(:,:,t)).^2,im2uint8(f1{3}{i,j}(:,:,t).*f1{3}{i,j}(:,:,t)+f2{3}{i,j}(:,:,t).*f2{3}{i,j}(:,:,t)));
% %            zB{i,j}(t)=mi(b{i,j}(:,:,t).^2,im2uint8(contextB{3}{i,j}(:,:,t)));
%         end
%     end
% end
% % clear a;
% % clear b;
% 
% EMIa0 = zeros(1,4);
% EMIa1 = zeros(1,4);
% EMIa2 = zeros(1,4);
% EMIa3 = zeros(1,4);
% EMIa4 = zeros(1,4);
% 
% for t=1:4
%   for i=1:2
%      for j=1:2
%        
% 
%     EMIa0(t) = EMIa0(t) +z0{i,j}(t);
%     EMIa1(t)= EMIa1(t) + z1{i,j}(t);
%      EMIa2(t)= EMIa2(t) + z2{i,j}(t);
%      EMIa3(t)= EMIa3(t) + z3{i,j}(t);
%       EMIa4(t)= EMIa4(t) + z4{i,j}(t);
%      end
%   end
%   EMIa0(t) = EMIa0(t)/4;
%   EMIa1(t) = EMIa1(t)/4;
%   EMIa2(t) = EMIa2(t)/4;
%   EMIa3(t) = EMIa3(t)/4;
%   EMIa4(t) = EMIa4(t)/4;
% end
% for t=1:3
% EMIa00=EMIa0(t)+EMIa0(t+1);
% EMIa11=EMIa1(t)+EMIa1(t+1);
% EMIa22=EMIa2(t)+EMIa2(t+1);
% EMIa33=EMIa3(t)+EMIa3(t+1);
% EMIa44=EMIa4(t)+EMIa4(t+1);
% end
% 
% EMIa0 = EMIa00/4;
% EMIa1 = EMIa11/4;
% EMIa2 = EMIa22/4;
% EMIa3 = EMIa33/4;
% EMIa4 = EMIa44/4;
% ss=1;

 
% 
%           NA = a.*coefs{s}{l1,l2};
%           NB = b.*coefs{a}{l1,l2};
        % ȷ��ͬһ�߶������ڽ�����������ֵ�ϵ���Ӵ������Ӧ��ϵ


