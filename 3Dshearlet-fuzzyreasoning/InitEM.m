function [model, stateprob] = InitEM(coefs, Initmodel)
%% Adopt Expectation-Maximization Step to Calculate the Following Parameters
% Input:
%   coefs     : Contourlet Coefficients - 轮廓波系数
%   Initmodel : Initial model to be used in the E step.
%
% Output:
%   model     : Updated Model after Initialization Stage - 初始化阶段完成，更新后的模型参数
%   stateprob : The Post State Probability - 隐状态概率P(Si=m|C,Θ)
%
% Get the number of mixtures and the number of levels in the Contourlet Transform
ns = Initmodel.nstates;                   %模型状态数
nlev = Initmodel.nlevels;                 %分解层数

%------------------------Expectation Step--E 步骤-------------------------%

for state = 1:ns
    for lev = 1:nlev
        GaussPDF{state}{lev} = [];        %高斯条件概率密度函数 - Gauss PDF   
        ConditionalPDF{state}{lev} = [];  %条件概率密度函数 - Conditional PDF
        stateprob{state}{lev} = [];       %后验状态概率 - Post State Probability
    end
end

% Calculate the Gaussian Probability Density Function PDF of the Contourlet
% Coefficients - 计算各子带轮廓波系数的高斯条件概率密度函数 - Gauss PDF，g(w|0,方差）
for state = 1:ns
   for s=1:nlev
   
    ksz=size(coefs{s});
     for l1=1:ksz(1)
        for l2=1:ksz(2) %DFB各尺度方向子带数目   
            switch s
                case{1}
                     sz1=size(coefs{1}{1,1});
                    for l3=1:sz1(3)
                        I=Initmodel.var{s}{l1,l2}(:,:,l3);
%             GaussPDF{state}{lev}{dir} = normpdf(coefs{lev}{dir}, 0, sqrt(Initmodel.var{lev}{dir}(state))); 
            coefsAtNorm = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(I(state))); %正态分布密度函数
            GaussPDF{state}{s}{l1,l2}(:,:,l3) = max( coefsAtNorm, eps );  %eps = 2.2204e-016          
                    end
                case{2}
                     sz2=size(coefs{2}{1,1});
                    for l3=1:sz2(3)
                        I=Initmodel.var{s}{l1,l2}(:,:,l3);
%             GaussPDF{state}{lev}{dir} = normpdf(coefs{lev}{dir}, 0, sqrt(Initmodel.var{lev}{dir}(state))); 
             coefsAtNorm = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(I(state))); %正态分布密度函数
            GaussPDF{state}{s}{l1,l2}(:,:,l3) = max( coefsAtNorm, eps );  %eps = 2.2204e-016
             
                    end
                case{3}
                     sz3=size(coefs{3}{1,1});
                    for l3=1:sz3(3)
                        I=Initmodel.var{s}{l1,l2}(:,:,l3);
%             GaussPDF{state}{lev}{dir} = normpdf(coefs{lev}{dir}, 0, sqrt(Initmodel.var{lev}{dir}(state))); 
             coefsAtNorm = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(I(state))); %正态分布密度函数
            GaussPDF{state}{s}{l1,l2}(:,:,l3) = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                    end
            end
        end
     end
    end
end

% for lev = 2:nlev+1  %LP分解尺度
%     for dir = 1:length(coefs{lev})  %DFB各尺度方向子带数目 
%         获取各方向子带系数对应的标准偏差，用于计算高斯概率密度
%         sitmp(1,1,:) = sqrt(Initmodel.var{lev}{dir});
%         coefsAtNorm = normpdf(repmat(coefs{lev}{dir}, [1 1 ns]), 0, ...
%             repmat((sitmp), [size(coefs{lev}{dir},1), size(coefs{lev}{dir},2) 1]));
%         coefsAtNorm = max( coefsAtNorm, eps );  %eps = 2.2204e-016
%         Calculate the Normalization Constant - 归一化处理
%         gtmp = coefsAtNorm./repmat(sum(coefsAtNorm, 3), [1 1 ns]);
%         GaussPDF{1}{lev}{dir} = gtmp(:,:,1);
%         GaussPDF{2}{lev}{dir} = gtmp(:,:,2);
%     end
% end

% Calculate the Conditional Probability Density Function of the Contourlet
% Coefficients - 计算各子带轮廓波系数的条件概率密度函数 - Conditional PDF，p（m)*g(w|0,方差）
for state = 1:ns
    for s = 1:nlev  %LP分解尺度
        sz=length(GaussPDF{state}{s});
        for l1 = 1:sz(1)  
            for l2=1:sz(1)%DFB各尺度方向子带数目  
                switch s
                    case {1}
                         sz1=size(coefs{1}{1,1});
                        for l3=1:sz1(3)
            ConditionalPDF{state}{s}{l1,l2}(:,:,l3) = Initmodel.Ps{s}{l1,l2}(state).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                        end
                    case{2}
                         sz2=size(coefs{2}{1,1});
                        for l3=1:sz2(3)
            ConditionalPDF{state}{s}{l1,l2}(:,:,l3) = Initmodel.Ps{s}{l1,l2}(state).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                        end  
                    case{3}
                         sz3=size(coefs{3}{1,1});
                        for l3=1:sz3(3)
            ConditionalPDF{state}{s}{l1,l2}(:,:,l3) = Initmodel.Ps{s}{l1,l2}(state).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                        end     
                end
            end
        end
    end
end
            

% Initialize the Edge PDF structure-初始化边缘概率密度函数结构
for s = 1:nlev
    sz=length(ConditionalPDF{state}{s})  ;
    for l1 = 1:sz(1) 
        for l2=1:sz(1)
            switch s
                case{1} 
                    sz1=size(coefs{1}{1,1});
                    for l3=1:sz1(3)
                       EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2},1), size(coefs{s}{l1,l2},2));
                    end
                case{2}
                     sz2=size(coefs{2}{1,1});
                    for l3=1:sz2(3)
                       EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2},1), size(coefs{s}{l1,l2},2));
                    end  
                case{3}
                     sz3=size(coefs{3}{1,1});
                    for l3=1:sz3(3)
                       EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2},1), size(coefs{s}{l1,l2},2));
                    end
            end
        end
    end
end
       

% Calculate the Edge Probability Density Function f(c) of the Contourlet
% Coefficients - 计算各子带轮廓波系数的边缘概率密度函数 - Edge PDF ，f（w）=sigma（p（m)*g(w|0,方差））

for state = 1:ns    
    for s = 1:nlev
        sz=length(ConditionalPDF{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(1)
                switch s
                    case{1}
                         sz1=size(coefs{1}{1,1});
                        for l3=1:sz1(3)
                            EdgePDF{s}{l1,l2}(:,:,l3) = EdgePDF{s}{l1,l2}(:,:,l3)+ConditionalPDF{state}{s}{l1,l2}(:,:,l3);
                        end
                    case{2}
                         sz2=size(coefs{2}{1,1});
                        for l3=1:sz2(3)
                            EdgePDF{s}{l1,l2}(:,:,l3) = EdgePDF{s}{l1,l2}(:,:,l3)+ConditionalPDF{state}{s}{l1,l2}(:,:,l3); 
                        end
                    case{3}
                         sz3=size(coefs{3}{1,1});
                        for l3=1:sz3(3)
                            EdgePDF{s}{l1,l2}(:,:,l3) = EdgePDF{s}{l1,l2}(:,:,l3)+ConditionalPDF{state}{s}{l1,l2}(:,:,l3);
                        end
                end
            end
        end
    end
end
           

% Calculate the Post State Probability Density Function f(c) of the Contourlet
% Coefficients - 计算各子带轮廓波系数的后验概率密度函数p(Si= m|Ci,Θ)
% 高斯混合模型GMM：state=2-对应零均值、大方差高斯模型;state=1-对应零均值、小方差高斯模型.
for state = 1:ns    
    for s = 1:nlev
        sz=length(ConditionalPDF{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(1)
                switch s
                    case{1}
                         sz1=size(coefs{1}{1,1});
                        for l3=1:sz1(3)
                            stateprob{state}{s}{l1,l2}(:,:,l3) = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                        end
                    case{2}
                         sz2=size(coefs{2}{1,1});
                        for l3=1:sz2(3)
                            stateprob{state}{s}{l1,l2}(:,:,l3) = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                        end
                    case{3} 
                         sz3=size(coefs{3}{1,1});
                        for l3=1:sz3(3)
                             stateprob{state}{s}{l1,l2}(:,:,l3) = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                        end
                end
            end
        end
    end
end
           

%------------------------Maximization Step--M 步骤------------------------%

% Preallocate UM - 预先设置UM
model = Initmodel;

% Update the Values of Ps(m) - 更新状态概率的值 P（m)
for state = 1:ns    
    for lev = 1:nlev
        sz=length(stateprob{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(1)
                switch s
                    case{1}
                         sz1=size(coefs{1}{1,1});
                        for l3=1:sz1(3)
                            sp = stateprob{state}{s}{l1,l2}(:,:,l3);
%                             M=model.Ps{s}{l1,l2}(:,:,l3);
                            model.Ps{s}{l1,l2}(state) = mean(sp(:));
%                             model.Ps=M.Ps;
                        end
                    case{2}
                         sz2=size(coefs{2}{1,1});
                        for l3=1:sz2(3)
                          sp = stateprob{state}{s}{l1,l2}(:,:,l3);
%                             M=model.Ps{s}{l1,l2}(:,:,l3);
                            model.Ps{s}{l1,l2}(state) = mean(sp(:));
%                             model.Ps=M.Ps;
                        end
                    case{3}
                         sz3=size(coefs{3}{1,1});
                        for l3=1:sz3(3)
                           sp = stateprob{state}{s}{l1,l2}(:,:,l3);
%                             M=model.Ps{s}{l1,l2}(:,:,l3);
                            model.Ps{s}{l1,l2}(state) = mean(sp(:));
%                             model.Ps=M.Ps;
                        end
                end
            end
        end
    end
end

            %mean2(sp);
%             ps = mean(sp(:));
%             ps = ps.*(ps > 1e-4)+1e-4*(ps <= 1e-4);
%             model.Ps{lev}{dir}(state) = ps;
           

% Update the Values of Variance - 更新方差的值，均值默认设为零
for state = 1:ns    
    for lev = 2:nlev
        sz=length(stateprob{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(1)
                switch s
                    case{1}
                         sz1=size(coefs{1}{1,1});
                        for l3=1:sz1(3)
%                            M.Ps{s}{l1,l2}(:,:,l3)=model.Ps{s}{l1,l2}(:,:,l3);
%                            M.var{s}{l1,l2}(:,:,l3)=model.Ps{s}{l1,l2}(:,:,l3);
                           numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
                           model.var{s}{l1,l2}(state) = mean2(numerator) ./ (model.Ps{s}{l1,l2}(state)); 
%                             model.Ps=M.Ps;
%                              model.var=M.var;
                        end
                    case{2}
                         sz2=size(coefs{2}{1,1});
                        for l3=1:sz2(3)
%                            M.Ps=model.Ps{s}{l1,l2}(:,:,l3);
%                            M.var=model.Ps{s}{l1,l2}(:,:,l3);
                            numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
                           model.var{s}{l1,l2}(state) = mean2(numerator) ./ (model.Ps{s}{l1,l2}(state)); 
%                            model.Ps=M.Ps;
%                            model.var=M.var;
                        end
                    case{3}
                         sz3=size(coefs{3}{1,1});
                        for l3=1:sz3(3)
%                             M.Ps=model.Ps{s}{l1,l2}(:,:,l3);
%                             M.var=model.Ps{s}{l1,l2}(:,:,l3);
                           numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
                           model.var{s}{l1,l2}(state) = mean2(numerator) ./ (model.Ps{s}{l1,l2}(state)); 
%                             model.Ps=M.Ps;
%                             model.var=M.var;
                        end
                end
            end
        end
    end
end
           