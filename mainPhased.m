close all
clear all

[x header params actual_frames] = load_ux_signal('11-12-05.rf',1,0);
data = x;

% pro phased array
%[header, rf_data] = read_sonixRF('11-12-05.rf');
%data = rf_data;

I = data (:,:,1);       %Para pegar todas as amostras de todos os elementos de um �nico frame
H = hilbert(I);         %para obter o sinal anal�tico
Hm = abs(H);            %utiliza-se apenas a magnitude do sinal

max(Hm(:))              %valor m�ximo das amostras
min(Hm(:))              %valor minimo das amostras
Hm = log10(Hm);         %compressao dos dados em escala logaritmica
Hm = Hm - min(min(Hm)); %normalizando os dados
Hm = Hm./max(max(Hm));

%plota Figure_2
figure, imshow(Hm);
saveas(gcf, 'IA751_tripaPhased.jpg')


ang_min = -45; % graus
ang_max = 45; % graus
N_lines = 191;
depth = 0.16; % m
width = 0.16; % m
fSampling = 12e6; % Hz
Hm=Hm';

%Hm = reshape(Hm, [191, 2080]);

figure, imagesc(scanConversion(Hm,linspace(ang_min,ang_max,N_lines),[depth width],1540,1/fSampling)); 
colormap gray; % imagem modo-B
title('Out Scan Conversion');
saveas(gcf, 'IA751_modoBScanConvertedPhasedCARALHOOOOOOO.jpg')
%S1 =scanConversion([1:128; 3], 0:45/127:45, [0.15 0.15], 1540, 20e6)
%figure,imshow(S1);