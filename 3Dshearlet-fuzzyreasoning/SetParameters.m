function [Ps, Var, Pvs] = SetParameters(coefs, model, stateprob, V)
%% Finish the Initialization Stage by Setting the Following Parameters
% Input:
%   coefs     : Contourlet Coefficients - ������ϵ��
%   model     : Initial Model by EM Step - ����EM�����ʼ�����ģ��
%   stateprob : The Post State Probability - ��״̬����P(Si=m|C,��)
%   V         : The Values of the Context Variable(MI based Context Design Procedure) - ���ڻ���Ϣ�������ı���ȡֵ
%
% Output:
% ��������Ӧÿ����Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)������ϵ�����Ӵ��е�λ��]
%   Ps        : ������ϵ���ڲ�ͬ״̬�µĸ���ֵPs(m)
%   Var       : ������ϵ���ڲ�ͬ״̬�µķ���ֵVariance(m)
%   Pvs       ��������ϵ���ڲ�ͬ״̬�»��������ı����ĸ���ֵPv|s(V=v|S=m)
%
%% ��������ͼ��(����)������Ĺ��ܺ���--padarray()��ʹ��˵��
% B = padarray(A,padsize,padval,direction)
% AΪ����ͼ��BΪ�����ͼ��padsize��������������������ͨ����[r c]����ʾ��
% padval��direction�ֱ��ʾ��䷽���ͷ������ǵľ���ֵ���������£�
%     padval: 'symmetric'��ʾͼ���Сͨ��Χ�Ʊ߽���о���������չ��
%             'replicate'��ʾͼ���Сͨ��������߽��е�ֵ����չ��
%             'circular'ͼ���Сͨ����ͼ�񿴳���һ����ά���ں�����һ��������������չ��
%     direction: 'pre'��ʾ��ÿһά�ĵ�һ��Ԫ��ǰ��䣻
%                'post'��ʾ��ÿһά�����һ��Ԫ�غ���䣻
%                'both'��ʾ��ÿһά�ĵ�һ��Ԫ��ǰ�����һ��Ԫ�غ���䣬����ΪĬ��ֵ��
% �������в�����direction����Ĭ��ֵΪ'both'���������в�����padval����Ĭ����������䡣
% �������в������κβ�������Ĭ�����Ϊ���ҷ���Ϊ'both'���ڼ������ʱ��ͼ��ᱻ�޼���ԭʼ��С��

%% 
ns = model.nstates;      %״̬��Ŀ
nlev = model.nlevels;    %�ֽ�߶�
for state = 1:ns         %��ʼ������
    for lev = 1:nlev  
        sz=size(stateprob{state}{lev});
        for l1=1:sz(1)
            for l2=1:sz(2)
        Ps{state}{lev}{l1,l2} = [];
        Var{state}{lev}{l1,l2} = [];
        Pvs{state}{lev}{l1,l2} = [];
            end
        end
    end;
end
  
% Window Size - ��ͬ�߶�ѡ�ò�ͬ�Ĵ��ڴ�С - 5*5��7*7��9*9��11*11
% windowsize1 = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1;1 1 1 1 1; 1 1 1 1 1];
% windowsize2 = [1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1;
%                1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1];
% windowsize3 = [1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1;
%                1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 1 1;
%                1 1 1 1 1 1 1 1 1];
% windowsize4 = ones(11,11);    %����11��11��С�ľ��򴰿�

for state = 1:ns
    for s = 1:nlev
        sz=size(stateprob{state}{s});
        for l1 = 1:sz(1)
            for l2 =1:sz(2)
               switch s
                 case{1}
                      sz1=size(coefs{1}{1,1});
                   for l3=1:sz1(3)
                      windowsize = ones(2*s+1);
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)ϵ�����Ӵ��е�λ��]�ڲ�ͬ״̬�µĸ���ֵPs(m)
                    sptmp = padarray(stateprob{state}{s}{l1,l2}(:,:,l3),[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
                    Pstmp = filter2(windowsize,sptmp,'same')./prod(size(windowsize));
                    Ps{state}{s}{l1,l2}(:,:,l3) = Pstmp(s+1:end-s,s+1:end-s);
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µķ���ֵVariance(m)
                    numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
                    numerator = padarray(numerator,[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
                    numerator = filter2(windowsize,numerator,'same')./prod(size(windowsize));
                   N1 = numerator(s+1:end-s,s+1:end-s)./(Ps{state}{s}{l1,l2}(:,:,l3));
                    Var{state}{s}{l1,l2}(:,:,l3)=N1;
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µĸ���Pv|s(V=v|S=m)
                   Vtmp = V{s}{l1,l2}(:,:,l3);                           %��ȡ��ǰ�߶ȸ������Ӵ���Ӧ�����ı���V��ֵ
                   Vtmp = padarray(Vtmp,[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
%             Vtmp = padarray(Vtmp,[lev,lev]);              %���б߽���ֵ����  
                   for k = 1:size(Ps{state}{s}{l1,l2}(:,:,l3),1)
                      for i = 1:size(Ps{state}{s}{l1,l2}(:,:,l3),2) 
                          sp = sptmp(k:k+2*(s),i:i+2*(s));
                          Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                          sump = 0;                             %���򴰿����ڲ���ֲ�ͳ����Ϣ(Capture Local Statistics)
                         for x = 1:size(Neighbor,1)
                            for y = 1:size(Neighbor,2)
                              if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                sump = sump + sp(x,y);    %����sump���������ڼ��㲻ͬ״̬�µ���״̬���ʼӺ� 
                              end
                            end
                         end
                    % �������򴰿���������Ϣ�ó���ͬ״̬��Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)��ֵ
                    Pvs{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./Ps{state}{s}{l1,l2}(k,i,l3);
                     end
                   end
                   end
             case{2}
                  sz2=size(coefs{2}{1,1});
               for l3=1:sz2(3)
                      windowsize = ones(2*s+1);
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)ϵ�����Ӵ��е�λ��]�ڲ�ͬ״̬�µĸ���ֵPs(m)
                    sptmp = padarray(stateprob{state}{s}{l1,l2}(:,:,l3),[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
                    Pstmp = filter2(windowsize,sptmp,'same')./prod(size(windowsize));
                    Ps{state}{s}{l1,l2}(:,:,l3) = Pstmp(s+1:end-s,s+1:end-s);
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µķ���ֵVariance(m)
                    numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
                    numerator = padarray(numerator,[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
                    numerator = filter2(windowsize,numerator,'same')./prod(size(windowsize));
                    N2 = numerator(s+1:end-s,s+1:end-s)./(Ps{state}{s}{l1,l2}(:,:,l3));
                    Var{state}{s}{l1,l2}(:,:,l3)=N2;
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µĸ���Pv|s(V=v|S=m)
                   Vtmp = V{s}{l1,l2}(:,:,l3);                           %��ȡ��ǰ�߶ȸ������Ӵ���Ӧ�����ı���V��ֵ
                   Vtmp = padarray(Vtmp,[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
%             Vtmp = padarray(Vtmp,[lev,lev]);              %���б߽���ֵ����  
                   for k = 1:size(Ps{state}{s}{l1,l2}(:,:,l3),1)
                      for i = 1:size(Ps{state}{s}{l1,l2}(:,:,l3),2) 
                          sp = sptmp(k:k+2*(s),i:i+2*(s));
                          Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                          sump = 0;                             %���򴰿����ڲ���ֲ�ͳ����Ϣ(Capture Local Statistics)
                         for x = 1:size(Neighbor,1)
                            for y = 1:size(Neighbor,2)
                              if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                sump = sump + sp(x,y);    %����sump���������ڼ��㲻ͬ״̬�µ���״̬���ʼӺ� 
                              end
                            end
                         end
                    % �������򴰿���������Ϣ�ó���ͬ״̬��Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)��ֵ
                    Pvs{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./Ps{state}{s}{l1,l2}(k,i,l3);
                     end
                   end
                end
          case{3}
               sz3=size(coefs{3}{1,1});
                   for l3=1:sz3(3)
                      windowsize = ones(2*s+1);
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)[lev�߶ȣ�dir����(k,i)ϵ�����Ӵ��е�λ��]�ڲ�ͬ״̬�µĸ���ֵPs(m)
                    sptmp = padarray(stateprob{state}{s}{l1,l2}(:,:,l3),[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
                    Pstmp = filter2(windowsize,sptmp,'same')./prod(size(windowsize));
                    Ps{state}{s}{l1,l2}(:,:,l3) = Pstmp(s+1:end-s,s+1:end-s);
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µķ���ֵVariance(m)
                    numerator = ((coefs{s}{l1,l2}(:,:,l3)-0).^2).*stateprob{state}{s}{l1,l2}(:,:,l3);
                    numerator = padarray(numerator,[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
                    numerator = filter2(windowsize,numerator,'same')./prod(size(windowsize));
                    N3 = numerator(s+1:end-s,s+1:end-s)./(Ps{state}{s}{l1,l2}(:,:,l3));
                    Var{state}{s}{l1,l2}(:,:,l3)=N3;
            
            % ���������Ƶ�Ӵ�ϵ��C(lev,dir,k,i)�ڲ�ͬ״̬�µĸ���Pv|s(V=v|S=m)
                   Vtmp = V{s}{l1,l2}(:,:,l3);                           %��ȡ��ǰ�߶ȸ������Ӵ���Ӧ�����ı���V��ֵ
                   Vtmp = padarray(Vtmp,[s,s],'symmetric');  %Χ�Ʊ߽���о���������չ
%             Vtmp = padarray(Vtmp,[lev,lev]);              %���б߽���ֵ����  
                   for k = 1:size(Ps{state}{s}{l1,l2}(:,:,l3),1)
                      for i = 1:size(Ps{state}{s}{l1,l2}(:,:,l3),2) 
                          sp = sptmp(k:k+2*(s),i:i+2*(s));
                          Neighbor = Vtmp(k:k+2*(s),i:i+2*(s));
                          sump = 0;                             %���򴰿����ڲ���ֲ�ͳ����Ϣ(Capture Local Statistics)
                         for x = 1:size(Neighbor,1)
                            for y = 1:size(Neighbor,2)
                              if(Neighbor(x,y)==Neighbor((prod(size(windowsize))+1)/2))
                                sump = sump + sp(x,y);    %����sump���������ڼ��㲻ͬ״̬�µ���״̬���ʼӺ� 
                              end
                            end
                         end
                    % �������򴰿���������Ϣ�ó���ͬ״̬��Pv(lev,dir,k,i)|s(lev,dir,k,i)(v|m)��ֵ
                    Pvs{state}{s}{l1,l2}(k,i,l3) = sump./prod(size(windowsize))./Ps{state}{s}{l1,l2}(k,i,l3);
                     end
                  end
                  end

              end
           end
       end

   end
end