function coefsF=choose2(entroyA,entroyB,gadA,gadB,coefsA,coefsB)



for level=1:3
    switch level
        case{1}
            for l1=1:2
                for l2=1:2
                    for l3=1:12
                         a=abs(entroyA{level}{l1,l2}(:,:,l3));b=abs(entroyB{level}{l1,l2}(:,:,l3));
                         c=abs(gadA{level}{l1,l2}(:,:,l3));d=abs(gadB{level}{l1,l2}(:,:,l3));
                         e=(a>=b).*(c>=d);
                         f=(a<b).*(c<d);
                         g=(a>=b).*(c<d);
                         h=(a<b).*(c>=d);
                         featureA{level}{l1,l2}(:,:,l3)=multifeaturetype223(entroyA{level}{l1,l2}(:,:,l3),gadA{level}{l1,l2}(:,:,l3));
                         featureB{level}{l1,l2}(:,:,l3)=multifeaturetype223(entroyB{level}{l1,l2}(:,:,l3),gadB{level}{l1,l2}(:,:,l3));
                         A=g.*featureA{level}{l1,l2}(:,:,l3)+h.*featureA{level}{l1,l2}(:,:,l3);
                         B=g.*featureB{level}{l1,l2}(:,:,l3)+h.*featureB{level}{l1,l2}(:,:,l3);
                         coefsF{level}{l1,l2}(:,:,l3)=e.*coefsA{level}{l1,l2}(:,:,l3)+f.*coefsB{level}{l1,l2}(:,:,l3)+(A>B).*coefsA{level}{l1,l2}(:,:,l3)+(A<B).*coefsB{level}{l1,l2}(:,:,l3);
                        
                         
                    end
                end
            end
        case{2}
            
              for l1=1:2
                for l2=1:2
                    for l3=1:8
                        a=abs(entroyA{level}{l1,l2}(:,:,l3));b=abs(entroyB{level}{l1,l2}(:,:,l3));
                         c=abs(gadA{level}{l1,l2}(:,:,l3));d=abs(gadB{level}{l1,l2}(:,:,l3));
                         e=(a>=b).*(c>=d);
                         f=(a<b).*(c<d);
                         g=(a>=b).*(c<d);
                         h=(a<b).*(c>=d);
                         featureA{level}{l1,l2}(:,:,l3)=multifeaturetype223(entroyA{level}{l1,l2}(:,:,l3),gadA{level}{l1,l2}(:,:,l3));
                         featureB{level}{l1,l2}(:,:,l3)=multifeaturetype223(entroyB{level}{l1,l2}(:,:,l3),gadB{level}{l1,l2}(:,:,l3));
                         A=g.*featureA{level}{l1,l2}(:,:,l3)+h.*featureA{level}{l1,l2}(:,:,l3);
                         B=g.*featureB{level}{l1,l2}(:,:,l3)+h.*featureB{level}{l1,l2}(:,:,l3);
                         coefsF{level}{l1,l2}(:,:,l3)=e.*coefsA{level}{l1,l2}(:,:,l3)+f.*coefsB{level}{l1,l2}(:,:,l3)+(A>B).*coefsA{level}{l1,l2}(:,:,l3)+(A<B).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
              end  
        case{3}
            for l1=1:2
                for l2=1:2
                    for l3=1:4
                      a=abs(entroyA{level}{l1,l2}(:,:,l3));b=abs(entroyB{level}{l1,l2}(:,:,l3));
                         c=abs(gadA{level}{l1,l2}(:,:,l3));d=abs(gadB{level}{l1,l2}(:,:,l3));
                         e=(a>=b).*(c>=d);
                         f=(a<b).*(c<d);
                         g=(a>=b).*(c<d);
                         h=(a<b).*(c>=d);
                         featureA{level}{l1,l2}(:,:,l3)=multifeaturetype223(entroyA{level}{l1,l2}(:,:,l3),gadA{level}{l1,l2}(:,:,l3));
                         featureB{level}{l1,l2}(:,:,l3)=multifeaturetype223(entroyB{level}{l1,l2}(:,:,l3),gadB{level}{l1,l2}(:,:,l3));
                         A=g.*featureA{level}{l1,l2}(:,:,l3)+h.*featureA{level}{l1,l2}(:,:,l3);
                         B=g.*featureB{level}{l1,l2}(:,:,l3)+h.*featureB{level}{l1,l2}(:,:,l3);
                         coefsF{level}{l1,l2}(:,:,l3)=e.*coefsA{level}{l1,l2}(:,:,l3)+f.*coefsB{level}{l1,l2}(:,:,l3)+(A>B).*coefsA{level}{l1,l2}(:,:,l3)+(A<B).*coefsB{level}{l1,l2}(:,:,l3);
                    end
                end
           end
     end
 end

              