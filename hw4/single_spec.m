clear; close all; clc;

%% Load Audio
num_songs = 10;
sample_rate = 44100/2;
start_pt = 10;
sec_len = 5;
num_samples = sample_rate*sec_len;
tsw = zeros(sample_rate*sec_len,num_songs);
for i = 1:num_songs
    path = ['rock/thespinwires/tsw', num2str(i), '.mp3'];
    [y,Fs] = audioread(path);
    y = y(:,1); % use only 1 channel from mp3
    sec_int = linspace(Fs*start_pt,Fs*(start_pt+sec_len),num_samples+1);
    sec_int = sec_int(1:num_samples);
    sec = y(sec_int); % crop sample
    tsw(:,i) = sec;
end

%% Plot Audio Waveform
close;
t_int = sec_int/Fs; % interval in seconds 2-7 sec
for k = 1:9
    subplot(3,3,k)
    plot(t_int',tsw(:,k))
    xlim([start_pt,start_pt+sec_len])
    title(['song #', num2str(k)])
end

%% Listen to Audio
% p8 = audioplayer(sample1-sample2,Fs); playblocking(p8);

%% Construct the Spectrogram
close;
v = sec';
n = length(v); % number of samples
L = sec_len;
ts = linspace(0,L,n+1); t = ts(1:n);
k = [0:(n-1)/2 -(n-1)/2:-1]; % use hertz instead of radians
ks = fftshift(k);
a = 50;
tslide = linspace(0,L);
vgt_spec = zeros(length(tslide),n);

for j = 1:length(tslide)
    g = exp(-a*(t-tslide(j)).^2);
    vg = v.*g;
    vgt = fft(vg);
    vgt_spec(j,:) = fftshift(abs(vgt));
end

%% Plot the Spectrogram
close;
pcolor(tslide,ks,vgt_spec.'), shading interp, colormap('hot')
ylim([0,1500]) % exclude overtones

%% Functions
% SVD and LDA
function [result,w,U,S,V,th] = band_trainer(rock_spec,classical_spec,feature)
    ns = zeros(size(specs),3);
    for i = 1:length(ns)
        spec = specs(i);
        ns(i) = length(spec(1,:));
    end
    nrock = length(rock_spec(1,:)); nclassical = length(classical_spec(1,:));
    ns = [nrock,nclassical];
    
    [U,S,V] = svd([rock_spec,classical_spec],'econ');
    
    b = S*V';
    U = U(:,1:feature);
    rock = b(1:feature,1:nrock);
    classical = b(1:feature,nrock+1:nrock+nclassical);
    
    mbands = mean(b,2);
    mrock = mean(rock,2);
    mclassical = mean(classical,2);
    
    means = [mrock,mclassical];
    bands = [
    
    Sw = 0;
    for j = 1:size(means,2)
        band = bands(j);
        for x = 1:nbands(j)
            Sw = Sw + (band(:,x)-mrock)*(rock(:,x)-mrock)';
        end
        for x = 1:nclassical
            Sw = Sw + (classical(:,x)-mclassical)*(classical(:,x)-mclassical)';
        end
    end
    
    Sb = 0;
    for j = 1:size(means,2)
        Sb = Sb + ns(j)*(means(j) - mbands)*(means(j) - mbands)';
    end
    
    size(Sw)
    size(Sb)
    
    [V2,D] = eig(Sb,Sw);
    [~,ind] = max(abs(diag(D)));
    w = V2(:,ind); w = w/norm(w,2);
    
    vrock = w'*rock; vclassical = w'*classical;
    result = [vrock,vclassical];
    
    if (mean(vrock) > mean(vclassical))
        w = -w; vrock = -vrock; vclassical = -vclassical;
    end
    
    sortrock = sort(vrock);
    sortclassical = sort(vclassical);
    
    trock = length(sortrock);
    tclassical = 1;
    
    while(trock < tclassical)
        trock = trock - 1;
        tclassical = tclassical + 1;
    end
    
    th = (sortrock(trock) + sortclassical(tclassical))/2;
end