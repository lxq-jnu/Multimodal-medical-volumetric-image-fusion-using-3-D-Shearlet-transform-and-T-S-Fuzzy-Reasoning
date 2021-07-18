function coefsF=fuzzymethod(entroyA,entroyB,EdgePDFA,EdgePDFB,coefsA,coefsB)


                    [muA1,muA2]=rules4(entroyA,EdgePDFA);
                    [muB1,muB2]=rules4(entroyB,EdgePDFB);
                    muA12=min(muA1,muA2);
                    muB12=min(muB1,muB2);
                    coefsF=(coefsA.*muA12+coefsB.*muB12)./(muA12+muB12);
                    
                        
                         
       