close all
clear all

[x header params actual_frames] = load_ux_signal('11-12-05.rf',1,0);
data = x;

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
%%
H2=imresize(Hm, [2080/10 191]);  %ajuste do tamanho da imagem necess�rio devido a diferen�a do numero de amostras e de elementos
H3 = imadjust(H2);
%plota Figure_3
figure, imshow(H3);
saveas(gcf, 'IA751_modoB_phased.jpg')
%----------------------------------------------------------------------------------------------------------------------------
% END CODE LINEAR
%----------------------------------------------------------------------------------------------------------------------------
%%
%----------------------------------------------
% Rotina de convers�o de varredura CONVEXO
%----------------------------------------------

tic; %inicia temporizador

% Defini��o de par�metros de entrada
ne = 128; % numero de elementos
i=1:ne; % indice dos elementos
kerf = 115e-6; % kerf
d = 0.41e-3; % largura do elemento
R = 58e-3; % raio do transdutor
N = 4680; % numero de amostras
n = 1:N; % indice das amostras
c = 1540; % velocidade do som no tecido mole
fs = 20e6; % frequ�ncia de amostragem
t = (n/fs)'; % escala de tempo

%----------------------------------
% �ngulo de abertura do transdutor convexo
%----------------------------------
c_transdutor = 2*pi*R;
c_abertura = (ne-1)*(kerf + d);
theta_convexo = 360*c_abertura/c_transdutor;

%----------------------------------
% �ngulo de abertura do transdutor convexo
% de cada elemento
%----------------------------------

theta_convexo_i = (i-(ne+1)/2)*theta_convexo/(ne-1);

%----------------------------------
% Escala de profundidade
%----------------------------------
z = c*t/2+R;

%----------------------------------
% Buffer de dados para simula��o
%----------------------------------
%valor_final_Env_Log = (rand(N,ne)-2)*25;

%----------------------------------
% Dados das inclus�es para teste
%----------------------------------
%a = 200; b = 10;

%----------------------------------
% Equa��o das inclus�es
%----------------------------------
% valor_final_Env_Log ((N/4)-a:(N/4)+a,ne/4-b:ne/4+b)= 0;
% valor_final_Env_Log ((N/4)-a:(N/4)+a,ne/2-b:ne/2+b)= 0;
% valor_final_Env_Log ((N/4)-a:(N/4)+a,ne*3/4-b:ne*3/4+b)= 0;
% 
% valor_final_Env_Log ((N/2)-a:(N/2)+a,ne/4-b:ne/4+b)= -25;
% valor_final_Env_Log ((N/2)-a:(N/2)+a,ne/2-b:ne/2+b)= -25;
% valor_final_Env_Log ((N/2)-a:(N/2)+a,ne*3/4-b:ne*3/4+b)= -25;
% 
% valor_final_Env_Log ((N*3/4)-a:(N*3/4)+a,ne/4-b:ne/4+b)= -50;
% valor_final_Env_Log ((N*3/4)-a:(N*3/4)+a,ne/2-b:ne/2+b)= -50;
% valor_final_Env_Log ((N*3/4)-a:(N*3/4)+a,ne*3/4-b:ne*3/4+b)= -50;

[THETA,RHO] = meshgrid(degtorad(theta_convexo_i),z);

[xc,yc] = pol2cart(THETA,RHO);
%----------------------------------
% Imagem simulada antes da convers�o de varredura
%----------------------------------

figure;
colormap(gray);
imagesc(theta_convexo_i,(z-R),H3);

xlabel('\theta_c_o_n_v_e_x_o [\circ]');
ylabel('Profundidade z[mm]');
axis tight; colorbar;

%----------------------------------
% Imagem simulada ap�s a convers�o de varredura
%----------------------------------
figure; 
colormap(gray);
h=surf((xc-R)*1e3,(yc)*1e3,Hm,'edgecolor','none');

view(90,90);
xlabel('Profundidade z[mm]');
ylabel('Eixo x[mm]');
axis image;
saveas(gcf, 'IA751_modoBScanConverted.jpg')
toc
% finaliza temporizador
%----------------------------------------------
%----------------------------------------------------------------------------------------------------------------------------
% END CODE CONVEXO
%----------------------------------------------------------------------------------------------------------------------------
%%

