function [Ps, Var, Pvs] = SetParameters0(coefs, model, stateprob, V)
%% Finish the Initialization Stage by Setting the Following Parameters
% Input:
%   coefs     : Contourlet Coefficients - 轮廓波系数
%   model     : Initial Model by EM Step - 采用EM步骤初始化后的模型
%   stateprob : The Post State Probability - 隐状态概率P(Si=m|C,Θ)
%   V         : The Values of the Context Variable(MI based Context Design Procedure) - 基于互信息的上下文变量取值
%
% Output:
% 输出结果对应每个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)轮廓波系数在子带中的位置]
%   Ps        : 轮廓波系数在不同状态下的概率值Ps(m)
%   Var       : 轮廓波系数在不同状态下的方差值Variance(m)
%   Pvs       ：轮廓波系数在不同状态下基于上下文变量的概率值Pv|s(V=v|S=m)
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
ns = model.nstates;      %状态数目
nlev = model.nlevels;    %分解尺度
for state = 1:ns         %初始化变量
    for s = 1:nlev       
        Ps{state}{s} = [];
        Var{state}{s} = [];
        Pvs{state}{s} = [];

    end;
end

% Window Size - 不同尺度选用不同的窗口大小 - 5*5、7*7、9*9、11*11
% windowsize1 = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1;1 1 1 1 1; 1 1 1 1 1];
% windowsize2 = [1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1;
%                1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1];
% windowsize3 = [1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1;
%                1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1;
%                1 1 1 1 1 1 1 1 1];
% windowsize4 = ones(11,11);    %产生11×11大小的局域窗口

for state = 1:ns
    for s = 1:nlev  
        sz=size(stateprob{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(2)
              switch s
                case{1}
                     sz1=size(coefs{1}{1,1});
                 for l3=1:sz1(1)
            windowsize = ones(2*s+1);
            
            % 计算各个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)系数在子带中的位置]在不同状态下的概率值Ps(m)
            Ps{state}{s}{l1,l2}(:,:,l3) = filter2(windowsize,stateprob{state}{s}{l1,l2}(:,:,l3),'same')./prod(size(windowsize));
            % 计算各个高频子带系数C(lev,dir,k,i)在不同状态下的方差值Variance(m)
            numerator = ((coefs{s}{l1,l2(:,:,l3)}-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
            numerator = filter2(windowsize,numerator,'same');
            Var{state}{s}{l1,l2}(:,:,l3) = (numerator./(Ps{state}{s}{l1,l2}(:,:,l3)))./prod(size(windowsize));
            % 计算各个高频子带系数C(lev,dir,k,i)在不同状态下的概率Pv|s(V=v|S=m)
            Vtmp = V{s}{l1,l2}(:,:,l3);                         %提取当前尺度各方向子带对应上下文变量V的值
            Vtmp = padarray(Vtmp,[s,s]);            %进行边界零值扩充  
            p= stateprob{state}{s}{l1,l2}(:,:,l3);             %提取不同状态下隐状态概率的值P(S=m|C) 
            p = padarray(p,[s,s]); %进行边界零值扩充
            for k = 1:size(Ps{state}{s}{l1,l2},1)
                for i = 1:size(Ps{state}{s}{l1,l2},2)  
                    sp = p(k:k+2*(s),i:i+2*(s));
                    Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                    sump = 0;                           %邻域窗口用于捕获局部统计信息(Capture Local Statistics)
                    for x = 1:size(Neighbor,1)
                        for y = 1:size(Neighbor,2)
                            if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                sump = sump + sp(x,y);  %设置sump变量，用于计算不同状态下的隐状态概率加和 
                            end
                        end
                    end
                    % 基于邻域窗口上下文信息得出不同状态下Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)的值
                    Pvs{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./Ps{state}{s}{l1,l2}(k,i,l3);
                end
            end
                end

           case{2}
                sz2=size(coefs{2}{1,1});
               for l3=1:sz2(3)

                    windowsize = ones(2*s+1);
            
            % 计算各个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)系数在子带中的位置]在不同状态下的概率值Ps(m)
            Ps{state}{s}{l1,l2}(:,:,l3) = filter2(windowsize,stateprob{state}{s}{l1,l2}(:,:,l3),'same')./prod(size(windowsize));
            % 计算各个高频子带系数C(lev,dir,k,i)在不同状态下的方差值Variance(m)
            numerator = ((coefs{s}{l1,l2(:,:,l3)}-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
            numerator = filter2(windowsize,numerator,'same');
            Var{state}{s}{l1,l2}(:,:,l3) = (numerator./(Ps{state}{s}{l1,l2}(:,:,l3)))./prod(size(windowsize));
            % 计算各个高频子带系数C(lev,dir,k,i)在不同状态下的概率Pv|s(V=v|S=m)
            Vtmp = V{s}{l1,l2}(:,:,l3);                         %提取当前尺度各方向子带对应上下文变量V的值
            Vtmp = padarray(Vtmp,[s,s]);            %进行边界零值扩充  
            p= stateprob{state}{s}{l1,l2}(:,:,l3);             %提取不同状态下隐状态概率的值P(S=m|C) 
            p = padarray(p,[s,s]); %进行边界零值扩充
            for k = 1:size(Ps{state}{s}{l1,l2},1)
                for i = 1:size(Ps{state}{s}{l1,l2},2)  
                    sp = p(k:k+2*(s),i:i+2*(s));
                    Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                    sump = 0;                           %邻域窗口用于捕获局部统计信息(Capture Local Statistics)
                    for x = 1:size(Neighbor,1)
                        for y = 1:size(Neighbor,2)
                            if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                sump = sump + sp(x,y);  %设置sump变量，用于计算不同状态下的隐状态概率加和 
                            end
                        end
                    end
                    % 基于邻域窗口上下文信息得出不同状态下Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)的值
                    Pvs{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./Ps{state}{s}{l1,l2}(k,i,l3);
                end
            end
               end
                case{3}
                     sz3=size(coefs{3}{1,1});
                   for l3=1:sz3(3)
                    
                    windowsize = ones(2*s+1);
            
            % 计算各个高频子带系数C(lev,dir,k,i)[lev尺度，dir方向，(k,i)系数在子带中的位置]在不同状态下的概率值Ps(m)
            Ps{state}{s}{l1,l2}(:,:,l3) = filter2(windowsize,stateprob{state}{s}{l1,l2}(:,:,l3),'same')./prod(size(windowsize));
            % 计算各个高频子带系数C(lev,dir,k,i)在不同状态下的方差值Variance(m)
            numerator = ((coefs{s}{l1,l2(:,:,l3)}-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
            numerator = filter2(windowsize,numerator,'same');
            Var{state}{s}{l1,l2}(:,:,l3) = (numerator./(Ps{state}{s}{l1,l2}(:,:,l3)))./prod(size(windowsize));
            % 计算各个高频子带系数C(lev,dir,k,i)在不同状态下的概率Pv|s(V=v|S=m)
            Vtmp = V{s}{l1,l2}(:,:,l3);                         %提取当前尺度各方向子带对应上下文变量V的值
            Vtmp = padarray(Vtmp,[s,s]);            %进行边界零值扩充  
            p= stateprob{state}{s}{l1,l2}(:,:,l3);             %提取不同状态下隐状态概率的值P(S=m|C) 
            p = padarray(p,[s,s]); %进行边界零值扩充
            for k = 1:size(Ps{state}{s}{l1,l2},1)
                for i = 1:size(Ps{state}{s}{l1,l2},2)  
                    sp = p(k:k+2*(s),i:i+2*(s));
                    Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                    sump = 0;                           %邻域窗口用于捕获局部统计信息(Capture Local Statistics)
                    for x = 1:size(Neighbor,1)
                        for y = 1:size(Neighbor,2)
                            if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                sump = sump + sp(x,y);  %设置sump变量，用于计算不同状态下的隐状态概率加和 
                            end
                        end
                    end
                    % 基于邻域窗口上下文信息得出不同状态下Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)的值
                    Pvs{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./Ps{state}{s}{l1,l2}(k,i,l3);
                end
            end
                  end

              end
            end
        end
    end
end