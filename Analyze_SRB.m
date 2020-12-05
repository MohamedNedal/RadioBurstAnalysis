%% General Protocol for analyzing solar type-II radio bursts 
% Written by: Mohamed Nedal 
close all; clear; clc 
%% 
filename = input('Enter the FIT file name: \n', 's'); 
A = fitsread(filename); 
data_info = fitsinfo(filename); 
date_obs = data_info.PrimaryData.Keywords{17,2}; 
time_obs = data_info.PrimaryData.Keywords{18,2}; 

imagesc(flipud(A)) 
colormap('jet'); colorbar; grid on; grid(gca,'minor'); 
set(gca,'YDir','normal'); set(gca,'XMinorTick','on','YMinorTick','on'); 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
title(data_info.PrimaryData.Keywords{12,2}); 
xlabel(data_info.PrimaryData.Keywords{28,2}); 
ylabel(data_info.PrimaryData.Keywords{32,2}); 

s = input('Please enter "1" for single-band type-II burst, or enter "2" for type-II burst with bandsplitting: \n', 's'); 
s = str2double(s); 

if s == 1
    fprintf('Analyzing single-band type-II radio burst ... \n'); 
    pointsNum = input('Enter the number of data points: \n'); 
    sprintf('The file datetime is: %s %s \n', ... 
        data_info.PrimaryData.Keywords{17,2}, data_info.PrimaryData.Keywords{18,2}) 

    activity_deg = input("Enter the model's fold number (1 - 4; [1] for quiet Sun, [4] for active Sun): \n"); 
    f_or_hr = input('Enter [1] for fundamental backbone, [2] for Harmonic backbone: \n'); 
    
    % REPEAT THE ANALYSIS FOR CALCULATING THE ERROR 
    fprintf('For calculating the standard error ... \n') 
    rpt = input('How many repetitions of the analysis? \n'); 
    
    [output_arr, f] = callisto_single(filename, pointsNum, activity_deg, f_or_hr, rpt); 
    
    N = [output_arr{:,1}]; 
    R = [output_arr{:,2}]; 
    V = [output_arr{:,3}]; 
    t = [output_arr{:,4}]; 
    
    stderror_n = std(N') / sqrt(rpt); 
    stderror_r = std(R') / sqrt(rpt); 
    stderror_v = std(V') / sqrt(rpt); 

elseif s == 2 
    fprintf('Analyzing type-II radio burst with band-splitting ... \n') 
    pointsNum = input('Enter the number of data points: \n'); 

    sprintf('The file datetime is: %s %s \n', ... 
        data_info.PrimaryData.Keywords{17,2}, data_info.PrimaryData.Keywords{18,2})     
    
    activity_deg = input("Enter the model's fold number (1 - 4; [1] for quiet Sun, [4] for active Sun): \n"); 
    f_or_hr = input('Enter [1] for fundamental backbone, [2] for Harmonic backbone: \n');    
    
    % REPEAT THE ANALYSIS FOR CALCULATING THE ERROR 
    fprintf('For calculating the standard error ... \n') 
    rpt = input('How many repetitions of the analysis? \n'); 
    
    [output_arr] = callisto_bandsplit(filename, pointsNum, activity_deg, f_or_hr, rpt); 

    X = [output_arr{:,1}]; 
    Ma = [output_arr{:,2}]; 
    BDW = [output_arr{:,3}]; 
    dfdt = [output_arr{:,4}]; 
    Vs = [output_arr{:,5}]; 
    B = [output_arr{:,6}]; 
    Va = [output_arr{:,7}]; 
    f1 = [output_arr{:,8}]; 
    f2 = [output_arr{:,9}]; 
    n1 = [output_arr{:,10}]; 
    n2 = [output_arr{:,11}]; 
    r1 = [output_arr{:,12}]; 
    r2 = [output_arr{:,13}]; 
    t = [output_arr{:,14}]; 
    
    stderror_X = std(X') / sqrt(rpt); 
    stderror_Ma = std(Ma') / sqrt(rpt); 
    stderror_BDW = std(BDW') / sqrt(rpt); 
    stderror_dfdt = std(dfdt') / sqrt(rpt); 
    stderror_Vs = std(Vs') / sqrt(rpt); 
    stderror_B = std(B') / sqrt(rpt); 
    stderror_Va = std(Va') / sqrt(rpt); 
    stderror_f1 = std(f1') / sqrt(rpt); 
    stderror_f2 = std(f2') / sqrt(rpt); 
    stderror_n1 = std(n1') / sqrt(rpt); 
    stderror_n2 = std(n2') / sqrt(rpt); 
    stderror_r1 = std(r1') / sqrt(rpt); 
    stderror_r2 = std(r2') / sqrt(rpt); 
    
    stderror_dfdt = stderror_dfdt'; 
    stderror_Vs = stderror_Vs'; 
    stderror_r1 = stderror_r1'; 
    stderror_r2 = stderror_r2'; 
    stderror_B = stderror_B'; 
    stderror_X = stderror_X'; 
    stderror_Ma = stderror_Ma'; 
    
    % Plotting 
    figure 
    sgtitle(sprintf('Characteristics of the shock wave that occurred in %s %s', date_obs, time_obs)) 

    subplot(2,3,1) 
    yyaxis left 
    plot(t(:,1), f1(:,1)) 
    ylabel('F-Plasma Frequency (MHz)') 
    yyaxis right 
    plot(t(:,1), f2(:,1)) 
    ylabel('H-Plasma Frequency (MHz)') 
    xlabel('Time (s)') 

    subplot(2,3,2) 
    yyaxis left 
    plot(t(2:end,1), dfdt(2:end,1)) 
    errorbar(t(2:end,1), dfdt(2:end,1), stderror_dfdt(2:end,1)) 
    ylabel('Frequency Drift (MHz/s)') 
    yyaxis right 
    plot(t(2:end,1), Vs(2:end,1)) 
    errorbar(t(2:end,1), Vs(2:end,1), stderror_Vs(2:end,1)) 
    ylabel('Shock Speed (km/s)') 
    xlabel('Time (s)') 

    subplot(2,3,3) 
    yyaxis left 
    plot(t(:,1), r1(:,1)) 
    errorbar(t(:,1), r1(:,1), stderror_r1(:,1)) 
    ylabel('Height for F-band (Rsun)') 
    yyaxis right 
    plot(t(:,1), r2(:,1)) 
    errorbar(t(:,1), r2(:,1), stderror_r2(:,1)) 
    ylabel('Height for H-band (Rsun)') 
    xlabel('Time (s)') 

    subplot(2,3,4) 
    yyaxis left 
    plot(r2(:,1), f1(:,1)) 
    ylabel('F-Plasma Frequency (MHz)') 
    yyaxis right 
    plot(r2(:,1), f2(:,1)) 
    ylabel('H-Plasma Frequency (MHz)') 
    xlabel('Height (Rsun)') 

    subplot(2,3,5) 
    yyaxis left 
    plot(r1(2:end,1), dfdt(2:end,1)) 
    ylabel('Frequency Drift (MHz/s)')
    yyaxis right 
    plot(r1(2:end,1), B(2:end,1)) 
    errorbar(r1(2:end,1), B(2:end,1), stderror_B(2:end,1)) 
    ylabel('Magnetic Field (G)')
    xlabel('Height (Rsun)') 

    subplot(2,3,6) 
    yyaxis left 
    plot(r1(:,1), X(:,1)) 
    errorbar(r1(:,1), X(:,1), stderror_X(:,1)) 
    ylabel('Density Jump') 
    yyaxis right 
    plot(r1(:,1), Ma(:,1)) 
    errorbar(r1(:,1), Ma(:,1), stderror_Ma(:,1)) 
    ylabel('Alfven Mach Number') 
    xlabel('Height (Rsun)') 

else 
    fprintf(2, 'Wrong input! Try again ... \n', filename) 
end 
