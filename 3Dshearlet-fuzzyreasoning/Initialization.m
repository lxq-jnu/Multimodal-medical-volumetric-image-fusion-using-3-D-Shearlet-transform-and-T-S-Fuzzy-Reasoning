function Initmodel = Initialization(coefs)
%%
% Initialize CHMM Model - ��ʼ��Contourlet��������Ʒ�ģ�� CHMM Model ����
% This file makes an Initial Values for the Contourlet Contextual HMM.
%
% Input:
%   coefs     ��the Contourlet Coefficients which used to Initialize the Model.
%
% Output:
%   Initmodel ��Generate an Initial Contourlet Domain Hidden Markov Model
%
% Define the Number of States - ������״̬�����ֵGMM�ƽ�������ϵ���ķǸ�˹��Ե�ֲ�
% state = 1��С״̬-��Ӧͼ��ƽ������state = 2����״̬-��Ӧͼ���Ե����
ns = 2;  
nlev = length(coefs);  % Get the number of levels - �ֽ�߶�

% Create the structure that is needed in each cell entry of the model
% ����struct() - Create or convert to structure array.
% S = STRUCT('field1',VALUES1,'field2',VALUES2,...)-����һ������ָ���ֶ�������Ӧ���ݵĽṹ����
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
                       s.Ps{lev}{l1,l2}(:,:,l3) = [0.5 0.5];  %the State Probability - ���Ӵ�PMF 
        
                       C = coefs{lev}{l1,l2}(:,:,l3);         %Contourlet Coefficients - �����Ӵ�ϵ��
                       avgenergy = mean2(C.^2);     %Average Energy - �����Ӵ�ϵ����ƽ������
                       avgenergy = avgenergy*(avgenergy>1e-6)+1e-6*(avgenergy<=1e-6);
                       s.var{lev}{l1,l2}(:,:,l3) = avgenergy*linspace(0.5,2.0,2);%Gauss Variance - ��˹���� 
                      
                   end
               case{2}
                   sz2=size(coefs{2}{1,1});
                for l3=1:sz2(3)
                    s.Ps{lev}{l1,l2}(:,:,l3) = [0.5 0.5];  %the State Probability - ���Ӵ�PMF        
                    C = coefs{lev}{l1,l2}(:,:,l3);         %Contourlet Coefficients - �����Ӵ�ϵ��
                   avgenergy = mean2(C.^2);     %Average Energy - �����Ӵ�ϵ����ƽ������
                   avgenergy = avgenergy*(avgenergy>1e-6)+1e-6*(avgenergy<=1e-6);
                   s.var{lev}{l1,l2}(:,:,l3) = 2*avgenergy*linspace(0.5,2.0,2);%Gauss Variance - ��˹���� 
                end
               case{3}
                   sz3=size(coefs{3}{1,1});
                   for l3=1:sz3(3)
                      s.Ps{lev}{l1,l2}(:,:,l3) = [0.5 0.5];  %the State Probability - ���Ӵ�PMF         
                      C = coefs{lev}{l1,l2}(:,:,l3);         %Contourlet Coefficients - �����Ӵ�ϵ��
                      avgenergy = mean2(C.^2);     %Average Energy - �����Ӵ�ϵ����ƽ������
                      avgenergy = avgenergy*(avgenergy>1e-6)+1e-6*(avgenergy<=1e-6);
                      s.var{lev}{l1,l2}(:,:,l3) = 2*avgenergy*linspace(0.5,2.0,2);%Gauss Variance - ��˹����
                   end
           end
        end
    end 
end

Initmodel = s;