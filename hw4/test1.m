clear; close all; clc;

%% Load Audio
rate = 44100/4;
start_pt = 20;
sec_len = 5;
num_samples = rate*sec_len;
sps = 4;

% Aerosmith (Rock)
num_songs = 14;
rock = zeros(rate*sec_len,num_songs*sps);
for i = 1:num_songs
    path = ['rock/aero', num2str(2*i-1), '.mp3'];
    rock(:,i*sps-(sps-1):i*sps) = adj_music(path,sec_len,start_pt,sps,rate,num_samples);
end

% Miles Davis (Jazz)
num_songs = 10;
jazz = zeros(rate*sec_len,num_songs*sps);
for i = 1:num_songs
    path = ['jazz/miles', num2str(2*i-1), '.mp3'];
    jazz(:,i*sps-(sps-1):i*sps) = adj_music(path,sec_len,start_pt,sps,rate,num_samples);
end

% Tchami (house)
num_songs = 4;
house = zeros(rate*sec_len,num_songs*sps);
for i = 1:num_songs
    path = ['electronic/ltc', num2str(2*i), '.mp3'];
    house(:,i*sps-(sps-1):i*sps) = adj_music(path,sec_len,start_pt,sps,rate,num_samples);
end

%% Plot Audio Waveforms
% close;
% figure(1)
% Fs = 44100/4;
% sec_int = linspace(Fs*start_pt,Fs*(start_pt+sec_len),num_samples+1);
% sec_int = sec_int(1:num_samples);
% t_int = sec_int/Fs; % interval in seconds 2-7 sec
% for k = 1:9
%     subplot(3,3,k)
%     
%     plot(t_int',rock(:,k))
%     xlim([start_pt,start_pt+sec_len])
%     title(['song #', num2str(k)])
% end
% 
% figure(2)
% for k = 1:9
%     subplot(3,3,k)
%     plot(t_int',jazz(:,k))
%     xlim([start_pt,start_pt+sec_len])
%     title(['song #', num2str(k)])
% end
% 
% figure(3)
% for k = 1:9
%     subplot(3,3,k)
%     plot(t_int',house(:,k))
%     xlim([start_pt,start_pt+sec_len])
%     title(['song #', num2str(k)])
% end

%% Listen to Audio
% p8 = audioplayer(house(:,1),Fs); playblocking(p8);

%% Build Spec
rock_spec = band_spec(rock,rate);
jazz_spec = band_spec(jazz,rate);
house_spec = band_spec(house,rate);

clearvars rock jazz house

%% Training Set
feature = 15;
[r1,r2,r3,W,U,S,V,mv,eq,center] = band_trainer(rock_spec,jazz_spec,house_spec,feature);

% clearvars rock_spec jazz_spec house_spec

% Testing Set
% Aerosmith (Rock)
num_songs = 14;
rock = zeros(rate*sec_len,num_songs*sps);
for i = 1:num_songs
    path = ['rock/aero', num2str(2*i), '.mp3'];
    rock(:,i*sps-(sps-1):i*sps) = adj_music(path,sec_len,start_pt,sps,rate,num_samples);
end

% Miles Davis (Jazz)
num_songs = 10;
jazz = zeros(rate*sec_len,num_songs*sps);
for i = 1:num_songs
    path = ['jazz/miles', num2str(2*i), '.mp3'];
    jazz(:,i*sps-(sps-1):i*sps) = adj_music(path,sec_len,start_pt,sps,rate,num_samples);
end

% Tchami (house)
num_songs = 4;
house = zeros(rate*sec_len,num_songs*sps);
for i = 1:num_songs
    path = ['electronic/ltc', num2str(2*i-1), '.mp3'];
    house(:,i*sps-(sps-1):i*sps) = adj_music(path,sec_len,start_pt,sps,rate,num_samples);
end

%
test = [rock,jazz,house];
test_spec = band_spec(test,rate);
testmat = U'*test_spec;
pval = W'*testmat;
labels = [ones(1,size(rock,2)),ones(1,size(jazz,2))+1,ones(1,size(house,2))+2];

%%
for i = 1:size(testmat,2)
    song = pval(:,i);
    g = threshold(eq,center,song);
    resvec(i) = g;
end
diff = [resvec-labels];
err = [];
for d = 1:length(diff)
    if (abs(diff(d)) > 0)
        err = [err,d];
    end
end
err

%% Plot Projections
figure(4)
plot(r1(1,:),r1(2,:),'k.','MarkerSize',15)
hold on
plot(r2(1,:),r2(2,:),'r.','MarkerSize',15)
plot(r3(1,:),r3(2,:),'g.','MarkerSize',15)
% plot(mv(1,:),mv(2,:),'co','MarkerSize',50,'LineWidth',2)
plot(eq(1,:),eq(2,:),'b',eq(3,:),eq(4,:),'b',eq(5,:),eq(6,:),'b','LineWidth',2)
ax_len = max([max([r1(1,:),r2(1,:),r3(1,:),pval(1,:)]) - min([r1(1,:),r2(1,:),r3(1,:),pval(1,:)]),
    max([r1(2,:),r2(2,:),r3(2,:),pval(2,:)]) - min([r1(2,:),r2(2,:),r3(2,:),pval(2,:)])]);
xlim([center(1) - (ax_len/2*1.1), center(1) + (ax_len/2*1.1)])
ylim([center(2) - (ax_len/2*1.1), center(2) + (ax_len/2*1.1)])
plot(pval(1,err),pval(2,err),'co','MarkerSize',12,'LineWidth',2)
plot(pval(1,1:size(rock,2)),pval(2,1:size(rock,2)),'k+','MarkerSize',10,'LineWidth',2)
plot(pval(1,size(rock,2)+1:size(rock,2)+size(jazz,2)),pval(2,size(rock,2)+1:size(rock,2)+size(jazz,2)),'r+','MarkerSize',10,'LineWidth',2)
plot(pval(1,size(rock,2)+size(jazz,2)+1:size(rock,2)+size(jazz,2)+size(house,2)),pval(2,size(rock,2)+size(jazz,2)+1:size(rock,2)+size(jazz,2)+size(house,2)),'g+','MarkerSize',10,'LineWidth',2)
title('LD1 vs. LD2'),xlabel('LD1'),ylabel('LD2')
axis square
hold off

%% Functions
% Spectrogram Generation
function bandData = band_spec(bands,rate)
    [m,n] = size(bands); % samples x songs
    
    for i = 1:n
        % Construct Spectrogram
        v = bands(:,i)';
        L = m/rate;
        ts = linspace(0,L,m+1); t = ts(1:m);
        a = 10;
        tslide = linspace(0,L);
        vgt_spec = zeros(length(tslide),m);
        
        % Compute Spectrogram
        for j = 1:length(tslide)
            g = exp(-a*(t-tslide(j)).^2);
            vg = v.*g;
            vgt = fft(vg);
            vgt_spec(j,:) = abs(vgt);
        end
        
        bandData(:,i) = reshape(vgt_spec',m*length(tslide),1); % each column is a spectrogram
    end
end

% SVD and LDA
function [vb1,vb2,vb3,W,U,S,V,mv,eq,center] = band_trainer(b1_spec,b2_spec,b3_spec,feature)
    nb1 = size(b1_spec,2);
    nb2 = size(b2_spec,2);
    nb3 = size(b3_spec,2);
    nbs = [nb1,nb2,nb3];
    
    [U,S,V] = svd([b1_spec,b2_spec,b3_spec],'econ');
    
    bs = S*V';
    U = U(:,1:feature);
    b1 = bs(1:feature,1:nb1);
    b2 = bs(1:feature,nb1+1:nb1+nb2);
    b3 = bs(1:feature,nb1+nb2+1:nb1+nb2+nb3);
    
    mbs = mean(bs(1:feature,:),2);
    mb1 = mean(b1,2);
    mb2 = mean(b2,2);
    mb3 = mean(b3,2);
    means = [mb1,mb2,mb3];
    
    % Scatter Within
    Sw = 0;
    for x = 1:nb1
        Sw = Sw + (b1(:,x)-mb1)*(b1(:,x)-mb1)';
    end
    
    for x = 1:nb2
        Sw = Sw + (b2(:,x)-mb2)*(b2(:,x)-mb2)';
    end
    
    for x = 1:nb3
        Sw = Sw + (b3(:,x)-mb3)*(b3(:,x)-mb3)';
    end
    
    % Scatter Between
    Sb = 0;
    for j = 1:3
        Sb = Sb + nbs(j)*(means(:,j) - mbs)*(means(:,j) - mbs)';
    end
    
    [V2,D] = eig(Sb,Sw);
    [~,ind] = maxk(abs(diag(D)),2);
    W = V2(:,ind); W = W/norm(W,2);
    
    vb1 = W'*b1; vb2 = W'*b2; vb3 = W'*b3;
    
    % reorder proj by param order
    mv1 = [mean(vb1(1,:),2),mean(vb2(1,:),2),mean(vb3(1,:),2)];
    mv2 = [mean(vb1(2,:),2),mean(vb2(2,:),2),mean(vb3(2,:),2)];
%     [~,ind] = sort(mv1);
%     mv1 = mv1(ind);
%     mv2 = mv2(ind);
    
    mv = [mv1;mv2];
    
    center = [mean(mv1);mean(mv2)];
    m12 = [mean(mv1([1,2]));mean(mv2([1,2]))];
    m13 = [mean(mv1([1,3]));mean(mv2([1,3]))];
    m23 = [mean(mv1([2,3]));mean(mv2([2,3]))];
    v1 = m12 - center;
    v2 = m13 - center;
    v3 = m23 - center;
    m = [m12,m13,m23];
    u = [v1/norm(v1),v2/norm(v2),v3/norm(v3)];
    d = linspace(1,0.5e+05,2);
    eq = [center+u(:,1)*d;center+u(:,2)*d;center+u(:,3)*d];
end

function sample = adj_music(path,sec_len,start_pt,sps,rate,num_samples)
    sample = zeros(rate*sec_len,sps);
    [y,Fs] = audioread(path);
    for s = 1:sps
        if (size(y,2) > 1)
            y = mean(y,2); % convert to mono
        end
        sec_int = linspace(Fs*start_pt*s,Fs*(start_pt+sec_len)*s,num_samples+1);
        sec_int = sec_int(1:num_samples);
        sec = y(sec_int); % crop sample
        sample(:,s) = sec;
    end
end

function g = threshold(eq,pt,p)
    pt1 = eq([1,2],2);
    pt2 = eq([3,4],2);
    pt3 = eq([5,6],2);
    th1 = (pt(2)-pt1(2))/(pt(1)-pt1(1))*(p(1)-pt1(1))+pt1(2);
    th2 = (pt(2)-pt2(2))/(pt(1)-pt2(1))*(p(1)-pt2(1))+pt2(2);
    th3 = (pt(2)-pt3(2))/(pt(1)-pt3(1))*(p(1)-pt3(1))+pt3(2);
    g = 0;
    if (p(2) < th1) && (p(2) < th2)
        g = 1;
    end
    if (p(2) < th3) && (p(2) > th2)
        g = 3;
    end
    if (p(2) > th1) && (p(2) > th3)
        g = 2;
    end
end