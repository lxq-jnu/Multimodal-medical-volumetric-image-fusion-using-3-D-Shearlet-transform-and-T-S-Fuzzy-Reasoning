function coefsF=choose1(featureA,featureB,coefsA,coefsB)

% W1=A./(A+B+C);
% W2=B./(A+B+C);
% W3=C./(A+B+C);

for level=1:3
    switch level
        case{1}
            for l1=1:2
                for l2=1:2
                    for l3=1:12
                      a=(featureA{level}{l1,l2}(:,:,l3)>=featureB{level}{l1,l2}(:,:,l3)) ;
                      coefsF{level}{l1,l2}(:,:,l3)=a.*coefsA{level}{l1,l2}(:,:,l3)+(1-a).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
            end
       
        case{2}
            
             for l1=1:2
                for l2=1:2
                    for l3=1:8
                         a=(featureA{level}{l1,l2}(:,:,l3)>=featureB{level}{l1,l2}(:,:,l3)) ;
                      coefsF{level}{l1,l2}(:,:,l3)=a.*coefsA{level}{l1,l2}(:,:,l3)+(1-a).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
            end
        case{3}
             for l1=1:2
                for l2=1:2
                    for l3=1:4
                        a=(featureA{level}{l1,l2}(:,:,l3)>=featureB{level}{l1,l2}(:,:,l3)) ;
                      coefsF{level}{l1,l2}(:,:,l3)=a.*coefsA{level}{l1,l2}(:,:,l3)+(1-a).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
            end
    end
end
              