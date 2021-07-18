function Initmodel = Initialization(coefs)
%%
% Initialize CHMM Model - 初始化Contourlet域隐马尔科夫模型 CHMM Model 参数
% This file makes an Initial Values for the Contourlet Contextual HMM.
%
% Input:
%   coefs     ：the Contourlet Coefficients which used to Initialize the Model.
%
% Output:
%   Initmodel ：Generate an Initial Contourlet Domain Hidden Markov Model
%
% Define the Number of States - 采用两状态、零均值GMM逼近轮廓波系数的非高斯边缘分布
% state = 1，小状态-对应图像平滑区域；state = 2，大状态-对应图像边缘区域
ns = 2;  
nlev = length(coefs);  % Get the number of levels - 分解尺度

% Create the structure that is needed in each cell entry of the model
% 函数struct() - Create or convert to structure array.
% S = STRUCT('field1',VALUES1,'field2',VALUES2,...)-生成一个具有指定字段名和相应数据的结构数组
s = struct('nstates', ns, 'nlevels', nlev, 'zeromean', 'yes', ...
    'Ps', {cell(1,nlev)}, 'var', {cell(1,nlev)});
level=3;
for lev=1:level
    ksz=size(coefs{lev});
     
    for l1=1:ksz(1)
        for l2=1:ksz(2)
           switch lev
               case{1}
                   sz1=size(coefs{1}{1,1});
                   for l3=1:sz1(3)
                       s.Ps{lev}{l1,l2}(:,:,l3) = [0.5 0.5];  %the State Probability - 各子带PMF 
        
                       C = coefs{lev}{l1,l2}(:,:,l3);         %Contourlet Coefficients - 各个子带系数
                       avgenergy = mean2(C.^2);     %Average Energy - 计算子带系数的平均能量
                       avgenergy = avgenergy*(avgenergy>1e-6)+1e-6*(avgenergy<=1e-6);
                       s.var{lev}{l1,l2}(:,:,l3) = avgenergy*linspace(0.5,2.0,2);%Gauss Variance - 高斯方差 
                      
                   end
               case{2}
                   sz2=size(coefs{2}{1,1});
                for l3=1:sz2(3)
                    s.Ps{lev}{l1,l2}(:,:,l3) = [0.5 0.5];  %the State Probability - 各子带PMF        
                    C = coefs{lev}{l1,l2}(:,:,l3);         %Contourlet Coefficients - 各个子带系数
                   avgenergy = mean2(C.^2);     %Average Energy - 计算子带系数的平均能量
                   avgenergy = avgenergy*(avgenergy>1e-6)+1e-6*(avgenergy<=1e-6);
                   s.var{lev}{l1,l2}(:,:,l3) = 2*avgenergy*linspace(0.5,2.0,2);%Gauss Variance - 高斯方差 
                end
               case{3}
                   sz3=size(coefs{3}{1,1});
                   for l3=1:sz3(3)
                      s.Ps{lev}{l1,l2}(:,:,l3) = [0.5 0.5];  %the State Probability - 各子带PMF         
                      C = coefs{lev}{l1,l2}(:,:,l3);         %Contourlet Coefficients - 各个子带系数
                      avgenergy = mean2(C.^2);     %Average Energy - 计算子带系数的平均能量
                      avgenergy = avgenergy*(avgenergy>1e-6)+1e-6*(avgenergy<=1e-6);
                      s.var{lev}{l1,l2}(:,:,l3) = 2*avgenergy*linspace(0.5,2.0,2);%Gauss Variance - 高斯方差
                   end
           end
        end
    end 
end

Initmodel = s;