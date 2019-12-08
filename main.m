clear all
close all


% processo para uma linha
[x header params actual_frames] = load_ux_signal('11-11-34.rf',1,0);

data = x;	% num de amostras, num de elementos, frame


% Processamento para todas as linhas

I = data (:,:,1);       % Todas as amostras de todos os elementos de um unico frame

H = hilbert(I);         % Sinal analatico
Hm = abs(H);            % Magnitude do sinal

max(Hm(:))              %valor maximo das amostras
min(Hm(:))              %valor minimo das amostras

Hm = log10(Hm);         % Compressao dos dados em escala logaritmica

Hm = Hm - min(min(Hm)); % Normalizando os dados
Hm = Hm./max(max(Hm));


figure(2), imshow(Hm);    
saveas(gcf, 'IA751_recLinear.jpg');

 % Ajuste do tamanho da imagem necessario devido a diferenca do numero de amostras e de elementos
%H2 = imresize(Hm, [2672/8 256]);  
H2 = imresize(Hm, [2672/8 500]);
figure(3), imshow(imadjust(H2));

% Mascara para aumentar contraste
mask = imadjust(H2)>.5; 
figure, imshow(H2.*mask);

% Filtro de media para tornar a imagem mais homogenea
filt=fspecial('average', [1,1]);    
j = imfilter(H2,filt);
figure, imshow(j);

