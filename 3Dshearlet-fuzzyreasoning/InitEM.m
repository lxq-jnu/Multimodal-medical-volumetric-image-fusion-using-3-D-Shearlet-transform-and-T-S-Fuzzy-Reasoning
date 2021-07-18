function [model, stateprob] = InitEM(coefs, Initmodel)
%% Adopt Expectation-Maximization Step to Calculate the Following Parameters
% Input:
%   coefs     : Contourlet Coefficients - ������ϵ��
%   Initmodel : Initial model to be used in the E step.
%
% Output:
%   model     : Updated Model after Initialization Stage - ��ʼ���׶���ɣ����º��ģ�Ͳ���
%   stateprob : The Post State Probability - ��״̬����P(Si=m|C,��)
%
% Get the number of mixtures and the number of levels in the Contourlet Transform
ns = Initmodel.nstates;                   %ģ��״̬��
nlev = Initmodel.nlevels;                 %�ֽ����

%------------------------Expectation Step--E ����-------------------------%

for state = 1:ns
    for lev = 1:nlev
        GaussPDF{state}{lev} = [];        %��˹���������ܶȺ��� - Gauss PDF   
        ConditionalPDF{state}{lev} = [];  %���������ܶȺ��� - Conditional PDF
        stateprob{state}{lev} = [];       %����״̬���� - Post State Probability
    end
end

% Calculate the Gaussian Probability Density Function PDF of the Contourlet
% Coefficients - ������Ӵ�������ϵ���ĸ�˹���������ܶȺ��� - Gauss PDF��g(w|0,���
for state = 1:ns
   for s=1:nlev
   
    ksz=size(coefs{s});
     for l1=1:ksz(1)
        for l2=1:ksz(2) %DFB���߶ȷ����Ӵ���Ŀ   
            switch s
                case{1}
                     sz1=size(coefs{1}{1,1});
                    for l3=1:sz1(3)
                        I=Initmodel.var{s}{l1,l2}(:,:,l3);
%             GaussPDF{state}{lev}{dir} = normpdf(coefs{lev}{dir}, 0, sqrt(Initmodel.var{lev}{dir}(state))); 
            coefsAtNorm = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(I(state))); %��̬�ֲ��ܶȺ���
            GaussPDF{state}{s}{l1,l2}(:,:,l3) = max( coefsAtNorm, eps );  %eps = 2.2204e-016          
                    end
                case{2}
                     sz2=size(coefs{2}{1,1});
                    for l3=1:sz2(3)
                        I=Initmodel.var{s}{l1,l2}(:,:,l3);
%             GaussPDF{state}{lev}{dir} = normpdf(coefs{lev}{dir}, 0, sqrt(Initmodel.var{lev}{dir}(state))); 
             coefsAtNorm = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(I(state))); %��̬�ֲ��ܶȺ���
            GaussPDF{state}{s}{l1,l2}(:,:,l3) = max( coefsAtNorm, eps );  %eps = 2.2204e-016
             
                    end
                case{3}
                     sz3=size(coefs{3}{1,1});
                    for l3=1:sz3(3)
                        I=Initmodel.var{s}{l1,l2}(:,:,l3);
%             GaussPDF{state}{lev}{dir} = normpdf(coefs{lev}{dir}, 0, sqrt(Initmodel.var{lev}{dir}(state))); 
             coefsAtNorm = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(I(state))); %��̬�ֲ��ܶȺ���
            GaussPDF{state}{s}{l1,l2}(:,:,l3) = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                    end
            end
        end
     end
    end
end

% for lev = 2:nlev+1  %LP�ֽ�߶�
%     for dir = 1:length(coefs{lev})  %DFB���߶ȷ����Ӵ���Ŀ 
%         ��ȡ�������Ӵ�ϵ����Ӧ�ı�׼ƫ����ڼ����˹�����ܶ�
%         sitmp(1,1,:) = sqrt(Initmodel.var{lev}{dir});
%         coefsAtNorm = normpdf(repmat(coefs{lev}{dir}, [1 1 ns]), 0, ...
%             repmat((sitmp), [size(coefs{lev}{dir},1), size(coefs{lev}{dir},2) 1]));
%         coefsAtNorm = max( coefsAtNorm, eps );  %eps = 2.2204e-016
%         Calculate the Normalization Constant - ��һ������
%         gtmp = coefsAtNorm./repmat(sum(coefsAtNorm, 3), [1 1 ns]);
%         GaussPDF{1}{lev}{dir} = gtmp(:,:,1);
%         GaussPDF{2}{lev}{dir} = gtmp(:,:,2);
%     end
% end

% Calculate the Conditional Probability Density Function of the Contourlet
% Coefficients - ������Ӵ�������ϵ�������������ܶȺ��� - Conditional PDF��p��m)*g(w|0,���
for state = 1:ns
    for s = 1:nlev  %LP�ֽ�߶�
        sz=length(GaussPDF{state}{s});
        for l1 = 1:sz(1)  
            for l2=1:sz(1)%DFB���߶ȷ����Ӵ���Ŀ  
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
            

% Initialize the Edge PDF structure-��ʼ����Ե�����ܶȺ����ṹ
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
% Coefficients - ������Ӵ�������ϵ���ı�Ե�����ܶȺ��� - Edge PDF ��f��w��=sigma��p��m)*g(w|0,�����

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
% Coefficients - ������Ӵ�������ϵ���ĺ�������ܶȺ���p(Si= m|Ci,��)
% ��˹���ģ��GMM��state=2-��Ӧ���ֵ���󷽲��˹ģ��;state=1-��Ӧ���ֵ��С�����˹ģ��.
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
           

%------------------------Maximization Step--M ����------------------------%

% Preallocate UM - Ԥ������UM
model = Initmodel;

% Update the Values of Ps(m) - ����״̬���ʵ�ֵ P��m)
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
           

% Update the Values of Variance - ���·����ֵ����ֵĬ����Ϊ��
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
           