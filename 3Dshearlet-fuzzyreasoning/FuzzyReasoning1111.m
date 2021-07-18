function [f]=FuzzyReasoning1111(A,B,C)
% a=max(max(A))-min(min(A))./2;
% b=max(max(B))-min(min(B))./2;
% c=max(max(C))-min(min(C))./2;


for level=1:3%3层分别推理
    switch level
        case{1}
            for l1=1:2
                for l2=1:2
                    for l3=1:12
                        for i=1:192
                            for j=1:192
                                AA=0;BB=0;CC=0;
                               for p = -1:1
                                 for q = -1:1
                                    AA=AA+A{level}{l1,l2}(i+1+p,j+1+q,l3);
                                    BB=BB+B{level}{l1,l2}(i+1+p,j+1+q,l3);
                                    CC=CC+C{level}{l1,l2}(i+1+p,j+1+q,l3);
                                     
                                 end   
                              end 
%                                f{level}{l1,l2}(x,y,l3)=FuzzyReasoning4(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
%                               fA(i+1+p,j+1+q)=FuzzyReasoning2(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
                              AAA=AA./9;
                              BBB=BB./9;
                              CCC=CC./9;
                               f{level}{l1,l2}(i,j,l3)= FuzzyReasoning6(AAA,BBB,CCC);
%                                      f=f+f1;
%                                      ff{level}{l1,l2}(i,j,l3)=f./9;
                                
                            end
                        end
                    
                        
                         
                    end
                end
            end
        case{2}
            
              for l1=1:2
                for l2=1:2
                    for l3=1:8
                        for i=1:128
                            for j=1:128
                                 AA=0;BB=0;CC=0;
                               for p = -1:1
                                 for q = -1:1
                                     AA=AA+A{level}{l1,l2}(i+1+p,j+1+q,l3);
                                    BB=BB+B{level}{l1,l2}(i+1+p,j+1+q,l3);
                                    CC=CC+C{level}{l1,l2}(i+1+p,j+1+q,l3);
                                     
                                 end   
                              end 
%                                f{level}{l1,l2}(x,y,l3)=FuzzyReasoning4(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
%                               fA(i+1+p,j+1+q)=FuzzyReasoning2(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
                              AAA=AA./9;
                              BBB=BB./9;
                              CCC=CC./9;
                               f{level}{l1,l2}(i,j,l3)= FuzzyReasoning6(AAA,BBB,CCC);
%                                      f=f+f1;
%                                      ff{level}{l1,l2}(i,j,l3)=f./9;
                            end   
                       end 
%                                f{level}{l1,l2}(x,y,l3)=FuzzyReasoning4(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
%                               f{level}{l1,l2}(x,y,l3)=FuzzyReasoning2(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
%                                ff{level}{l1,l2}(i,j,l3)=f./9;
%                                        f{level}{l1,l2}(x,y,l3)=FuzzyReasoning2(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
%                       [R2{level}{l1,l2}(x+1+p,y+1+q,l3),uR2{level}{l1,l2}(x+1+p,y+1+q,l3)]=FuzzyReasoning2(A{level}{l1,l2}(x+p+1,y+q+1,l3),B{level}{l1,l2}(x+p+1,y+q+1,l3),C{level}{l1,l2}(x+p+1,y+q+1,l3));
                                       
                                    
                                
                                
                    end
                end
             end
                
        case{3}
            for l1=1:2
                for l2=1:2
                    for l3=1:4
                        for i=1:64
                            for j=1:64
                             AA=0;BB=0;CC=0;
                               for p = -1:1
                                 for q = -1:1
                                     AA=AA+A{level}{l1,l2}(i+1+p,j+1+q,l3);
                                    BB=BB+B{level}{l1,l2}(i+1+p,j+1+q,l3);
                                    CC=CC+C{level}{l1,l2}(i+1+p,j+1+q,l3);
                                     
                                 end   
                              end 
%                                f{level}{l1,l2}(x,y,l3)=FuzzyReasoning4(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
%                               fA(i+1+p,j+1+q)=FuzzyReasoning2(A{level}{l1,l2}(x,y,l3),B{level}{l1,l2}(x,y,l3),C{level}{l1,l2}(x,y,l3));
                              AAA=AA./9;
                              BBB=BB./9;
                              CCC=CC./9;
                               f{level}{l1,l2}(i,j,l3)= FuzzyReasoning6(AAA,BBB,CCC);
%                                      f=f+f1;
%                                      ff{level}{l1,l2}(i,j,l3)=f./9;
                            end
                        end
                    end
                end
            end
    end
end

              
