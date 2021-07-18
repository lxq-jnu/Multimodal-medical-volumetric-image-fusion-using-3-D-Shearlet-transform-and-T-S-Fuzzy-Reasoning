function [PsN, VarN, PvsN, Psv] = TrainingEM0(coefs, Ps, Var, Pvs, V)
%%  ���õ����������EM�㷨ѵ��Contourlet��CHMMģ�Ͳ���
% Adopt Iterative EM Algorithm to Train the Parameters of CHMM in the Contourlet Domain
% Input:
% �����Ӧÿ����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)������ϵ�����Ӵ��е�λ��]
%   coefs  : Contourlet Coefficients - ������ϵ��
%   Ps     : ������ϵ���ڲ�ͬ״̬�µĸ���ֵPs(m)
%   Var    : ������ϵ���ڲ�ͬ״̬�µķ���ֵVariance(m)
%   Pvs    ��������ϵ���ڲ�ͬ״̬�»��������ı����ĸ���ֵPv|s(V=v|S=m)
%   V      : The Values of the Context Variable(MI based Context Design Procedure) - ���ڻ���Ϣ�������ı���ȡֵ
%
% Output:
%   PsN    ��Updated PMF - ���º��״̬����ֵ
%   VarN   : Updated Variance - ���º�ķ�����������ڹ���ȥ��ϵ��
%   PvsN   ��Updated Pv|s(V=v|S=m) - ���º�Ĳ�ͬ״̬�»��������ĵĸ���ֵ
%   Psv    : ����������״̬֮���״̬ת�Ƹ���Ps|v(S=m|C,V) - ����ϵ��֮��������
%
% Get the number of mixtures and the number of levels in the contourlet transform
ns = length(Ps);           %ģ��״̬����2��
nlev = length(coefs);    %�ֽ������3��

%------------------------Expectation Step--E ����-------------------------%

% Calculate Probability for each Contourlet Coefficients as follows
% Initialize the Variable structure - ��ʼ�������ṹ
for state = 1:ns
    for s= 1: nlev
        GaussPDF{state}{s} = [];        %��˹���������ܶȺ��� - Gauss PDF   
        ConditionalPDF{state}{s} = [];  %���������ܶȺ��� - Conditional PDF
    end
end

% Calculate the Gaussian Probability Density Function PDF and the Conditional
% Probability Density Function of the Coefficients - ������Ӵ�������ϵ���ĸ�˹
% ���������ܶȺ���(Gauss PDF)�Լ����������ܶȺ���(Conditional PDF)
for state = 1:ns %2
   for s=1:nlev%3
    
    ksz=size(coefs{s});%ϵ���ĳߴ�
    for l1=1:ksz(1)
        for l2=1:ksz(2)  %DFB���߶ȷ����Ӵ���Ŀ 
           switch s
              case{1}
                  sz1=size(coefs{1}{1,1});
                 for l3=1:sz1(3)
                   GaussPDF{state}{s}{l1,l2}(:,:,l3) = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(Var{state}{s}{l1,l2}(:,:,l3))); 
%             coefsAtNorm = normpdf(coefs{lev}{dir}, 0, sqrt(Var{state}{lev}{dir})); 
%             GaussPDF{state}{lev}{dir} = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                  ConditionalPDF{state}{s}{l1,l2}(:,:,l3) = Ps{state}{s}{l1,l2}(:,:,l3).*Pvs{state}{s}{l1,l2}(:,:,l3).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                 end
             case{2}
                 sz2=size(coefs{2}{1,1});
                for l3=1:sz2(3)
                  GaussPDF{state}{s}{l1,l2}(:,:,l3) = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(Var{state}{s}{l1,l2}(:,:,l3))); 
%             coefsAtNorm = normpdf(coefs{lev}{dir}, 0, sqrt(Var{state}{lev}{dir})); 
%             GaussPDF{state}{lev}{dir} = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                  ConditionalPDF{state}{s}{l1,l2}(:,:,l3) = Ps{state}{s}{l1,l2}(:,:,l3).*Pvs{state}{s}{l1,l2}(:,:,l3).*GaussPDF{state}{s}{l1,l2}(:,:,l3);
                 end
             case{3}
                 sz3=size(coefs{3}{1,1});
                 for l3=1:sz3(3)
                 GaussPDF{state}{s}{l1,l2}(:,:,l3) = normpdf(coefs{s}{l1,l2}(:,:,l3), 0, sqrt(Var{state}{s}{l1,l2}(:,:,l3))); 
%             coefsAtNorm = normpdf(coefs{lev}{dir}, 0, sqrt(Var{state}{lev}{dir})); 
%             GaussPDF{state}{lev}{dir} = max( coefsAtNorm, eps );  %eps = 2.2204e-016
                  ConditionalPDF{state}{s}{l1,l2}(:,:,l3) = Ps{state}{s}{l1,l2}(:,:,l3).*Pvs{state}{s}{l1,l2}(:,:,l3).*GaussPDF{state}{s}{l1,l2}(:,:,l3); 
                  end
            end
        end
    end
  end
end

% Initialize the Edge PDF structure-��ʼ����Ե�����ܶȺ����ṹ
for s= 1:nlev
    sz=length(ConditionalPDF{state}{s}) ;
    for l1 = 1:sz(1)
       for l2=1:sz(2)
          switch s
             case{1}
                 sz1=size(coefs{1}{1,1});
               for l3=1:sz1(3)
                   EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2},1), size(coefs{s}{l1,l2},2),0);
               end
             case{2}
                 sz2=size(coefs{2}{1,1});
               for l3=1:sz2(3)
                   EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2},1), size(coefs{s}{l1,l2},2),0);
               end
             case{3}
                 sz3=size(coefs{3}{1,1});
               for l3=1:sz3(3)
                   EdgePDF{s}{l1,l2}(:,:,l3) = zeros(size(coefs{s}{l1,l2},1), size(coefs{s}{l1,l2},2),0);
               end
          end
       end
    end
end

% Calculate the Edge Probability Density Function f(c) of the Contourlet
% Coefficients - ����������ϵ���ı�Ե�����ܶȺ���
for state = 1:ns    
    for s = 1:nlev
        sz=length(ConditionalPDF{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(2)
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

% Calculate the Hidden State Probability Function Ps|v(S=m|C,V) of the 
% Contourlet Coefficients - ����������ϵ������������״̬֮���Ps|v(S=m|C,V)
% ��ÿ��������ϵ��������������ı���V����״̬֮��ĸ���ֵ������ϵ��֮��������
for state = 1:ns    
    for s = 1:nlev
        sz=length(ConditionalPDF{state}{s});
        for l1 = 1:sz(1)
            for l2=sz(2)
              switch s
                case{1}
                    sz1=size(coefs{1}{1,1});
                  for l3=1:sz1(3)
                     Psv{state}{s}{l1,l2}(:,:,l3) = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                  end
                case{2}
                    sz2=size(coefs{1}{1,1});
                  for l3=1:sz2(3)
                     Psv{state}{s}{l1,l2}(:,:,l3) = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                  end
                case{3}
                    sz3=size(coefs{3}{1,1});
                  for l3=1:sz3(3)
                     Psv{state}{s}{l1,l2}(:,:,l3) = ConditionalPDF{state}{s}{l1,l2}(:,:,l3)./EdgePDF{s}{l1,l2}(:,:,l3);
                  end
              end
            end
        end
    end
end

%------------------------Maximization Step--M ����------------------------%

% Update Parameters for the next round of Iteration as follows
% ����״̬����Ps(m)������Var(m)��Pv|s(V=v|S=m)�Ĳ���ֵ
for state = 1:ns         %��ʼ������
    for s = 1:nlev       
        PsN{state}{s} = [];
        VarN{state}{s} = [];
        PvsN{state}{s} = [];
    end;
end
for state = 1:ns
    for lev = 1:nlev  
        sz=length(Psv{state}{s});
        for l1 = 1:sz(1)
            for l2=1:sz(2)
                switch s
                  case{1}
                      sz1=size(coefs{1}{1,1});
                    for l3=1:sz1(3)
                      windowsize = ones(2*s+1);
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)ϵ�����Ӵ��е�λ��]�ڲ�ͬ״̬�µĸ���ֵPs(m)
                      PsN{state}{s}{l1,l2}(:,:,l3) = filter2(windowsize,Psv{state}{s}{l1,l2}(:,:,l3),'same')./prod(size(windowsize));
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µķ���ֵVariance(m)
                      numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*Psv{state}{s}{l1,l2}(:,:,l3);
                      numerator = filter2(windowsize,numerator,'same');
                      VarN{state}{s}{l1,l2}(:,:,l3) = (numerator./(PsN{state}{s}{l1,l2}(:,:,l3)))./prod(size(windowsize));
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�»��������ı����ĸ���ֵPv|s(V=v|S=m)
                     Vtmp = V{s}{l1,l2}(:,:,l3);                         %��ȡ��ǰ�߶ȸ������Ӵ���Ӧ�����ı���V��ֵ
                     Vtmp = padarray(Vtmp,[s,s]);            %���б߽���ֵ����
                     p = Psv{state}{s}{s};                   %��ȡ��ͬ״̬����״̬���ʵ�ֵP(S=m|C)
                     p = padarray(p,[s,s]);                  %���б߽���ֵ����
                    for k = 1:size(PsN{state}{s}{l1,l2},1)
                       for i = 1:size(PsN{state}{s}{l1,l2},2)
                          sp = p(k:k+2*(s),i:i+2*(s));
                          Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                          sump = 0;                           %���򴰿����ڲ���ֲ�ͳ����Ϣ(Capture Local Statistics)
                          for x = 1:size(Neighbor,1)
                              for y = 1:size(Neighbor,2)
                                 if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                    sump = sump + sp(x,y);  %����sump���������ڼ��㲻ͬ״̬�µ���״̬���ʼӺ� 
                                 end
                              end
                          end
                    % �������򴰿���������Ϣ���²�ͬ״̬��Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)��ֵ
                                    PvsN{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./PsN{state}{s}{l1,l2}(k,i,l3);
                      end
                    end
                     end
                   case{2}
                       sz2=size(coefs{2}{1,1});
                    for l3=1:sz2(3)
                      windowsize = ones(2*s+1);
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)ϵ�����Ӵ��е�λ��]�ڲ�ͬ״̬�µĸ���ֵPs(m)
                      PsN{state}{s}{l1,l2}(:,:,l3) = filter2(windowsize,Psv{state}{s}{l1,l2}(:,:,l3),'same')./prod(size(windowsize));
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µķ���ֵVariance(m)
                      numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*Psv{state}{s}{l1,l2}(:,:,l3);
                      numerator = filter2(windowsize,numerator,'same');
                      VarN{state}{s}{l1,l2}(:,:,l3) = (numerator./(PsN{state}{s}{l1,l2}(:,:,l3)))./prod(size(windowsize));
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�»��������ı����ĸ���ֵPv|s(V=v|S=m)
                     Vtmp = V{s}{l1,l2}(:,:,l3);                         %��ȡ��ǰ�߶ȸ������Ӵ���Ӧ�����ı���V��ֵ
                     Vtmp = padarray(Vtmp,[s,s]);            %���б߽���ֵ����
                     p = Psv{state}{s}{s};                   %��ȡ��ͬ״̬����״̬���ʵ�ֵP(S=m|C)
                     p = padarray(p,[s,s]);                  %���б߽���ֵ����
                    for k = 1:size(PsN{state}{s}{l1,l2},1)
                       for i = 1:size(PsN{state}{s}{l1,l2},2)
                          sp = p(k:k+2*(s),i:i+2*(s));
                          Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                          sump = 0;                           %���򴰿����ڲ���ֲ�ͳ����Ϣ(Capture Local Statistics)
                          for x = 1:size(Neighbor,1)
                              for y = 1:size(Neighbor,2)
                                 if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                    sump = sump + sp(x,y);  %����sump���������ڼ��㲻ͬ״̬�µ���״̬���ʼӺ� 
                                 end
                              end
                          end
                    % �������򴰿���������Ϣ���²�ͬ״̬��Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)��ֵ
                                    PvsN{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./PsN{state}{s}{l1,l2}(k,i,l3);
                      end
                    end
                     end
                    case{3}
                        sz3=size(coefs{3}{1,1});
                      for l3=1:sz3(3)
                         windowsize = ones(2*s+1);
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)ϵ�����Ӵ��е�λ��]�ڲ�ͬ״̬�µĸ���ֵPs(m)
                         PsN{state}{s}{l1,l2}(:,:,l3) = filter2(windowsize,Psv{state}{s}{l1,l2}(:,:,l3),'same')./prod(size(windowsize));
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µķ���ֵVariance(m)
                         numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*Psv{state}{s}{l1,l2}(:,:,l3);
                         numerator = filter2(windowsize,numerator,'same');
                         VarN{state}{s}{l1,l2}(:,:,l3) = (numerator./(PsN{state}{s}{l1,l2}(:,:,l3)))./prod(size(windowsize));
            
            % ���¸�����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�»��������ı����ĸ���ֵPv|s(V=v|S=m)
                         Vtmp = V{s}{l1,l2}(:,:,l3);                         %��ȡ��ǰ�߶ȸ������Ӵ���Ӧ�����ı���V��ֵ
                         Vtmp = padarray(Vtmp,[s,s]);            %���б߽���ֵ����
                          p = Psv{state}{s}{s};                   %��ȡ��ͬ״̬����״̬���ʵ�ֵP(S=m|C)
                          p = padarray(p,[s,s]);                  %���б߽���ֵ����
                          for k = 1:size(PsN{state}{s}{l1,l2},1)
                              for i = 1:size(PsN{state}{s}{l1,l2},2)
                                sp = p(k:k+2*(s),i:i+2*(s));
                                Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                                sump = 0;                           %���򴰿����ڲ���ֲ�ͳ����Ϣ(Capture Local Statistics)
                                for x = 1:size(Neighbor,1)
                                   for y = 1:size(Neighbor,2)
                                      if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                         sump = sump + sp(x,y);  %����sump���������ڼ��㲻ͬ״̬�µ���״̬���ʼӺ� 
                                      end
                                   end
                                 end
                    % �������򴰿���������Ϣ���²�ͬ״̬��Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)��ֵ
                                    PvsN{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./PsN{state}{s}{l1,l2}(k,i,l3);
                               end
                          end
                      end
                 end
           end
       end
    end
end