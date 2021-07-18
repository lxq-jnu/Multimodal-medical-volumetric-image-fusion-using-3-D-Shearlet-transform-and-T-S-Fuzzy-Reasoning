function [V ,context] = CalContext(coefs)
%% The Values of the Context Variable is represented by a two-bit binary string [Vp，Vn，Vc]
% 计算上下文变量Context的值，用0、1字串表示[Parent Contexts|Neighbor Contexts|Cousins Contexts]，
% 第二种上下文设计方案基于父系数(尺度间)、8个最近邻系数(尺度内即空间邻域内)、两个最近邻兄弟系数(方向间)的组合来捕获轮廓波系数的相关性。
% Input:
%   coefs  ：the Contourlet Coefficients which we use to Calculate Contexts.
%
% Output:
%   V      ：The Values of the Context Variable(Context Design Procedure)
%   context：the derived values to estimate the Energy Mutual Information
%   衍生值  ：用于估计能量互信息EMI，衡量系数平方和context之间的相关性
%
%% 关于扩充图像(矩阵)或数组的功能函数--padarray()的使用说明
% B = padarray(A,padsize,padval,direction)
% A为输入图像，B为填充后的图像，padsize给出填充的行数和列数，通常用[r c]来表示。
% padval和direction分别表示填充方法和方向。它们的具体值和描述如下：
%     padval: 'symmetric'表示图像大小通过围绕边界进行镜像反射来扩展；
%             'replicate'表示图像大小通过复制外边界中的值来扩展；
%             'circular'图像大小通过将图像看成是一个二维周期函数的一个周期来进行扩展。
%     direction: 'pre'表示在每一维的第一个元素前填充；
%                'post'表示在每一维的最后一个元素后填充；
%                'both'表示在每一维的第一个元素前和最后一个元素后填充，此项为默认值。
% 若参量中不包括direction，则默认值为'both'。若参量中不包含padval，则默认用零来填充。
% 若参量中不包括任何参数，则默认填充为零且方向为'both'。在计算结束时，图像会被修剪成原始大小。

%%
% NAi, NBi，P，C1 and C2 denote direct, diagonal/counter-diagonal(either NBp 
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
%%%%灰度
% w0 = 0.6; w1 =0.6; w2 =1; w3 = 0.8; w4=1; 
% w0 = 0.8; w1 =0.8; w2 =1; w3 =1; w4=1; 
% w0 = 0.4; w1 =0.4; w2 =1; w3 =0.8; w4=1;
% w0 = 0.4; w1 =0.4; w2 =0.8; w3 =0.6; w4=0.8;
% w0 = 0.4; w1 =0.4; w2 =0.6; w3 =0.4; w4=0.6;
% w0 = 0.2; w1 =0.2; w2 =0.4; w3 =0.2; w4=0.2;
% w0 = 0; w1 =0; w2 =0.001; w3 =0; w4=0;

%%%%%彩色
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
% Setting the Structure of the Parent(P) - 初始化父节点系数P变量结构
for s=1:level
%     sz=size(coefs{s}{1,1});
    ksz=size(coefs{s});
    for l1=1:ksz(1)
        for l2=1:ksz(2)
            
        % 最高尺度即最粗糙子带轮廓波系数没有父节点，设P为零值
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
                 
        % 最高尺度即最粗糙子带轮廓波系数没有父节点，设P为零值
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
%         % 判断相邻尺度方向子带数目是否相同
% %         if(length(coefs{s}(1))==length(coefs{s+1}(1))&&length(coefs{s}(2))==length(coefs{s+1}(2)))
%             % 相邻尺度方向子带数目相同，类似小波域父子节点对应关系(1:4),每个父系数的4个
%             % 孩子总位于同一个方向子带中；而轮廓波域父系数的4个孩子可位于不同的方向子带中；
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%             P{s+1}{l1,l2} = coefs{s}{l1,l2};
%                
% %         else
% %             % 相邻尺度方向子带数目不同(分为水平方向和垂直方向子带)
% %             ratio = size(coefs{s+1}{2*l1,2*l2})./size(coefs{s}{l1,l2});
% %             if(ratio(1)==1)      %The subband is Horizontal - 子带水平
% %                 P{s+1}{2*l1-1,l2}(:, 1:2:end) = coefs{s}{l1,l2};
% %                 P{s+1}{2*l1-1,l2}(:, 2:2:end) = coefs{s}{l1,l2};
% %                 P{s+1}{2*l1,l2}(:, 1:2:end) = coefs{s}{l1,l2};
% %                 P{s+1}{2*l1,l2}(:, 2:2:end) = coefs{s}{l1,l2};
% %             elseif(ratio(2)==1)  %The subband is Vertical - 子带垂直
% %                 P{lev+1}{2*l1-1,l2}(1:2:end, :) = coefs{s}{l1,l2};
% %                 P{lev+1}{2*l1-1,l2}(2:2:end, :) = coefs{s}{l1,l2};
% %                 P{lev+1}{2*l1,l2}(1:2:end, :) = coefs{s}{l1,l2};
% %                 P{lev+1}{2*l1,l2}(2:2:end, :) = coefs{s}{l1,l2};
%             
%          end
%      end
% end
%    

% 设置3*3邻域窗口捕获8个最近邻系数相关性信息
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
        % samelevel,respectively - 计算Ex(E, Ep, Ec1 and Ec2)的子带系数平均能量。
        E= mean2(coefstmp0);
        
        Ep = mean2(Ptmp);
        
        Ec1 = mean2(C1.*C1);  
        Ec2 = mean2(C2.*C2);
        Ef1=mean2(F1.*F1);
        Ef2=mean2(F2.*F2);
      
%            V{s}{l1,l2}(:,:,l3)=zeros(size(coefs{s}{l11,l21},1),size(coefs{s}{l11,l21},2));       
        % under this design，the Context Value V(j,k,i) is determined as follows:
        % 调节因子采用经验值，根据此设计方案来计算上下文变量V(j尺度/(k,i)位置)的值
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
        % samelevel,respectively - 计算Ex(E, Ep, Ec1 and Ec2)的子带系数平均能量。
        E= mean2(coefstmp0);
        
        Ep = mean2(Ptmp);
        
        Ec1 = mean2(C1.*C1);  
        Ec2 = mean2(C2.*C2);
        Ef1=mean2(F1.*F1);
        Ef2=mean2(F2.*F2);
%            V{s}{l1,l2}(:,:,l3)=zeros(size(coefs{s}{l11,l21},1),size(coefs{s}{l11,l21},2));       
        % under this design，the Context Value V(j,k,i) is determined as follows:
        % 调节因子采用经验值，根据此设计方案来计算上下文变量V(j尺度/(k,i)位置)的值
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
        % samelevel,respectively - 计算Ex(E, Ep, Ec1 and Ec2)的子带系数平均能量。
        E= mean2(coefstmp0);
        
        Ep = mean2(Ptmp);
        
        Ec1 = mean2(C1.*C1);  
        Ec2 = mean2(C2.*C2);
        Ef1=mean2(F1.*F1);
        Ef2=mean2(F2.*F2);
%            V{s}{l1,l2}(:,:,l3)=zeros(size(coefs{s}{l11,l21},1),size(coefs{s}{l11,l21},2));       
        % under this design，the Context Value V(j,k,i) is determined as follows:
        % 调节因子采用经验值，根据此设计方案来计算上下文变量V(j尺度/(k,i)位置)的值
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
        % 确定同一尺度内最邻近方向的两个兄弟系数子带及其对应关系


