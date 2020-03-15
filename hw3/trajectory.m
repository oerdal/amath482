clear; close all; clc;

load('cam1_1.mat')
load('cam1_2.mat')
load('cam1_3.mat')
load('cam1_4.mat')

vid = vidFrames1_1;
numFrames = size(vid,4);

x1_1 = zeros(1,numFrames);
y1_1 = zeros(1,numFrames);
for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(:,1:240,:) = 0;
    V(:,460:640,:) = 0;
    
    [~,x1_1(j)] = max(mean(max(V,[],1),3));
    [~,y1_1(j)] = max(mean(max(V,[],2),3));
end

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
end

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
end

vid = vidFrames1_4;
numFrames = size(vid,4)/2;

x1_4 = zeros(1,numFrames);
y1_4 = zeros(1,numFrames);

for j = 1:numFrames
    V = vid(:,:,:,j);
    V(1:180,:,:) = 0;
    V(:,1:280,:) = 0;
    V(:,480:640,:) = 0;
    
    [~,x1_4(j)] = max(mean(max(V,[],1),3));
    [~,y1_4(j)] = max(mean(max(V,[],2),3));
end

%%
close;
subplot(2,2,1)
plot(x1_1,y1_1,'.'); axis([0,640,0,480]); set(gca, 'YDir','reverse')
title('Ideal Case')
subplot(2,2,2)
plot(x1_2,y1_2,'.'); axis([0,640,0,480]); set(gca, 'YDir','reverse')
title('Noisy Case')
subplot(2,2,3)
plot(x1_3,y1_3,'.'); axis([0,640,0,480]); set(gca, 'YDir','reverse')
title('Horizontal Displacement')
subplot(2,2,4)
plot(x1_4,y1_4,'.'); axis([0,640,0,480]); set(gca, 'YDir','reverse')
title('Displacement and Rotation')