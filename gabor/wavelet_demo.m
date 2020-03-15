close;
figure(2)
subplot(2,2,1)
[phi_haar,psi_haar,xval_haar] = wavefun('haar',10);
plot(xval_haar,psi_haar,'LineWidth',2); title('Haar Wavelet');
subplot(2,2,2)
[phi_db,psi_db,xval_db] = wavefun('db4',10);
plot(xval_db,psi_db,'LineWidth',2); title('Daubechies Wavelet'); xlim([0,7]);
subplot(2,2,3)
[psi_morl,xval_morl] = wavefun('morl',10);
plot(xval_morl,psi_morl,'LineWidth',2); title('Morlet Wavelet'); xlim([-7,7]);
subplot(2,2,4)
[psi_mexh,xval_mexh] = wavefun('mexh',10);
plot(xval_mexh,psi_mexh,'LineWidth',2); title('Mexican Hat Wavelet'); xlim([-7,7]);
print -depsc wavelet_demo.eps