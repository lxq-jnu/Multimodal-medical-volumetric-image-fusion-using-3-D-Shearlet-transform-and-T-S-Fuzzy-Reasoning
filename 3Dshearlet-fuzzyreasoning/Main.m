

clc;clear all;

display('Multimodal medical volumetric image fusion using 3-D shearlet transform and T-S Fuzzy Reasoning');

% % read source images

[X1,map1]=imread("/test_images/GAD1.gif");
I1=ind2gray(X1,map1);
I1=imresize(I1,[192 192]);
[X2,map2]=imread("/test_images/GAD2.gif");
I2=ind2gray(X2,map2);
I2=imresize(I2,[192 192]);
[X3,map3]=imread("/test_images/GAD3.gif");
I3=ind2gray(X3,map3);
I3=imresize(I3,[192 192]);
[X4,map4]=imread("/test_images/GAD4.gif");
I4=ind2gray(X4,map4);
I4=imresize(I4,[192 192]);
[X5,map5]=imread("/test_images/GAD5.gif");
I5=ind2gray(X5,map5);
I5=imresize(I5,[192 192]);
[X6,map6]=imread("/test_images/GAD6.gif");
I6=ind2gray(X6,map6);
I6=imresize(I6,[192 192]);
[X7,map7]=imread("/test_images/GAD7.gif");
I7=ind2gray(X7,map7);
I7=imresize(I7,[192 192]);
[X8,map8]=imread("/test_images/GAD8.gif");
I8=ind2gray(X8,map8);
I8=imresize(I8,[192 192]);
[X9,map9]=imread("/test_images/GAD9.gif");
I9=ind2gray(X9,map9);
I9=imresize(I9,[192 192]);
[X10,map10]=imread("/test_images/GAD10.gif");
I10=ind2gray(X10,map10);
I10=imresize(I10,[192 192]);
[X11,map11]=imread("/test_images/GAD11.gif");
I11=ind2gray(X11,map11);
I11=imresize(I11,[192 192]);
[X12,map12]=imread("/test_images/GAD12.gif");
I12=ind2gray(X12,map12);
I12=imresize(I12,[192 192]);


[X17,map17]=imread("/test_images/t2-1.gif");
I17=ind2gray(X17,map17);
I17=imresize(I17,[192 192]);
[X18,map18]=imread("/test_images/t2-2.gif");
I18=ind2gray(X18,map18);
I18=imresize(I18,[192 192]);
[X19,map19]=imread("/test_images/t2-3.gif");
I19=ind2gray(X19,map19); 
I19=imresize(I19,[192 192]);
[X20,map20]=imread("/test_images/t2-4.gif");
I20=ind2gray(X20,map20);
I20=imresize(I20,[192 192]);
[X21,map21]=imread("/test_images/t2-5.gif");
I21=ind2gray(X21,map21);
I21=imresize(I21,[192 192]);
[X22,map22]=imread("/test_images/t2-6.gif");
I22=ind2gray(X22,map22);
I22=imresize(I22,[192 192]);
[X23,map23]=imread("/test_images/t2-7.gif");
I23=ind2gray(X23,map23); 
I23=imresize(I23,[192 192]);
[X24,map24]=imread("/test_images/t2-8.gif");
I24=ind2gray(X24,map24);
I24=imresize(I24,[192 192]);
[X25,map25]=imread("/test_images/t2-9.gif");
I25=ind2gray(X25,map25);
I25=imresize(I25,[192 192]);
[X26,map26]=imread("/test_images/t2-10.gif");
I26=ind2gray(X26,map26);
I26=imresize(I26,[192 192]);
[X27,map27]=imread("/test_images/t2-11.gif");
I27=ind2gray(X27,map27); 
I27=imresize(I27,[192 192]);
[X28,map28]=imread("/test_images/t2-12.gif");
I28=ind2gray(X28,map28); 
I28=imresize(I28,[192 192]);





%merge mutilple images into 3D volumetric images
A(:,:,1)=I1;
A(:,:,2)=I2;
A(:,:,3)=I3;
A(:,:,4)=I4;
A(:,:,5)=I5;
A(:,:,6)=I6;
A(:,:,7)=I7;
A(:,:,8)=I8;
A(:,:,9)=I9;
A(:,:,10)=I10;
A(:,:,11)=I11;
A(:,:,12)=I12;



B(:,:,1)=I17;
B(:,:,2)=I18;
B(:,:,3)=I19;
B(:,:,4)=I20;
B(:,:,5)=I21;
B(:,:,6)=I22;
B(:,:,7)=I23;
B(:,:,8)=I24;
B(:,:,9)=I25;
B(:,:,10)=I26;
B(:,:,11)=I27;
B(:,:,12)=I28;
dBand={{[ 2  2]}, ... %%%%for level =1
        {[2 2],[2 2 ]}, ...  %%%% for level =2
        {[2 2 ], [2 2],[2 2]}, ...   %%%% for level =3
        {[8 8],[8 8],[4 4],[4 4]}}; %%%%% for level =4
options = optimset('display', 'off', 'TolX', 1e-6, 'MaxIter', 10);   
filterSize=[24 24 24 24];
dataClass='double';
filterType='meyer';%%only meyer type implemented
filterDilationType='422';%%only two type '422' or '442'. currently only 422 supported
level=3;


F=GetFilter(filterType,level,dBand,filterSize,filterDilationType ,'double');    
BP1=DoPyrDec(A,level); %end pyramid transform
BP2=DoPyrDec(B,level); %end 


partialBP=cell(size(BP1));
recBP=cell(size(BP1));
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
clear F;
clear coefsF;
for l=1:level      
  recBP{l}=zeros(size(partialBP{1}{l}),dataClass);
  for pyrCone =1:3
   recBP{l}=recBP{l}+ partialBP{pyrCone}{l};
  end
end

% % low frequency fusion
[x,y,z]=size(BP1{level+1});
for l3=1:12
    BPF(:,:,l3)=lowfusionrulesenergy(double(A(:,:,l3)),double(B(:,:,l3)));
end
for l3=1:z   
     Q=DoPyrDec(BPF,level);
     recBP{level+1}(:,:,l3)=(Q{level+1}(:,:,l3));
end
%toc;

%Reconstruction
F=DoPyrRec(recBP);





F1=F(:,:,1);
F2=F(:,:,2);
F3=F(:,:,3);
F4=F(:,:,4);
F5=F(:,:,5);
F6=F(:,:,6);
F7=F(:,:,7);
F8=F(:,:,8);
F9=F(:,:,9);
F10=F(:,:,10);
F11=F(:,:,11);
F12=F(:,:,12);




imgF1 = uint8(F1);
imgF2 = uint8(F2);
imgF3 = uint8(F3);
imgF4 = uint8(F4);
imgF5 = uint8(F5);
imgF6 = uint8(F6);
imgF7 = uint8(F7);
imgF8 = uint8(F8);
imgF9 = uint8(F9);
imgF10 = uint8(F10);
imgF11 = uint8(F11);
imgF12 = uint8(F12);





%%
display('           ');
disp('Showing the Original Images--');
figure('Name','the Original Image A'),
pic1=cat(2,I1,I2,I3,I4,I5);
imshow(pic1);

figure('Name','the Original Image B'),
pic2=cat(2,I17,I18,I19,I20,I21);
imshow(pic2);

%%
disp('Showing the Fused Images--');
figure('Name','the fused Image F'),
pic3=cat(2,imgF1,imgF2,imgF3,imgF4,imgF5);
imshow(pic3);









