%% This function is for analysing single-band solar type-II radio bursts 
%% data obtained from the CALLISTO spectrometer. 
% This work is inspired by the IDL code of Pietro Zucca and the Python code 
% of Christian Monstein. 
% It can be found here: https://github.com/MohamedNedal/RadioBurstAnalysis 
% Written by: Mohamed Nedal 
function [output_arr, f, t] = callisto_single(filename, pointsNum, activity_deg, f_or_hr, rpt)
%% This function is to analyze CALLISTO data & Find shock parameters 
% activity_deg: Enter the degree of solar activity (1:low - 4:hight). 
% f_or_hr: Press 1 for fundamental band, or press 2 for harmonic band. 
% Ex. [output_arr, f, t] = callisto_single('DARO_20130502_050001_58.fit', 7, 4, 2, 3); 

%% Info from the data file 
A = fitsread(filename); 
data_info = fitsinfo(filename); 
date_obs = data_info.PrimaryData.Keywords{17,2}; 
time_obs = data_info.PrimaryData.Keywords{18,2}; 
date_end = data_info.PrimaryData.Keywords{19,2}; 
time_end = data_info.PrimaryData.Keywords{20,2}; 
datetime_start = strcat(date_obs,{' '},time_obs); 
datetime_end = strcat(date_end,{' '},time_end); 
datetime1 = datetime(datetime_start,'InputFormat','yyyy/MM/dd HH:mm:ss.SSS'); 
datetime2 = datetime(datetime_end,'InputFormat', 'yyyy/MM/dd HH:mm:ss'); 
dtdiff = datetime2 - datetime1; 
duration_vector = datevec(dtdiff); 
fprintf('The observation duration is %i hours, %i minutes, %0.2f seconds. \n',...
    duration_vector(4), duration_vector(5), duration_vector(6)) 

%% 
output_arr = {}; 

for j = 1:rpt 

    imagesc(flipud(A)); 
    colormap('jet'); colorbar; grid on; grid(gca,'minor') 
    set(gca,'YDir','normal'); set(gca,'XMinorTick','on','YMinorTick','on') 
    ax = gca; 
    ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
    ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 
    title(data_info.PrimaryData.Keywords{12,2}) 
    xlabel(sprintf('%s in Minutes',data_info.PrimaryData.Keywords{28,2})) 
    ylabel(data_info.PrimaryData.Keywords{32,2}) 

    coordinates_1 = zeros(pointsNum, 2); 
    hold on 

    sprintf('\nStarting repetition number %d \n', j) 

    for i = 1:pointsNum 
        [x,y] = ginput(1); 
        coordinates_1(i,:) = [x,y]; 
        plot(coordinates_1(:,1), coordinates_1(:,2), '.k', 'MarkerSize', 20) 
    end 
    clear i  

    [n, r] = newkirk(f_or_hr, coordinates_1(:,2), activity_deg); 
    
    t = coordinates_1(:,1); 
    f = coordinates_1(:,2); 

    % Save Fig. 
    fig = gcf; 
    fig.PaperUnits = 'centimeters'; 
    fig.PaperPosition = [0 0 30 20]; 
    fig.PaperPositionMode = 'manual'; 
    figTitle = sprintf('CALLISTO_%s_rpt_%d', data_info.PrimaryData.Keywords{15,2}, j); 
    print(figTitle,'-dpng','-r0'); 

% Proceed Analysis 
    for z = 2:length(f) 
        % shock speed 
        v(z) = ((r(z) - r(z-1))*695500)/(t(z) - t(z-1)); 
    end 
    clear z 
    
    output_arr{j, 1} = n; 
    output_arr{j, 2} = r; 
    output_arr{j, 3} = v'; 
    output_arr{j, 4} = t; 

    sprintf('Ending repetition number %d successfully \n\n', j) 
    
end
clear j 
hold off 

end 