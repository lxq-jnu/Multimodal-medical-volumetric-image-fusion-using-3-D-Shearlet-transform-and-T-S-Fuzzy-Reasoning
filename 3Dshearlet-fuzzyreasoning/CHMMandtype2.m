% =========================================================================
%
% 以下代码是对“Contextual Hidden Markov Model ”程序的实现
%
% =========================================================================




disp('          '); 
disp('Select the Boundary Expansion Method--选择边界系数扩充方式……');
display('       1:Zero Expansion - 零值扩充(默认)');
display('       2:Mirror Symmetry - 围绕边界镜像对称扩充');

% boundary_choice = input('Please enter your choice:   '); 
% boundary_choice = 1;
  boundary_choice = 2;    %选择“围绕边界镜像对称扩充”的方式效果更优


% A New Project to obtain the Values of Context 

[VA, contextA] = CalContext(coefsA);
[VB, contextB] = CalContext(coefsB);

%% 对图像分解后的3-D剪切波系数计算初始的 C-CHMM 参数
disp('          ');
disp('Initialization Parameters Stage--参数初始化阶段……');
disp('       Set C-CHMM Initial Parameters设定状态概率、方差初始参数值');
modelA = Initialization(coefsA);
modelB = Initialization(coefsB);



%% 采用Expectation-Maximization Step(局域化窗口，优化的EM算法)完成C-CHMM参数初始化
% Set the iteration number limit Np and Nc - 设置初始化及训练EM算法最大迭代次数
maxiterP = 20; 
maxiterC = 5;
iter = 0;
disp('       Use Expectation-Maximization Step采用EM步骤计算C-CHMM参数');
while(iter < maxiterP)
    modelAP = modelA;    modelBP = modelB;
    [modelA, stateprobA] = InitEM(coefsA, modelAP);
    [modelB, stateprobB] = InitEM(coefsB, modelBP);
    iter = iter+1;       %迭代次数加1
end 

disp('       Set the Following Parameters计算下列参数完成C-CHMM初始化阶段');
switch boundary_choice 
    case 1               %边界系数零值扩充
        [PsA, VarA,PvsA] = SetParameters0(coefsA, modelA, stateprobA,VA);   
        [PsB, VarB,PvsB] = SetParameters0(coefsB, modelB, stateprobB,VB);
    case 2               %边界系数镜像对称方式扩充
        [PsA, VarA,PvsA] = SetParameters(coefsA, modelA,stateprobA, VA);   
        [PsB, VarB,PvsB] = SetParameters(coefsB, modelB,stateprobB, VB);    
    otherwise
        disp('Please input the right No. of the Boundary Expansion Methods: 1 or 2!');
%         break;
end      
                
%% 对图像分解后的3-D剪切波系数采用迭代期望最大化EM算法训练 C-CHMM 参数
disp('          ');
disp('Iterative EM Training Stage--迭代EM算法参数训练阶段……');
disp('       Expectation Step：Calculate Probability对每个轮廓波系数计算Ps|v隐状态概率值');
% 在给定上下文V的条件下，3-D剪切波系数相互独立，即系数间的相关性通过上下文与隐状态之间的状态转移概率Ps|v(S=m|V=v)体现
disp('       Maximization Step：Update Parameters更新状态概率Ps(m)、方差Var、Pv|s参数值');
iter = 0;
switch boundary_choice 
    case 1                      %边界系数零值扩充  
        while(iter < maxiterC)
            PsPA=PsA;VarPA=VarA;PvsPA=PvsA;          
            [PsA, VarA, PvsA, PsvA] = TrainingEM0(coefsA, PsPA, VarPA, PvsPA,VA);
            PsPB=PsB;VarPB=VarB;PvsPB=PvsB;
            [PsB, VarB, PvsB, PsvB] = TrainingEM0(coefsB, PsPB, VarPB, PvsPB,VB);
            iter = iter+1;      %迭代次数加1
        end
    case 2                      %边界系数镜像对称方式扩充
        while(iter < maxiterC)    
           PsPA=PsA;VarPA=VarA;PvsPA=PvsA;
            [PsA, VarA, PvsA, PsvA] = TrainingEM(coefsA, PsPA, VarPA, PvsPA,VA);
            PsPB=PsB;VarPB=VarB;PvsPB=PvsB;
            [PsB, VarB, PvsB, PsvB] = TrainingEM(coefsB, PsPB, VarPB, PvsPB,VB);
            iter = iter+1;      %迭代次数加1
        end
end


disp('          ');
disp('Calculating the Gaussian PDF of the Contourlet Coefficients');

% 
for state = 1:modelA.nstates   
    for s = 1:modelA.nlevels    
        sz=size(coefsA{s});   
        for l1= 1:sz(1)   
            for l2=1:sz(2)
               switch s
                 case{1}
                     sz1=size(coefsA{s}{1,1});
                  for l3=1:sz1(3)
                    coefsAAtNorm = normpdf(coefsA{s}{l1,l2}(:,:,l3), 0, sqrt(VarA{state}{s}{l1,l2}(:,:,l3))); 
                    K11=max( coefsAAtNorm, eps );                   
                    GaussPDFA{state}{s}{l1,l2}(:,:,l3) = K11;    %eps = 2.2204e-016
                    coefsBAtNorm = normpdf(coefsB{s}{l1,l2}(:,:,l3), 0, sqrt(VarB{state}{s}{l1,l2}(:,:,l3))); 
                    K21=max( coefsBAtNorm, eps );
                    GaussPDFB{state}{s}{l1,l2}(:,:,l3) = K21;    %eps = 2.2204e-016
                     
                 
                  
                  end
                 case{2}
                     sz2=size(coefsA{2}{1,1});
                  for l3=1:sz2(3)                      
                   coefsAAtNorm =normpdf(coefsA{s}{l1,l2}(:,:,l3), 0, sqrt(VarA{state}{s}{l1,l2}(:,:,l3))); 
                    K12=max( coefsAAtNorm, eps );
                    GaussPDFA{state}{s}{l1,l2}(:,:,l3) = K12;    %eps = 2.2204e-016
                    coefsBAtNorm = normpdf(coefsB{s}{l1,l2}(:,:,l3), 0, sqrt(VarB{state}{s}{l1,l2}(:,:,l3))); 
                    K22=max( coefsBAtNorm, eps );
                    GaussPDFB{state}{s}{l1,l2}(:,:,l3) = K22;                  
                  end
                case{3}
                    sz3=size(coefsA{3}{1,1});
                  for l3=1:sz3(3)
                    coefsAAtNorm =normpdf(coefsA{s}{l1,l2}(:,:,l3), 0, sqrt(VarA{state}{s}{l1,l2}(:,:,l3))); 
                    K13=max( coefsAAtNorm, eps );
                    GaussPDFA{state}{s}{l1,l2}(:,:,l3) = K13;    %eps = 2.2204e-016
                    coefsBAtNorm =normpdf(coefsB{s}{l1,l2}(:,:,l3), 0, sqrt(VarB{state}{s}{l1,l2}(:,:,l3))); 
                    K23= max( coefsBAtNorm, eps );
                    GaussPDFB{state}{s}{l1,l2}(:,:,l3) = K23;               
                  end
                end
            end
        end
    end
end

% Initialize the Edge PDF Structure - 初始化边缘概率密度函数结构
for s = 1:modelA.nlevels
    sz=size(coefsA{s})  ;
    for l1 = 1:sz(1)
        for l2=1:sz(2)
           switch s
               case{1}
                   sz1=size(coefsA{1}{1,1});
                  for l3=1:sz1(3)
                     EdgePDFA{s}{l1,l2}(:,:,l3) = zeros(size(coefsA{s}{l1,l2}(:,:,l3),1), size(coefsA{s}{l1,l2}(:,:,l3),2));
                     EdgePDFB{s}{l1,l2}(:,:,l3) = zeros(size(coefsB{s}{l1,l2}(:,:,l3),1), size(coefsB{s}{l1,l2}(:,:,l3),2));                
                  end
               case{2}
                   sz2=size(coefsA{2}{1,1});
                  for l3=1:sz2(3)
                    EdgePDFA{s}{l1,l2}(:,:,l3) = zeros(size(coefsA{s}{l1,l2}(:,:,l3),1), size(coefsA{s}{l1,l2}(:,:,l3),2));
                    EdgePDFB{s}{l1,l2}(:,:,l3) = zeros(size(coefsB{s}{l1,l2}(:,:,l3),1), size(coefsB{s}{l1,l2}(:,:,l3),2));
                  end
               case{3}
                   sz3=size(coefsA{3}{1,1});
                  for l3=1:sz3(3)
                     EdgePDFA{s}{l1,l2}(:,:,l3) = zeros(size(coefsA{s}{l1,l2}(:,:,l3),1), size(coefsA{s}{l1,l2}(:,:,l3),2));
                     EdgePDFB{s}{l1,l2}(:,:,l3) = zeros(size(coefsB{s}{l1,l2}(:,:,l3),1), size(coefsB{s}{l1,l2}(:,:,l3),2));
                  end
            end
        end
    end
end

% By the C-CHMM,each Contourlet Coefficient can be determined by its Edge Probability Density Function
disp('          ');
disp('Calculating the Edge PDF of the Contourlet Coefficients');
disp('计算各个方向子带3-D剪切波系数的边缘概率密度函数(Edge PDF)');
for state = 1:modelA.nstates    
    for s = 1:modelA.nlevels
        sz=size(GaussPDFA{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(2)
                switch s
                   case{1}
                       sz1=size(coefsA{1}{1,1});
                      for l3=1:sz1(3)
                        EA1= EdgePDFA{s}{l1,l2}(:,:,l3)+PsvA{state}{s}{l1,l2}(:,:,l3).*GaussPDFA{state}{s}{l1,l2}(:,:,l3);
                         EdgePDFA{s}{l1,l2}(:,:,l3)=EA1;
                         EB1 = EdgePDFB{s}{l1,l2}(:,:,l3)+PsvB{state}{s}{l1,l2}(:,:,l3).*GaussPDFB{state}{s}{l1,l2}(:,:,l3);
                         EdgePDFB{s}{l1,l2}(:,:,l3)=EB1;
                      end
                   case{2}
                       sz2=size(coefsA{2}{1,1});
                      for l3=1:sz2(3)
                         EA2 = EdgePDFA{s}{l1,l2}(:,:,l3)+PsvA{state}{s}{l1,l2}(:,:,l3).*GaussPDFA{state}{s}{l1,l2}(:,:,l3);
                         EdgePDFA{s}{l1,l2}(:,:,l3)=EA2;
                         EB2 = EdgePDFB{s}{l1,l2}(:,:,l3)+PsvB{state}{s}{l1,l2}(:,:,l3).*GaussPDFB{state}{s}{l1,l2}(:,:,l3);
                         EdgePDFB{s}{l1,l2}(:,:,l3)=EB2;
                      end
                   case{3}
                       sz3=size(coefsA{3}{1,1});
                      for l3=1:sz3(3)
                         EA3 = EdgePDFA{s}{l1,l2}(:,:,l3)+PsvA{state}{s}{l1,l2}(:,:,l3).*GaussPDFA{state}{s}{l1,l2}(:,:,l3);
                         EdgePDFA{s}{l1,l2}(:,:,l3)=EA3;
                         EB3 = EdgePDFB{s}{l1,l2}(:,:,l3)+PsvB{state}{s}{l1,l2}(:,:,l3).*GaussPDFB{state}{s}{l1,l2}(:,:,l3);
                         EdgePDFB{s}{l1,l2}(:,:,l3)=EB3;
                      end
                end
            end
        end
    end
end

