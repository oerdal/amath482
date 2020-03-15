clear; close all; clc;

L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

U=X.^2+Y.^2+Z.^2;

isosurface(X,Y,Z,U,3)

%%
close all;

Ut=fftn(U);
ave=zeros(n,n,n);

for i=1:10
    Utn=Ut+10*(randn(1,n)+1i*randn(1,n));
    ave=ave+Utn;
end

ave=abs(ave)/i;

isosurface(Kx,Ky,Kz,abs(fftshift(Utn)))

pause(2)
close all;

isosurface(Kx,Ky,Kz,abs(fftshift(ave)))

Ud=ifftn(ave);

%%
close all;
isosurface(X,Y,Z,abs(Ud),1)