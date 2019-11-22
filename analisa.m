%% hitung mse anatara audio asli dengan watermarked audio
load('data.mat')

% audio asli A, AWout : watermarked audio
lt = length (AWout);
Aori = A(1:lt);

MSE = immse(Aori,AWout);

% hitung psnr

PSNR = psnr (AWout,Aori);

MSE
PSNR

