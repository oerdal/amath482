close all; clear; clc;

h = webread('https://www.petakids.com/wp-content/uploads/2016/10/Brown-Hamster.jpg');

%%

[cA,cH,cV,cD] = dwt2(h,'db2');

figure(1)
subplot(2,2,1), imshow(uint8(cA));
subplot(2,2,2), imshow(uint8(cH));
subplot(2,2,3), imshow(uint8(cV));
subplot(2,2,4), imshow(uint8(cD));

%%
nbcol = size(colormap(gray),1);
cod_cA = wcodemat(cA,nbcol);
cod_cH1 = wcodemat(cH,nbcol);
cod_cV1 = wcodemat(cV,nbcol);
cod_cD = wcodemat(cD,nbcol);

cod_edge1 = cod_cH1 + cod_cV1;

figure(2)
subplot(2,1,1), imshow(uint8(cod_cA));
subplot(2,1,2), imshow(uint8(cod_edge1));