clear; close all; clc;

%% Starter Code
load Testdata

L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

for j=1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    close all, isosurface(X,Y,Z,abs(Un),0.4)
    axis([-20 20 -20 20 -20 20]), grid on, drawnow
    pause(1)
end

%% Figure 1
close all

figure
isosurface(X,Y,Z,abs(Un),0.4)
title('Noisy Ultrasound Data')
xlabel('position (x)')
ylabel('position (y)')
zlabel('position (z)')
gca.FontSize = 14;
view(-45,15)
axis([-20 20 -20 20 -20 20]), grid on, drawnow
print -depsc original_data.eps

%% Part 1: Determine the Frequency Signature
close all
s=20;
Utnave=zeros(n,n,n);
for j=1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Utn=fftn(Un);
    Utnave=Utnave+Utn;
end
Utnave=fftshift(Utnave)/s;

%% Figure 2
close all

figure
isosurface(Kx,Ky,Kz,abs(fftshift(Utnave)),max(abs(Utnave(:)))-50)
title('FFT vs. spatial frequency')
xlabel('wave number (kx)')
ylabel('wave number (ky)')
zlabel('wave number (kz)')
gca.FontSize = 14;
view(-45,15)
axis([min(Kx(:)) max(Kx(:)) min(Ky(:)) max(Ky(:)) min(Kz(:)) max(Kz(:))]), grid on, drawnow
% print -depsc frequency_signature.eps

%% Part 2: Filter the Data
close all;

kx=-4.817;ky=5.655;kz=-6.611;
tau=0.5;

filter1d=exp(-tau*(k-kx).^2); % Define the filter
filter=((tau/2/pi)^(3/2))*exp(-tau*(((Kx-kx).^2)+((Ky-ky).^2)+((Kz-kz).^2))/2); % Define the filter

for j=1:s
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Utn=fftn(Un);
    Utnf=filter.*Utn; % Apply the filter to the signal in frequency space
    Unf=ifftn(Utnf);
    close all
    isosurface(X,Y,Z,abs(Unf),0.9*max(abs(Unf(:))))
    axis([-20 20 -20 20 -20 20]), grid on, drawnow
    pause(0.5)
end

%% Figure 3
close all

figure
isosurface(X,Y,Z,abs(Unf),0.9*max(abs(Unf(:))))
title('Denoised Ultrasound Data')
xlabel('position (x)')
ylabel('position (y)')
zlabel('position (z)')
gca.FontSize = 14;
view(-45,15)
axis([-20 20 -20 20 -20 20]), grid on, drawnow
print -depsc marble_location.eps

%% Part 3: Plot the Trajectory
close all

x_traj=[4.688 8.438 10.31 9.042 6.094 1.333 -3.315 -7.6 -9.844 -7.5 -2.612 2.344 6.562 9.375 9.844 7.969 4.219 -0.9375 -5.625];
y_traj=[-4.29 -2.857 -0.435 2.124 4.131 4.936 4.467 2.932 0.883 -3.502 -4.804 -4.66 -3.683 -1.942 0.669 2.923 3.957 4.413 4.1375];
z_traj=[10.31 9.844 9.375 9.375 8.906 8.906 8.438 7.5 7.031 5.178 4.219 3.75 2.344 1.406 0 -1.406 -3.281 -4.219 -6.094];


%% Figure 4
figure
plot3(x_traj,y_traj,z_traj,'b.', 'MarkerSize', 20)
title('Trajectory of Marble in 3-D')
xlabel('position (x)')
ylabel('position (y)')
zlabel('position (z)')
gca.FontSize = 14;
view(-45,15)
axis([-20 20 -20 20 -20 20]), grid on, drawnow
print -depsc marble_trajectory.eps