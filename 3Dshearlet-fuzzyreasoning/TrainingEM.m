function [PsN, VarN, PvsN, Psv] = TrainingEM(coefs, Ps, Var, Pvs, V)
%%  采用迭代期望最大化EM算法训练Contourlet域CHMM模型参数
% Adopt Iterative EM Algorithm to Train the Parameters of CHMM in the Contourlet Domain
% Input:
% 输入对应每个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)轮廓波系数在子带中的位置]
%   coefs  : Contourlet Coefficients - 轮廓波系数
%   Ps     : 轮廓波系数在不同状态下的概率值Ps(m)
%   Var    : 轮廓波系数在不同状态下的方差值Variance(m)
%   Pvs    ：轮廓波系数在不同状态下基于上下文变量的概率值Pv|s(V=v|S=m)
%   V      : The Values of the Context Variable(MI based Context Design Procedure) - 基于互信息的上下文变量取值
%
% Output:
%   PsN    ：Updated PMF - 更新后的状态概率值
%   VarN   : Updated Variance - 更新后的方差参数，用于估计去噪系数
%   PvsN   ：Updated Pv|s(V=v|S=m) - 更新后的不同状态下基于上下文的概率值
%   Psv    : 上下文与隐状态之间的状态转移概率Ps|v(S=m|C,V) - 捕获系数之间的相关性
%
% Get the number of mixtures and the number of levels in the contourlet transform
ns = length(Ps);           %模型状态数
nlev = length(coefs);    %分解层数

%------------------------Expectation Step--E 步骤-------------------------%

% Calculate Probability for each Contourlet Coefficients as follows
% Initialize the Variable structure - 初始化变量结构
for state = 1:ns
    for s = 1: nlev
         sz=size(coefs{s});
        for l1=1:sz(1)
            for l2=1:sz(2)
        GaussPDF{state}{s}{l1,l2} = [];        %高斯条件概率密度函数 - Gauss PDF   
        ConditionalPDF{state}{s}{l1,l2} = []; 
            end
        end%条件概率密度函数 - Conditional PDF
    end
end

% Calculate the Gaussian Probability Density Function PDF and the Conditional
% Probability Density Function of the Coefficients - 计算各子带轮廓波系数的高斯
% 条件概率密度函数(Gauss PDF)以及条件概率密度函数(Conditional PDF)
for state = 1:ns
    for s = 1:nlev    %LP分解尺度
        sz=size(coefs{s});
        for l1= 1:sz(1)  %DFB各尺度方向子带数目   
           for l2=1:sz(2) 
             switch s
               case{1}
                   sz1=size(coefs{1}{1,1});
                  for l3=1:sz1(3)
                      G1= normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(Var{state}{s}{l1,l2}(:,:,l3)));
                      GaussPDF{state}{s}{l1,l2}(:,:,l3)=G1;
%             coefsAtNorm = normpdf(coefs{lev}{dir}, 0, sqrt(Var{state}{lev}{dir})); 
%             GaussPDF{state}{lev}{dir} = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                     P1 = Ps{state}{s}{l1,l2}(:,:,l3).*Pvs{state}{s}{l1,l2}(:,:,l3).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                      ConditionalPDF{state}{s}{l1,l2}(:,:,l3)=P1;
                  end
               case{2}
                   sz2=size(coefs{2}{1,1});
                  for l3=1:sz2(3)
                    G2= normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(Var{state}{s}{l1,l2}(:,:,l3)));
                      GaussPDF{state}{s}{l1,l2}(:,:,l3)=G2;
%             coefsAtNorm = normpdf(coefs{lev}{dir}, 0, sqrt(Var{state}{lev}{dir})); 
%             GaussPDF{state}{lev}{dir} = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                     P2 = Ps{state}{s}{l1,l2}(:,:,l3).*Pvs{state}{s}{l1,l2}(:,:,l3).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                      ConditionalPDF{state}{s}{l1,l2}(:,:,l3)=P2;
                  end
                case{3}
                    sz3=size(coefs{3}{1,1});
                  for l3=1:sz3(3)
                     G3 = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(Var{state}{s}{l1,l2}(:,:,l3)));
                     GaussPDF{state}{s}{l1,l2}(:,:,l3)=G3;
%             coefsAtNorm = normpdf(coefs{lev}{dir}, 0, sqrt(Var{state}{lev}{dir})); 
%             GaussPDF{state}{lev}{dir} = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                     P3 = Ps{state}{s}{l1,l2}(:,:,l3).*Pvs{state}{s}{l1,l2}(:,:,l3).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                     ConditionalPDF{state}{s}{l1,l2}(:,:,l3)=P3;
                  end
              end
            end
        end
    end
end

% Initialize the Edge PDF structure-初始化边缘概率密度函数结构
for s = 1:nlev
    sz=size(ConditionalPDF{state}{s});  
    for l1 = 1:sz(1)
        for l2=1:sz(2)
          switch s
             case{1}
                 sz1=size(coefs{1}{1,1});
                for l3=1:sz1(3)
                   EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2}(:,:,l3),1), size(coefs{s}{l1,l2}(:,:,l3),2));
                end
             case{2}
                 sz2=size(coefs{2}{1,1});
                for l3=1:sz2(3)
                   EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2}(:,:,l3),1), size(coefs{s}{l1,l2}(:,:,l3),2));
                end
             case{3}
                 sz3=size(coefs{3}{1,1});
                for l3=1:sz3(3)
                   EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2}(:,:,l3),1), size(coefs{s}{l1,l2}(:,:,l3),2));
                end
          end
        end
    end;
end

% Calculate the Edge Probability Density Function f(c) of the Contourlet
% Coefficients - 计算轮廓波系数的边缘概率密度函数
for state = 1:ns    
    for s = 1:nlev
        sz=size(ConditionalPDF{state}{s});
        for l1= 1:sz(1)
            for l2=1:sz(2)
               switch s
                  case{1}
                      sz1=size(coefs{1}{1,1});
                     for l3=1:sz1(3)
                        E1 = EdgePDF{s}{l1,l2}(:,:,l3)+ConditionalPDF{state}{s}{l1,l2}(:,:,l3);
                        EdgePDF{s}{l1,l2}(:,:,l3)=E1;
                     end
                  case{2}
                      sz2=size(coefs{2}{1,1});
                     for l3=1:sz2(3)
                       E2 = EdgePDF{s}{l1,l2}(:,:,l3)+ConditionalPDF{state}{s}{l1,l2}(:,:,l3);
                       EdgePDF{s}{l1,l2}(:,:,l3)=E2;
                     end
                  case{3}
                      sz3=size(coefs{3}{1,1});
                     for l3=1:sz3(3)
                        E3 = EdgePDF{s}{l1,l2}(:,:,l3)+ConditionalPDF{state}{s}{l1,l2}(:,:,l3);
                        EdgePDF{s}{l1,l2}(:,:,l3)=E3;
                     end
              end
            end
        end
    end
end

% Calculate the Hidden State Probability Function Ps|v(S=m|C,V) of the 
% Contourlet Coefficients - 计算轮廓波系数上下文与隐状态之间的Ps|v(S=m|C,V)
% 对每个轮廓波系数计算基于上下文变量V与隐状态之间的概率值，捕获系数之间的相关性
for state = 1:ns    
    for s = 1:nlev
        sz=size(ConditionalPDF{state}{s});
        for l1 = 1:sz(1)
            for l2 = 1:sz(2)
                switch s
                   case{1}
                       sz1=size(coefs{1}{1,1});
                      for l3=1:sz1(3)
                        C1 = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                        Psv{state}{s}{l1,l2}(:,:,l3)=C1;
                      end
                    case{2}
                        sz2=size(coefs{2}{1,1});
                      for l3=1:sz2(3)
                        C2 = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                        Psv{state}{s}{l1,l2}(:,:,l3)=C2;
                      end
                     case{3}
                         sz3=size(coefs{3}{1,1});
                      for l3=1:sz3(3)
                        C3 = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                        Psv{state}{s}{l1,l2}(:,:,l3)=C3;
                      end
                end
            end
        end
    end
end

%------------------------Maximization Step--M 步骤------------------------%

% Update Parameters for the next round of Iteration as follows
% 更新状态概率Ps(m)、方差Var(m)、Pv|s(V=v|S=m)的参数值
for state = 1:ns         %初始化变量
    for s = 1:nlev        
        PsN{state}{s} = [];
        VarN{state}{s} = [];
        PvsN{state}{s} = [];
    end;
end
for state = 1:ns
    for s = 1:nlev   
%         sz=size(Psv{state}{s})
        for l1 = 1:sz(1)
            for l2=1:sz(2)
               switch s
                  case{1}
                      sz1=size(coefs{1}{1,1});
                     for l3=1:sz1(3)
                       windowsize = ones(2*s+1);
            
            % 更新各个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)系数在子带中的位置]在不同状态下的概率值Ps(m)
                      sptmp = padarray(Psv{state}{s}{l1,l2}(:,:,l3),[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
                      Pstmp = filter2(windowsize,sptmp,'same')./prod(size(windowsize));
                      PsN{state}{s}{l1,l2}(:,:,l3) = Pstmp(s+1:end-s,s+1:end-s);
            
            % 更新各个高频子带系数C(lev,dir,k,i)在不同状态下的方差值Variance(m)
                      numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*Psv{state}{s}{l1,l2}(:,:,l3);
                      numerator = padarray(numerator,[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
                      numerator = filter2(windowsize,numerator,'same')./prod(size(windowsize));
                      VarN{state}{s}{l1,l2}(:,:,l3) = numerator(s+1:end-s,s+1:end-s)./(PsN{state}{s}{l1,l2}(:,:,l3));
            
            % 更新各个高频子带系数C(lev,dir,k,i)在不同状态下基于上下文变量的概率值Pv|s(V=v|S=m)
                      Vtmp = V{s}{l1,l2}(:,:,l3);                           %提取当前尺度各方向子带对应上下文变量V的值
                      Vtmp = padarray(Vtmp,[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
%             Vtmp = padarray(Vtmp,[lev,lev]);              %进行边界零值扩充 
                      for k = 1:size(PsN{state}{s}{l1,l2}(:,:,l3),1)
                         for i = 1:size(PsN{state}{s}{l1,l2}(:,:,l3),2)
                            sp = sptmp(k:k+2*(s),i:i+2*(s));
                            Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                            sump = 0;                             %邻域窗口用于捕获局部统计信息(Capture Local Statistics)
                           for x = 1:size(Neighbor,1)
                              for y = 1:size(Neighbor,2)
                                 if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                    sump = sump + sp(x,y);    %设置sump变量，用于计算不同状态下的隐状态概率加和 
                                 end
                               end
                           end
                    % 基于邻域窗口上下文信息更新不同状态下Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)的值
                                     PvsN{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./PsN{state}{s}{l1,l2}(k,i,l3);
                         end
                      end
                    end
                    case{2}
                        sz2=size(coefs{2}{1,1});
                     for l3=1:sz2(3)
                       windowsize = ones(2*s+1);
            
            % 更新各个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)系数在子带中的位置]在不同状态下的概率值Ps(m)
                      sptmp = padarray(Psv{state}{s}{l1,l2}(:,:,l3),[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
                      Pstmp = filter2(windowsize,sptmp,'same')./prod(size(windowsize));
                      PsN{state}{s}{l1,l2}(:,:,l3) = Pstmp(s+1:end-s,s+1:end-s);
            
            % 更新各个高频子带系数C(lev,dir,k,i)在不同状态下的方差值Variance(m)
                      numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*Psv{state}{s}{l1,l2}(:,:,l3);
                      numerator = padarray(numerator,[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
                      numerator = filter2(windowsize,numerator,'same')./prod(size(windowsize));
                      VarN{state}{s}{l1,l2}(:,:,l3) = numerator(s+1:end-s,s+1:end-s)./(PsN{state}{s}{l1,l2}(:,:,l3));
            
            % 更新各个高频子带系数C(lev,dir,k,i)在不同状态下基于上下文变量的概率值Pv|s(V=v|S=m)
                      Vtmp = V{s}{l1,l2}(:,:,l3);                           %提取当前尺度各方向子带对应上下文变量V的值
                      Vtmp = padarray(Vtmp,[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
%             Vtmp = padarray(Vtmp,[lev,lev]);              %进行边界零值扩充 
                      for k = 1:size(PsN{state}{s}{l1,l2}(:,:,l3),1)
                         for i = 1:size(PsN{state}{s}{l1,l2}(:,:,l3),2)
                            sp = sptmp(k:k+2*(s),i:i+2*(s));
                            Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                            sump = 0;                             %邻域窗口用于捕获局部统计信息(Capture Local Statistics)
                           for x = 1:size(Neighbor,1)
                              for y = 1:size(Neighbor,2)
                                 if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                    sump = sump + sp(x,y);    %设置sump变量，用于计算不同状态下的隐状态概率加和 
                                 end
                               end
                           end
                    % 基于邻域窗口上下文信息更新不同状态下Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)的值
                                     PvsN{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./PsN{state}{s}{l1,l2}(k,i,l3);
                         end
                      end
                    end
                    case{3}
                        sz3=size(coefs{3}{1,1});
                     for l3=1:sz3(3)
                       windowsize = ones(2*s+1);
            
            % 更新各个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)系数在子带中的位置]在不同状态下的概率值Ps(m)
                      sptmp = padarray(Psv{state}{s}{l1,l2}(:,:,l3),[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
                      Pstmp = filter2(windowsize,sptmp,'same')./prod(size(windowsize));
                      PsN{state}{s}{l1,l2}(:,:,l3) = Pstmp(s+1:end-s,s+1:end-s);
            
            % 更新各个高频子带系数C(lev,dir,k,i)在不同状态下的方差值Variance(m)
                      numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*Psv{state}{s}{l1,l2}(:,:,l3);
                      numerator = padarray(numerator,[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
                      numerator = filter2(windowsize,numerator,'same')./prod(size(windowsize));
                      VarN{state}{s}{l1,l2}(:,:,l3) = numerator(s+1:end-s,s+1:end-s)./(PsN{state}{s}{l1,l2}(:,:,l3));
            
            % 更新各个高频子带系数C(lev,dir,k,i)在不同状态下基于上下文变量的概率值Pv|s(V=v|S=m)
                      Vtmp = V{s}{l1,l2}(:,:,l3);                           %提取当前尺度各方向子带对应上下文变量V的值
                      Vtmp = padarray(Vtmp,[s,s],'symmetric');  %围绕边界进行镜像反射来扩展
%             Vtmp = padarray(Vtmp,[lev,lev]);              %进行边界零值扩充 
                      for k = 1:size(PsN{state}{s}{l1,l2}(:,:,l3),1)
                         for i = 1:size(PsN{state}{s}{l1,l2}(:,:,l3),2)
                            sp = sptmp(k:k+2*(s),i:i+2*(s));
                            Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                            sump = 0;                             %邻域窗口用于捕获局部统计信息(Capture Local Statistics)
                           for x = 1:size(Neighbor,1)
                              for y = 1:size(Neighbor,2)
                                 if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                    sump = sump + sp(x,y);    %设置sump变量，用于计算不同状态下的隐状态概率加和 
                                 end
                               end
                           end
                    % 基于邻域窗口上下文信息更新不同状态下Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)的值
                                     PvsN{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./PsN{state}{s}{l1,l2}(k,i,l3);
                         end
                      end
                    end
                end
             end
         end
    end
end