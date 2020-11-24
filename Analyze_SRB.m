%% General Protocol for analyzing solar type-II radio bursts 
% Written by: Mohamed Nedal 
close all; clear; clc 
%% 
s = input('Please enter "1" for single-band type-II burst, or enter "2" for type-II burst with bandsplitting: \n', 's'); 
s = str2double(s); 

if s == 1
    fprintf('Analyzing single-band type-II radio burst ... \n'); 
    filename = input('Enter the FIT file name: \n', 's'); 
    pointsNum = input('Enter the number of data points: \n'); 
    A = fitsread(filename); 
    data_info = fitsinfo(filename); 
    sprintf('The file datetime is: %s %s \n', ... 
        data_info.PrimaryData.Keywords{17,2}, data_info.PrimaryData.Keywords{18,2}) 
    C = max(A); imagesc(flipud(A)); 
    colormap('jet'); colorbar; grid on; grid(gca,'minor'); 
    set(gca,'YDir','normal'); set(gca,'XMinorTick','on','YMinorTick','on'); 
    ax = gca; 
    ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
    ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
    title(data_info.PrimaryData.Keywords{12,2}); 
    xlabel(data_info.PrimaryData.Keywords{28,2}); 
    ylabel(data_info.PrimaryData.Keywords{32,2}); 

    activity_deg = input("Enter the model's fold (1 - 4; [1] for quiet Sun, [4] for active Sun): \n"); 
    f_or_hr = input('Enter [1] for fundamental backbone, [2] for Harmonic backbone: \n'); 
    [n,r,f,t] = callisto_single(filename,pointsNum,activity_deg,f_or_hr); 

elseif s == 2 
    fprintf('Analyzing type-II radio burst with band-splitting ... \n') 
    filename = input('Enter the FIT file name: \n', 's'); 
    pointsNum = input('Enter the number of data points: \n'); 
    A = fitsread(filename); 
    data_info = fitsinfo(filename); 
    sprintf('The file datetime is: %s %s \n', ... 
        data_info.PrimaryData.Keywords{17,2}, data_info.PrimaryData.Keywords{18,2})     
    C = max(A); imagesc(flipud(A)); 
    colormap('jet'); colorbar; grid on; grid(gca,'minor'); 
    set(gca,'YDir','normal'); set(gca,'XMinorTick','on','YMinorTick','on'); 
    ax = gca; 
    ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
    ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
    title(data_info.PrimaryData.Keywords{12,2}); 
    xlabel(data_info.PrimaryData.Keywords{28,2}); 
    ylabel(data_info.PrimaryData.Keywords{32,2}); 
    
    activity_deg = input("Enter the model's fold (1 - 4; [1] for quiet Sun, [4] for active Sun): \n"); 
    f_or_hr = input('Enter [1] for fundamental backbone, [2] for Harmonic backbone: \n');    
    [X,Ma,BDW,dfdt,Vs,B,Va,f1,f2,n1,n2,r1,r2,t] = ...
        callisto_bandsplit(filename,pointsNum,activity_deg,f_or_hr); 

else 
    fprintf(2, 'Wrong input! Try again ... \n', filename) 
end 
