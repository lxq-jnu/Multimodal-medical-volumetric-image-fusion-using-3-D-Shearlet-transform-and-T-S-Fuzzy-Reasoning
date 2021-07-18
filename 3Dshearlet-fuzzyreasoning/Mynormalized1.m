function feature=Mynormalized1(A,B,C)



for level=1:3
    switch level
        case{1}
            for l1=1:2
                for l2=1:2
                    for l3=1:12
                    
                       feature{level}{l1,l2}(:,:,l3)=Mynormalized(A{level}{l1,l2}(:,:,l3),B{level}{l1,l2}(:,:,l3),C{level}{l1,l2}(:,:,l3));
%                        feature2{level}{l1,l2}(:,:,l3)=Mynormalized(B{level}{l1,l2}(:,:,l3));

                    
                        
                         
                    end
                end
            end
        case{2}
            
              for l1=1:2
                for l2=1:2
                    for l3=1:8
                       feature{level}{l1,l2}(:,:,l3)=Mynormalized(A{level}{l1,l2}(:,:,l3),B{level}{l1,l2}(:,:,l3),C{level}{l1,l2}(:,:,l3));
   
                      
                    end
                end
              end  
        case{3}
            for l1=1:2
                for l2=1:2
                    for l3=1:4
                     feature{level}{l1,l2}(:,:,l3)=Mynormalized(A{level}{l1,l2}(:,:,l3),B{level}{l1,l2}(:,:,l3),C{level}{l1,l2}(:,:,l3));

                     end
                 end
           end
     end
 end

              
