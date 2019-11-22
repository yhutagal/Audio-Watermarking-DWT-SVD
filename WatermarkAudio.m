clear;
clc;

%% Step 1: Audio Input

[A,fs] = audioread ('host.wav');

%% Step 2 : DWT Level 1 with wavelet db 3

[Aa,Ad] = dwt(A,'db3');

% AI = idwt (Aa,Ad,'db3');

%% Step 3 : svd decomposition Ad
% Preparation before SVD process until become square matrix
lt = length (Ad);
d = sqrt (lt);
d = round(d);
Ad = Ad(1:d^2);
Aa = Aa(1:d^2);

% Reshape matrix Ad until become square matrix 
Adr = reshape(Ad,d,d);

[U_Ad,S_Ad,V_Ad] = svd (Adr);



%% -------------------------------%%
%% Step 1a;watermark Audio file

[W,fs] = audioread ('watermark.wav');

%Equality dimention W and A
la = length (A);
lw = length (W);

tmbah0 = zeros((la-lw),1);
W = [W ; tmbah0];

%% Step 2 a:  DWT Level 1 with wavelet db 3

[Wa,Wd] = dwt(W,'db3');

% AI = idwt (Aa,Ad,'db3');

%% svd decomposition Ad
% Preparation before SVD process
lt = length (Wd);
d = sqrt (lt);
d = round(d);
Wd = Wd(1:d^2);
Wa = Wa(1:d^2);

% Reshape matrix Ad until become square matrix
Wdr = reshape(Wd,d,d);

[U_Wd,S_Wd,V_Wd] = svd (Wdr);



%% Watermarking process

S_AW = S_Ad + (0.01*S_Wd);

AW = U_Ad * S_AW * V_Ad';

AWR = reshape (AW,(d*d),1);

%% invers IDWT to get output file

AWout = idwt (Aa,AWR,'db3');

audiowrite( 'AudioWatermarked.wav',AWout,fs);


%% ----------------------------------------------%%

%% Audio watermark extract process

[AWO,fs] = audioread ('AudioWatermarked.wav');

%% DWT Level 1 with wavelet db 3

[AWOa,AWOd] = dwt(AWO,'db3');

% AI = idwt (Aa,Ad,'db3');

%% svd decomposition Ad
% Preparation before SVD process
lt = length (AWOd);
d = sqrt (lt);
d = round(d);
AWOd = AWOd(1:d^2);
AWOa = AWOa(1:d^2);

%% Reshape matrix Ad until become square matrix
AWOdr = reshape(AWOd,d,d);
%% SVD
[U_AWOd,S_AWOd,V_AWOd] = svd (AWOdr);

%% ekxtract
S_Wd1 = (S_AWOd - S_Ad)/0.01;

Wd1 = U_Wd * S_Wd1 * V_Wd'; 
%% reshape
Wd1R = reshape (Wd1,d^2,1);

%% IDWT process

W1out =  idwt (Wa,Wd1R,'db3');
audiowrite( 'extractedWatermarked.wav',W1out,fs);




