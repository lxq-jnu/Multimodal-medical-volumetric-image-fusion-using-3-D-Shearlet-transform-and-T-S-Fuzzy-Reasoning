function [entroyA,entroyB]=type222(coefsA,coefsB)
for level=1:3
    switch level
        case{1}
            for l1=1:2
                for l2=1:2
                    for l3=1:12
                        [entroyA{level}{l1,l2}(:,:,l3),entroyB{level}{l1,l2}(:,:,l3)]=type2(coefsA{level}{l1,l2}(:,:,l3),coefsB{level}{l1,l2}(:,:,l3));
                    end
                end
            end
        case{2}
            
              for l1=1:2
                for l2=1:2
                    for l3=1:8
                        [entroyA{level}{l1,l2}(:,:,l3),entroyB{level}{l1,l2}(:,:,l3)]=type2(coefsA{level}{l1,l2}(:,:,l3),coefsB{level}{l1,l2}(:,:,l3));
                    end
                end
              end  
        case{3}
            for l1=1:2
                for l2=1:2
                    for l3=1:4
                       [entroyA{level}{l1,l2}(:,:,l3),entroyB{level}{l1,l2}(:,:,l3)]=type2(coefsA{level}{l1,l2}(:,:,l3),coefsB{level}{l1,l2}(:,:,l3));
                    end
                end
            end
    end
end
              