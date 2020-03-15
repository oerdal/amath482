clear; close all; clc;

%% Load Video
load('cam1_4.mat')
load('cam2_4.mat')
load('cam3_4.mat')

%% Play Video
implay(vidFrames3_4)

%% 1_1
vid = vidFrames1_4;
numFrames = size(vid,4)/2;

x1_4 = zeros(1,numFrames);
y1_4 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(:,1:280,:) = 0;
    V(:,480:640,:) = 0;
%     V(1:y_mask_start(j),:,:) = 0;
%     V(y_mask_end(j):480,:,:) = 0;
%     V(:,1:x_mask_start(j),:) = 0;
%     V(:,x_mask_end(j):640,:) = 0;
    
    [~,x1_4(j)] = max(mean(max(V,[],1),3));
    [~,y1_4(j)] = max(mean(max(V,[],2),3));
%     imshow(V);
end

%%

x_mask_start = x1_4 - 50;
x_mask_end = x1_4 + 50;
y_mask_start = y1_4 - 50;
y_mask_end = y1_4 + 50;

plot(x1_4,y1_4,'.'); axis([0,640,0,480]); set(gca, 'YDir','reverse')

%% 2_1
figure(2)
vid = vidFrames2_4;
numFrames = size(vid,4);

x2_4 = zeros(1,numFrames);
y2_4 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:100,:,:) = 0;
    V(350:480,:,:) = 0;
    V(:,1:200,:) = 0;
    V(:,400:640,:) = 0;
    
    [~,x2_4(j)] = max(sum(max(V,[],1),3));
    [~,y2_4(j)] = max(sum(max(V,[],2),3));
%     imshow(V);
end

plot(x2_4,y2_4,'.'); axis([0,640,0,480]); set(gca, 'YDir','reverse')

%% 3_1
figure(3)
vid = vidFrames3_4;
numFrames = size(vid,4);

x3_4 = zeros(1,numFrames);
y3_4 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:150,:,:) = 0;
    V(340:480,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,540:640,:) = 0;
    
    [~,x3_4(j)] = max(sum(max(V,[],1),3));
    [~,y3_4(j)] = max(sum(max(V,[],2),3));
%     imshow(V);
end

plot(x3_4,y3_4,'.'); axis([0,640,0,480]); set(gca, 'YDir','reverse')

%% Adjust video lengths
len = length(x1_4); % first vid

%%
x1_4 = x1_4(1:len);
y1_4 = y1_4(1:len);
x2_4 = x2_4(35:len+35-1);
y2_4 = y2_4(35:len+35-1);
x3_4 = x3_4(1:len);
y3_4 = y3_4(1:len);

%%
close;
subplot(3,1,1)
plot(1:len,y1_4)
xlim([0 len])
subplot(3,1,2)
plot(1:len,y2_4)
xlim([0 len])
subplot(3,1,3)
plot(1:len,y3_4)
xlim([0 len])

%% PCA
X = [x1_4;y1_4;x2_4;y2_4;x3_4;y3_4];
[m,n] = size(X);
mn = mean(X,2);
X = X - repmat(mn,1,n);

[U,S,V] = svd(X,'econ');
sig = diag(S);
lambda = diag(S).^2;
energy = sig.^2/sum(sig.^2);
rank_1 = U(:,1)*S(1,1)*V(:,1)';

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
