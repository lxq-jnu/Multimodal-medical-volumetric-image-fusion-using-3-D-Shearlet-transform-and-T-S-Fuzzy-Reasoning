for pyrCone=1:3  %High frequency fusion 
     fprintf('方向j=%d  开始计算\n',pyrCone);
  coefsA=ShDec(pyrCone,F,BP1,level,dataClass);  %shearlet transform
  coefsB=ShDec(pyrCone,F,BP2,level,dataClass); 
   %%Construct the CHMM and return a marginal function of 3DST coefficients
    CHMMandtype2

    % compute the regional energy 
    E_coefsA = regionsum1(coefsA);  
    E_coefsB = regionsum1(coefsB);  
    %compute the fuzzy entropy
    [F_coefsA,F_coefsB]=type222(coefsA,coefsB);
    
    %normalize the features
    newE_coefsA = Mynormalized1(coefsA,E_coefsA,E_coefsB); 
    newE_coefsB = Mynormalized1(coefsB,E_coefsB,E_coefsA);
    newF_coefsA = Mynormalized1(coefsA,F_coefsA,F_coefsB);  
    newF_coefsB = Mynormalized1(coefsB,F_coefsB,F_coefsA);
    newP_coefsA = Mynormalized1(coefsA,EdgePDFA,EdgePDFB); 
    newP_coefsB = Mynormalized1(coefsB,EdgePDFB,EdgePDFA);
    %% quantization the features
    QEcoefsA = measurize1(newE_coefsA); 
    QEcoefsB = measurize1(newE_coefsB); 
    QFcoefsA = measurize1(newF_coefsA); 
    QFcoefsB = measurize1(newF_coefsB); 
    QPcoefsA = measurize1(newP_coefsA); 
    QPcoefsB = measurize1(newP_coefsB); 
% % % % %Boundary expansion
    exp_QEcoefsA = Myextend1(QEcoefsA);
    exp_QEcoefsB = Myextend1(QEcoefsB);
    exp_QFcoefsA = Myextend1(QFcoefsA);
    exp_QFcoefsB = Myextend1(QFcoefsB);
    exp_QPcoefsA = Myextend1(QPcoefsA);
    exp_QPcoefsB = Myextend1(QPcoefsB);

%% inference the comprehensive feature with fuzzy reasoning system

    [y1] = FuzzyReasoning1111(exp_QEcoefsA,exp_QFcoefsA,exp_QPcoefsA);
    [y2] = FuzzyReasoning1111(exp_QEcoefsB,exp_QFcoefsB,exp_QPcoefsB);
    coefsF=fuzzychoose(y1,y2,coefsA,coefsB);%%choose max strategy

    
    
    
    partialBP{pyrCone}=ShRec(coefsF);                     %inverse shearlet
end