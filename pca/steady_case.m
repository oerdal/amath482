clear; close all; clc;

%% Load Video
load('cam1_1.mat')
load('cam2_1.mat')
load('cam3_1.mat')

%% Play Video
implay(vidFrames1_1)

%% 1_1
figure(1)
vid = vidFrames1_1;
numFrames = size(vid,4);

x1_1 = zeros(1,numFrames);
y1_1 = zeros(1,numFrames);

for j = 1:1
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,460:640,:) = 0;
    
    [~,x1_1(j)] = max(mean(max(V,[],1),3));
    [~,y1_1(j)] = max(mean(max(V,[],2),3));
    c1 = imshow(V);
end

% plot(x1_1,y1_1,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% 2_1
figure(2)
vid = vidFrames2_1;
numFrames = size(vid,4);

x2_1 = zeros(1,numFrames);
y2_1 = zeros(1,numFrames);

for j = 1:1
    V = vid(:,:,:,j);
    V(1:80,:,:) = 0;
    V(400:480,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,380:640,:) = 0;
    
    [~,x2_1(j)] = max(sum(max(V,[],1),3));
    [~,y2_1(j)] = max(sum(max(V,[],2),3));
    c2 = imshow(V);
end

% plot(x2_1,y2_1,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% 3_1
figure(3)
vid = vidFrames3_1;
numFrames = size(vid,4);

x3_1 = zeros(1,numFrames);
y3_1 = zeros(1,numFrames);

for j = 1:1
    V = vid(:,:,:,j);
    V(1:200,:,:) = 0;
    V(400:480,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,540:640,:) = 0;
    
    [~,x3_1(j)] = max(sum(max(V,[],1),3));
    [~,y3_1(j)] = max(sum(max(V,[],2),3));
    c3 = imshow(V);
end

% plot(x3_1,y3_1,'.'); axis([0,480,0,640]); set(gca, 'YDir','reverse')

%% Images
c1 = get(c1,'CData');
c2 = get(c2,'CData');
c3 = get(c3,'CData');
%%
montage(cat(4,c1,c2,c3),'size',[1 NaN]);

%% Adjust video lengths
len = length(x1_1); % shortest vid

x2_1 = x2_1(10:len+10-1);
y2_1 = y2_1(10:len+10-1);
x3_1 = x3_1(1:len);
y3_1 = y3_1(1:len);

%%
close;
subplot(3,1,1)
plot(1:len,y1_1)
xlim([0 len])
subplot(3,1,2)
plot(1:len,y2_1)
xlim([0 len])
subplot(3,1,3)
plot(1:len,y3_1)
xlim([0 len])

%% PCA
X = [x1_1;y1_1;x2_1;y2_1;x3_1;y3_1];
[m,n] = size(X);
mn = mean(X,2);
X = X - repmat(mn,1,n);

[U,S,V] = svd(X,'econ');
sig = diag(S);
lambda = diag(S).^2;
energy = sig.^2/sum(sig.^2); % 0.9970
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