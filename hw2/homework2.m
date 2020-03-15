clear; close all; clc;

%% Piano
close;
[y,Fs] = audioread('music1.wav');
tr_piano=length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Mary had a little lamb (piano)');
%%
p8 = audioplayer(y,Fs); playblocking(p8);

%% Recorder
figure(2)
[y,Fs] = audioread('music2.wav');
tr_rec=length(y)/Fs; % record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Mary had a little lamb (recorder)');
p8 = audioplayer(y,Fs); playblocking(p8);

%% Sliding Gaussian
close;
v = y';
n = length(v);
L = tr_piano;
ts = linspace(0,L,n+1); t = ts(1:n);
tslide = linspace(0,L);
a = 50;
subplot(3,1,1)
plot((1:length(y))/Fs,y);
for j = 1:length(tslide)
    g = exp(-a*(t-tslide(j)).^2);
    subplot(3,1,2)
    plot(g)
    
    vg = v.*g;
    subplot(3,1,3)
    plot(vg)
    ylim([-1,1])
    pause(0.02);
end

%% Construct the Spectrogram
v = y';
n = length(v);
L = tr_piano; % switch to 'L = tr_rec' for recorder
ts = linspace(0,L,n+1); t = ts(1:n);
k = (1/L)*[0:(n/2-1) -n/2:-1]; % use hertz instead of radians
ks = fftshift(k);
a = 5;
tslide = linspace(0,L);
vgt_spec = zeros(length(tslide),n);

%%

for j = 1:length(tslide)
    g = exp(-a*(t-tslide(j)).^2);
    vg = v.*g;
    vgt = fft(vg);
    vgt_spec(j,:) = fftshift(abs(vgt));
end

%% Plot the Recorder Spectrogram
figure(3)
pcolor(tslide,ks,vgt_spec.'), shading interp
title(['a = ', num2str(a)],'FontSize',16)
ylim([240,340])
xlabel('Time [s]'), ylabel('Frequency [Hz]')
colormap('hot')
% print -depsc mary_spec_rec_overtones.eps

%% Plot the Recorder Spectrogram (without overtones)
figure(4)
pcolor(tslide,ks,vgt_spec.'), shading interp
title(['a = ', num2str(a)],'FontSize',16)
ylim([700,1100])
xlabel('Time [s]'), ylabel('Frequency [Hz]')
colormap('hot')
print -depsc mary_spec_rec.eps