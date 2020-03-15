clear; close all; clc;

%% Load Video
load('cam1_2.mat')
load('cam2_2.mat')
load('cam3_2.mat')

%% Play Video
implay(vidFrames3_2)

%% 1_1
figure(1)
vid = vidFrames1_2;
numFrames = size(vid,4);

x1_2 = zeros(1,numFrames);
y1_2 = zeros(1,numFrames);
for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,460:640,:) = 0;
    
    [~,x1_2(j)] = max(mean(max(V,[],1),3));
    [~,y1_2(j)] = max(mean(max(V,[],2),3));
%     imshow(V);
end

plot(x1_2,y1_2,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% 2_1
figure(2)
vid = vidFrames2_2;
numFrames = size(vid,4);

x2_2 = zeros(1,numFrames);
y2_2 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:80,:,:) = 0;
    V(400:480,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,380:640,:) = 0;
    
    [~,x2_2(j)] = max(sum(max(V,[],1),3));
    [~,y2_2(j)] = max(sum(max(V,[],2),3));
%     imshow(V);
end

plot(x2_2,y2_2,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% 3_1
figure(3)
vid = vidFrames3_2;
numFrames = size(vid,4);

x3_2 = zeros(1,numFrames);
y3_2 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(380:480,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,540:640,:) = 0;
    
    [~,x3_2(j)] = max(sum(max(V,[],1),3));
    [~,y3_2(j)] = max(sum(max(V,[],2),3));
%     imshow(V);
end

plot(x3_2,y3_2,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% Adjust video lengths
len = length(x1_2); % shortest vid

x2_2 = x2_2(20:len+20-1);
y2_2 = y2_2(20:len+20-1);
x3_2 = x3_2(1:len);
y3_2 = y3_2(1:len);

%%
close;
subplot(3,1,1)
plot(1:len,y1_2)
xlim([0 len])
subplot(3,1,2)
plot(1:len,y2_2)
xlim([0 len])
subplot(3,1,3)
plot(1:len,y3_2)
xlim([0 len])

%% PCA
X = [x1_2;y1_2;x2_2;y2_2;x3_2;y3_2];
[m,n] = size(X);
mn = mean(X,2);
X = X - repmat(mn,1,n);

[U,S,V] = svd(X,'econ');
sig = diag(S);
lambda = diag(S).^2;
energy = sig.^2/sum(sig.^2);
rank_1 = U(:,1)*S(1,1)*V(:,1)';
rank_3 = U(:,1:3)*S(1:3,1:3)*V(:,1:3)';

% 90.74 of energy in first 3 modes

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
