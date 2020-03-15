clear; close all; clc;

%% Starter Code
load handel
v = y';
plot((1:length(v))/Fs,v);
xlabel('Time [sec]');
ylabel('Amplitude');
title('Signal of Interest, v(n)');

%%
p8 = audioplayer(v,Fs);
playblocking(p8);

%%
close;
L = Fs;
n = length(v);
tr = n/L;
ts = linspace(0,L,n+1); t = ts(1:n);
k = (1/tr)*[0:(n-1)/2 -(n-1)/2:-1];
ks = fftshift(k);

%%
a1 = 0.5;
a2 = 2;
g1 = exp(-a1*(t-tau).^2);
g2 = exp(-a2*(t-tau).^2);

vg1 = v.*g1;
vg2 = v.*g2;
vg1t = fft(vg1);
vg2t = fft(vg2);

subplot(3,2,1)
plot(t,v,'LineWidth',2)
set(gca,'Fontsize',16), xlabel('Time [sec]'), ylabel('Amplitude')
subplot(3,2,3)
plot(t,vg1,'LineWidth',2)
set(gca,'Fontsize',16), xlabel('Time [sec]'), ylabel('Amplitude')
subplot(3,2,5)
plot(ks,abs(fftshift(vg1t)),'LineWidth',2)
set(gca,'Fontsize',16), xlabel('Frequency (k)'), ylabel('|fft(vg)|')
subplot(3,2,2)
plot(t,v,'LineWidth',2)
set(gca,'Fontsize',16), xlabel('Time [sec]'), ylabel('Amplitude')
subplot(3,2,4)
plot(t,vg2,'LineWidth',2)
set(gca,'Fontsize',16), xlabel('Time [sec]'), ylabel('Amplitude')
subplot(3,2,6)
plot(ks,abs(fftshift(vg2t)),'LineWidth',2)
set(gca,'Fontsize',16), xlabel('Frequency (k)'), ylabel('|fft(vg)|')
print -depsc gaussian_ex.eps

%%
close;
tslide = linspace(0,tr);
vgt_spec = zeros(length(tslide),n);
%%

widths = [0.1 0.5 1 5];
figure(3)
for w = 1:length(widths)
    for j = 1:length(tslide)
        g = exp(-(widths(w))*(t-tslide(j)).^2);
        vg = v.*g;
        vgt = fft(vg);
        vgt_spec(j,:) = fftshift(abs(vgt));
    end
    subplot(2,2,w)
    pcolor(tslide,ks,vgt_spec.'), shading interp
    title(['a = ', num2str(widths(w))],'FontSize',16)
    ylim([0,4000])
    xlabel('Time [sec]'), ylabel('Frequency [Hz]')
    colormap('hot')
end
print -depsc spectrogram_demo_100.eps

%% Plot the Spectrogram
close;
pcolor(tslide,ks,vgt_spec'), shading interp
title(['a = ', num2str(a)],'FontSize',16)
xlabel('Filter Center (\tau)'), ylabel('Frequency (k)')
colormap('hot')
