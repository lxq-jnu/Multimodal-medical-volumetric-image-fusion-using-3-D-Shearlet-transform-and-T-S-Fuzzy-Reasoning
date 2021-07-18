function coefsF=choosemax(coefsA,coefsB)
for level=1:3
    switch level
        case{1}
            for l1=1:2
                for l2=1:2
                    for l3=1:12
                      a=(coefsA{level}{l1,l2}(:,:,l3)>=coefsB{level}{l1,l2}(:,:,l3)) ;
                      coefsF{level}{l1,l2}(:,:,l3)=a.*coefsA{level}{l1,l2}(:,:,l3)+(1-a).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
            end
       
        case{2}
            
             for l1=1:2
                for l2=1:2
                    for l3=1:8
                         a=(coefsA{level}{l1,l2}(:,:,l3)>=coefsB{level}{l1,l2}(:,:,l3)) ;
                      coefsF{level}{l1,l2}(:,:,l3)=a.*coefsA{level}{l1,l2}(:,:,l3)+(1-a).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
            end
        case{3}
             for l1=1:2
                for l2=1:2
                    for l3=1:4
                        a=(coefsA{level}{l1,l2}(:,:,l3)>=coefsB{level}{l1,l2}(:,:,l3)) ;
                      coefsF{level}{l1,l2}(:,:,l3)=a.*coefsA{level}{l1,l2}(:,:,l3)+(1-a).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
            end
    end
end
              