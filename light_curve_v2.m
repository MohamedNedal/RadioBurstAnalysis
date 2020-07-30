%% This code for plotting 2D-spectrucm from CALLISTO with the light curve 
% written by: Mohamed Nedal 
close all; clear; clc 
format bank 
%% Import data 
% change the filename and the file path to yours 
file = 'DARO_20130502_050001_58.fit'; 
path = 'D:\Study\Academic\Research\Master Degree\Master Work\Software\Codes\MATLAB\spectrogram_callisto\RadioBurstAnalysis-master\'; 
img = fitsread(strcat(path,file)); 
data_info = fitsinfo(strcat(path,file)); 
clear file path 
%% Plot data 
figure 
imagesc(flipud(img)) 
colormap('jet') 
colorbar 
grid on 
grid(gca,'minor') 
set(gca,'YDir','normal') 
set(gca,'XMinorTick','on','YMinorTick','on') 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
title(data_info.PrimaryData.Keywords{12,2}) 
xlabel('Time in minutes') 
ylabel('Frequency (MHz)') 
%% Remove the backgorund with a threshold value 
fprintf('Max flux density in the spcetrum is %0.2f sfu. \n', max(max(img))) 
fprintf('Min flux density in the spcetrum is %0.2f sfu. \n', min(min(img))) 
threshold = input('Enter the threshold value of the flux density between the max and min values\nthat will be subtracted from the spectrum as the background: '); 
% Empty array with the same size of the zoomed part 
R = zeros(size(img)); 
% Returns m-rows and n-columns 
[m, n] = size(img); 
for m = 1:m  % loop on rows 
    for n = 1:n % loop on columns 
        if img(m,n) >= threshold % threshold value 
            R(m,n) = R(m,n) + img(m,n); 
        end 
    end 
end 
%% FLux density VS Frequency 
figure 
imagesc(flipud(R)) 
colormap('jet') 
colorbar 
grid on 
grid(gca,'minor') 
set(gca,'YDir','normal') 
set(gca,'XMinorTick','on','YMinorTick','on') 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
title(sprintf('Subtracted background, %s\nClick on the point of interest', data_info.PrimaryData.Keywords{12,2})) 
xlabel('Time in minutes') 
ylabel('Frequency (MHz)') 
hold on
[x,y] = ginput(1); 
% convert from float to integer number 
x = floor(x); 
y = floor(y); 
% flux density vs frequency 
sub_img1 = img(:,x); 
sub_R1 = R(:,x); 
% flux density vs time 
sub_img2 = img(y,:); 
sub_R2 = R(y,:); 
hold off 
%% Spectrogram VS Light curve 
subplot(3,2,1) 
imagesc(flipud(img)) 
colormap('jet') 
colorbar 
grid on 
grid(gca,'minor') 
set(gca,'YDir','normal') 
set(gca,'XMinorTick','on','YMinorTick','on') 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
title(data_info.PrimaryData.Keywords{12,2}) 
xlabel('Time in minutes') 
ylabel('Frequency (MHz)') 

subplot(3,2,2) 
imagesc(flipud(R)) 
colormap('jet') 
colorbar 
grid on 
grid(gca,'minor') 
set(gca,'YDir','normal') 
set(gca,'XMinorTick','on','YMinorTick','on') 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
title(sprintf('Subtracted background, %s', data_info.PrimaryData.Keywords{12,2})) 
xlabel('Time in minutes') 
ylabel('Frequency (MHz)') 

subplot(3,2,3) 
plot(flipud(sub_img1)) 
grid on 
title(sprintf('Light Curve for the original spectrum at time bin = %d', x)) 
xlabel('Frequency (MHz)') 
ylabel('Flux density (sfu)') 

subplot(3,2,4) 
plot(flipud(sub_R1)) 
grid on 
title(sprintf('Light Curve for the subtracted background spectrum at time bin = %d', x)) 
xlabel('Frequency (MHz)') 
ylabel('Flux density (sfu)') 

subplot(3,2,5) 
plot(flipud(sub_img2)) 
grid on 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
xlim([0 length(sub_img2)]) 
title(sprintf('Light Curve for the original spectrum at frequency = %d', y)) 
xlabel('Time') 
ylabel('Flux density (sfu)') 

subplot(3,2,6) 
plot(flipud(sub_R2)) 
grid on 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
xlim([0 length(sub_R2)]) 
title(sprintf('Light Curve for the subtracted background spectrum at frequency = %d', y)) 
xlabel('Time') 
ylabel('Flux density (sfu)') 
%% 



