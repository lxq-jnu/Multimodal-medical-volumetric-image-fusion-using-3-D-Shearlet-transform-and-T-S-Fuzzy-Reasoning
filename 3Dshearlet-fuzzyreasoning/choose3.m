function coefsF=choose3(edgeA,edgeB,energyA,energyB,entroyA,entroyB,gadA,gadB,coefsA,coefsB)



for level=1:3
    switch level
        case{1}
            for l1=1:2
                for l2=1:2
                    for l3=1:12
                         a=abs(entroyA{level}{l1,l2}(:,:,l3));b=abs(entroyB{level}{l1,l2}(:,:,l3));
                         c=abs(gadA{level}{l1,l2}(:,:,l3));d=abs(gadB{level}{l1,l2}(:,:,l3));
                         e=abs(energyA{level}{l1,l2}(:,:,l3));f=abs(energyB{level}{l1,l2}(:,:,l3));
                         g=abs(edgeA{level}{l1,l2}(:,:,l3));h=abs(edgeB{level}{l1,l2}(:,:,l3));
                         a1=(a>b);
                         b1=(c>d);
                         c1=(e>f);
                         d1=(g>h);
                          coefsF{level}{l1,l2}(:,:,l3)=((a1+b1+c1+d1)>3).*coefsA{level}{l1,l2}(:,:,l3)+((a1+b1+c1+d1)<=3).*coefsB{level}{l1,l2}(:,:,l3);
                       
%                          g=(a>=b).*(c<d);
%                          h=(a<b).*(c>=d);
%                          featureA{level}{l1,l2}(:,:,l3)=multifeaturetype223(EdgePDFA{level}{l1,l2}(:,:,l3),energyA{level}{l1,l2}(:,:,l3),entroyA{level}{l1,l2}(:,:,l3),gadA{level}{l1,l2}(:,:,l3));
%                          featureB{level}{l1,l2}(:,:,l3)=multifeaturetype223(EdgePDFB{level}{l1,l2}(:,:,l3),energyB{level}{l1,l2}(:,:,l3),entroyB{level}{l1,l2}(:,:,l3),gadB{level}{l1,l2}(:,:,l3));
%                          A=g.*featureA{level}{l1,l2}(:,:,l3)+h.*featureA{level}{l1,l2}(:,:,l3);
%                          B=g.*featureB{level}{l1,l2}(:,:,l3)+h.*featureB{level}{l1,l2}(:,:,l3);
%                          a=(featureA{level}{l1,l2}(:,:,l3)>=featureB{level}{l1,l2}(:,:,l3));
%                          coefsF{level}{l1,l2}(:,:,l3)=e.*coefsA{level}{l1,l2}(:,:,l3)+f.*coefsB{level}{l1,l2}(:,:,l3)+(1-(e+f)).*((coefsA{level}{l1,l2}(:,:,l3)+coefsB{level}{l1,l2}(:,:,l3))./2);
                        
                         
                    end
                end
            end
        case{2}
            
              for l1=1:2
                for l2=1:2
                    for l3=1:8
                        a=abs(entroyA{level}{l1,l2}(:,:,l3));b=abs(entroyB{level}{l1,l2}(:,:,l3));
                         c=abs(gadA{level}{l1,l2}(:,:,l3));d=abs(gadB{level}{l1,l2}(:,:,l3));
                         e=abs(energyA{level}{l1,l2}(:,:,l3));f=abs(energyB{level}{l1,l2}(:,:,l3));
                         g=abs(edgeA{level}{l1,l2}(:,:,l3));h=abs(edgeB{level}{l1,l2}(:,:,l3));
                         a1=(a>b);
                         b1=(c>d);
                         c1=(e>f);
                         d1=(g>h);
                          coefsF{level}{l1,l2}(:,:,l3)=((a1+b1+c1+d1)>3).*coefsA{level}{l1,l2}(:,:,l3)+((a1+b1+c1+d1)<=3).*coefsB{level}{l1,l2}(:,:,l3);
%                          g=(a>=b).*(c<d);
%                          h=(a<b).*(c>=d);
%                          featureA{level}{l1,l2}(:,:,l3)=multifeaturetype223(EdgePDFA{level}{l1,l2}(:,:,l3),energyA{level}{l1,l2}(:,:,l3),entroyA{level}{l1,l2}(:,:,l3),gadA{level}{l1,l2}(:,:,l3));
%                          featureB{level}{l1,l2}(:,:,l3)=multifeaturetype223(EdgePDFB{level}{l1,l2}(:,:,l3),energyB{level}{l1,l2}(:,:,l3),entroyB{level}{l1,l2}(:,:,l3),gadB{level}{l1,l2}(:,:,l3));
%                          A=g.*featureA{level}{l1,l2}(:,:,l3)+h.*featureA{level}{l1,l2}(:,:,l3);
%                          B=g.*featureB{level}{l1,l2}(:,:,l3)+h.*featureB{level}{l1,l2}(:,:,l3);
%                          a=(featureA{level}{l1,l2}(:,:,l3)>=featureB{level}{l1,l2}(:,:,l3));
%                          coefsF{level}{l1,l2}(:,:,l3)=e.*coefsA{level}{l1,l2}(:,:,l3)+f.*coefsB{level}{l1,l2}(:,:,l3)+(1-(e+f)).*((coefsA{level}{l1,l2}(:,:,l3)+coefsB{level}{l1,l2}(:,:,l3))./2);   
                    end
                end
              end  
        case{3}
            for l1=1:2
                for l2=1:2
                    for l3=1:4
                        a=abs(entroyA{level}{l1,l2}(:,:,l3));b=abs(entroyB{level}{l1,l2}(:,:,l3));
                         c=abs(gadA{level}{l1,l2}(:,:,l3));d=abs(gadB{level}{l1,l2}(:,:,l3));
                         e=abs(energyA{level}{l1,l2}(:,:,l3));f=abs(energyB{level}{l1,l2}(:,:,l3));
                         g=abs(edgeA{level}{l1,l2}(:,:,l3));h=abs(edgeB{level}{l1,l2}(:,:,l3));
                         a1=(a>b);
                         b1=(c>d);
                         c1=(e>f);
                         d1=(g>h);
                          coefsF{level}{l1,l2}(:,:,l3)=((a1+b1+c1+d1)>3).*coefsA{level}{l1,l2}(:,:,l3)+((a1+b1+c1+d1)<=3).*coefsB{level}{l1,l2}(:,:,l3);
%                          g=(a>=b).*(c<d);
%                          h=(a<b).*(c>=d);
%                          featureA{level}{l1,l2}(:,:,l3)=multifeaturetype223(EdgePDFA{level}{l1,l2}(:,:,l3),energyA{level}{l1,l2}(:,:,l3),entroyA{level}{l1,l2}(:,:,l3),gadA{level}{l1,l2}(:,:,l3));
%                          featureB{level}{l1,l2}(:,:,l3)=multifeaturetype223(EdgePDFB{level}{l1,l2}(:,:,l3),energyB{level}{l1,l2}(:,:,l3),entroyB{level}{l1,l2}(:,:,l3),gadB{level}{l1,l2}(:,:,l3));
%                          A=g.*featureA{level}{l1,l2}(:,:,l3)+h.*featureA{level}{l1,l2}(:,:,l3);
%                          B=g.*featureB{level}{l1,l2}(:,:,l3)+h.*featureB{level}{l1,l2}(:,:,l3);
%                          a=(featureA{level}{l1,l2}(:,:,l3)>=featureB{level}{l1,l2}(:,:,l3));
%                          coefsF{level}{l1,l2}(:,:,l3)=e.*coefsA{level}{l1,l2}(:,:,l3)+f.*coefsB{level}{l1,l2}(:,:,l3)+(1-(e+f)).*((coefsA{level}{l1,l2}(:,:,l3)+coefsB{level}{l1,l2}(:,:,l3))./2);  
                     end
                 end
           end
     end
 end

              