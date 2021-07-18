% =========================================================================
%
% ���´����Ƕԡ�Contextual Hidden Markov Model �������ʵ��
%
% =========================================================================




disp('          '); 
disp('Select the Boundary Expansion Method--ѡ��߽�ϵ�����䷽ʽ����');
display('       1:Zero Expansion - ��ֵ����(Ĭ��)');
display('       2:Mirror Symmetry - Χ�Ʊ߽羵��Գ�����');

% boundary_choice = input('Please enter your choice:   '); 
% boundary_choice = 1;
  boundary_choice = 2;    %ѡ��Χ�Ʊ߽羵��Գ����䡱�ķ�ʽЧ������


% A New Project to obtain the Values of Context 

[VA, contextA] = CalContext(coefsA);
[VB, contextB] = CalContext(coefsB);

%% ��ͼ��ֽ���3-D���в�ϵ�������ʼ�� C-CHMM ����
disp('          ');
disp('Initialization Parameters Stage--������ʼ���׶Ρ���');
disp('       Set C-CHMM Initial Parameters�趨״̬���ʡ������ʼ����ֵ');
modelA = Initialization(coefsA);
modelB = Initialization(coefsB);



%% ����Expectation-Maximization Step(���򻯴��ڣ��Ż���EM�㷨)���C-CHMM������ʼ��
% Set the iteration number limit Np and Nc - ���ó�ʼ����ѵ��EM�㷨����������
maxiterP = 20; 
maxiterC = 5;
iter = 0;
disp('       Use Expectation-Maximization Step����EM�������C-CHMM����');
while(iter < maxiterP)
    modelAP = modelA;    modelBP = modelB;
    [modelA, stateprobA] = InitEM(coefsA, modelAP);
    [modelB, stateprobB] = InitEM(coefsB, modelBP);
    iter = iter+1;       %����������1
end 

disp('       Set the Following Parameters�������в������C-CHMM��ʼ���׶�');
switch boundary_choice 
    case 1               %�߽�ϵ����ֵ����
        [PsA, VarA,PvsA] = SetParameters0(coefsA, modelA, stateprobA,VA);   
        [PsB, VarB,PvsB] = SetParameters0(coefsB, modelB, stateprobB,VB);
    case 2               %�߽�ϵ������ԳƷ�ʽ����
        [PsA, VarA,PvsA] = SetParameters(coefsA, modelA,stateprobA, VA);   
        [PsB, VarB,PvsB] = SetParameters(coefsB, modelB,stateprobB, VB);    
    otherwise
        disp('Please input the right No. of the Boundary Expansion Methods: 1 or 2!');
%         break;
end      
                
%% ��ͼ��ֽ���3-D���в�ϵ�����õ����������EM�㷨ѵ�� C-CHMM ����
disp('          ');
disp('Iterative EM Training Stage--����EM�㷨����ѵ���׶Ρ���');
disp('       Expectation Step��Calculate Probability��ÿ��������ϵ������Ps|v��״̬����ֵ');
% �ڸ���������V�������£�3-D���в�ϵ���໥��������ϵ����������ͨ������������״̬֮���״̬ת�Ƹ���Ps|v(S=m|V=v)����
disp('       Maximization Step��Update Parameters����״̬����Ps(m)������Var��Pv|s����ֵ');
iter = 0;
switch boundary_choice 
    case 1                      %�߽�ϵ����ֵ����  
        while(iter < maxiterC)
            PsPA=PsA;VarPA=VarA;PvsPA=PvsA;          
            [PsA, VarA, PvsA, PsvA] = TrainingEM0(coefsA, PsPA, VarPA, PvsPA,VA);
            PsPB=PsB;VarPB=VarB;PvsPB=PvsB;
            [PsB, VarB, PvsB, PsvB] = TrainingEM0(coefsB, PsPB, VarPB, PvsPB,VB);
            iter = iter+1;      %����������1
        end
    case 2                      %�߽�ϵ������ԳƷ�ʽ����
        while(iter < maxiterC)    
           PsPA=PsA;VarPA=VarA;PvsPA=PvsA;
            [PsA, VarA, PvsA, PsvA] = TrainingEM(coefsA, PsPA, VarPA, PvsPA,VA);
            PsPB=PsB;VarPB=VarB;PvsPB=PvsB;
            [PsB, VarB, PvsB, PsvB] = TrainingEM(coefsB, PsPB, VarPB, PvsPB,VB);
            iter = iter+1;      %����������1
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

% Initialize the Edge PDF Structure - ��ʼ����Ե�����ܶȺ����ṹ
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
disp('������������Ӵ�3-D���в�ϵ���ı�Ե�����ܶȺ���(Edge PDF)');
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

