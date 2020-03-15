clear; close all; clc;

%% Load Video
load('cam1_3.mat')
load('cam2_3.mat')
load('cam3_3.mat')

%% Play Video
implay(vidFrames1_3)

%% 1_1
figure(1)
vid = vidFrames1_3;
numFrames = size(vid,4);

x1_3 = zeros(1,numFrames);
y1_3 = zeros(1,numFrames);
for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,460:640,:) = 0;
    
    [~,x1_3(j)] = max(mean(max(V,[],1),3));
    [~,y1_3(j)] = max(mean(max(V,[],2),3));
%     imshow(V);
end

plot(x1_3,y1_3,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% 2_1
figure(2)
vid = vidFrames2_3;
numFrames = size(vid,4);

x2_3 = zeros(1,numFrames);
y2_3 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:160,:,:) = 0;
    V(400:480,:,:) = 0;
    V(:,1:220,:) = 0;
    V(:,360:640,:) = 0;
    
    [~,x2_3(j)] = max(sum(max(V,[],1),3));
    [~,y2_3(j)] = max(sum(max(V,[],2),3));
%     imshow(V);
end

plot(x2_3,y2_3,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% 3_1
figure(3)
vid = vidFrames3_3;
numFrames = size(vid,4);

x3_3 = zeros(1,numFrames);
y3_3 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(340:480,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,540:640,:) = 0;
    
    [~,x3_3(j)] = max(sum(max(V,[],1),3));
    [~,y3_3(j)] = max(sum(max(V,[],2),3));
%     imshow(V);
end

plot(x3_3,y3_3,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% Adjust video lengths
min_len = min([length(x1_3) length(x2_3) length(x3_3)]);
len = length(x1_3); % first vid

%%
x1_3 = x1_3(len-min_len+1:len);
y1_3 = y1_3(len-min_len+1:len);
x2_3 = x2_3(35:min_len+35-1);
y2_3 = y2_3(35:min_len+35-1);
x3_3 = x3_3(1:min_len);
y3_3 = y3_3(1:min_len);

%%
close;
len = min_len;
subplot(3,1,1)
plot(1:len,y1_3)
xlim([0 len])
subplot(3,1,2)
plot(1:len,y2_3)
xlim([0 len])
subplot(3,1,3)
plot(1:len,y3_3)
xlim([0 len])

%% PCA
X = [x1_3;y1_3;x2_3;y2_3;x3_3;y3_3];
[m,n] = size(X);
mn = mean(X,2);
X = X - repmat(mn,1,n);

[U,S,V] = svd(X,'econ');
sig = diag(S);
lambda = diag(S).^2;
energy = sig.^2/sum(sig.^2);
rank_1 = U(:,1)*S(1,1)*V(:,1)';

% 93.42 of energy in first 3 modes

Y = U'*X;

close
subplot(1,2,1)
waterfall(X)
title('Displacements by Measurement')
xlabel('Time [frames]'), ylabel('Measurement [probe #]'), zlabel('Displacement [pixels]')
subplot(1,2,2)
waterfall(Y)
title('Principal Component Projections')
xlabel('Time [frames]'), ylabel('Principal Component [Component #]'), zlabel('Displacement [pixels]')
