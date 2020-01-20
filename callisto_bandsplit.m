function [f1,f2,n1,n2,r1,r2,t] = callisto_bandsplit(filename,pointsNum,activity_deg,f_or_hr) 
%% This function is to analyze CALLISTO data & Find shock parameters 
% activity_deg: Enter the degree of solar activity (1:low - 4:hight). 
% f_or_hr: Press 1 for fundamental band, or press 2 for harmonic band. 
% bandsplit: If there is band-splitting, Press 1. 
A = fitsread(filename); 
data_info = fitsinfo(filename); 
C = max(A); 
f = imagesc(flipud(A)); 
colormap('jet'); 
colorbar; 
grid on; 
grid(gca,'minor'); 
set(gca,'YDir','normal'); 
set(gca,'XMinorTick','on','YMinorTick','on'); 
ax = gca; 
ax.XTick = [0,240,480,720,960,1200,1440,1680,1920,2160,2400,2640,2880,3120,3360,3600]; 
ax.XTickLabel = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; 

title(data_info.PrimaryData.Keywords{12,2}); 
xlabel(data_info.PrimaryData.Keywords{28,2}); 
ylabel(data_info.PrimaryData.Keywords{32,2}); 

%% Info from the data file 
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
    duration_vector(4), duration_vector(5), duration_vector(6)); 

s = input('Enter the separation between the two bands (in frequency [MHz]): \n'); 
disp('Start clicking at the lower band ... '); 

% Plotting TWO dots at the same 'TIME' with ONE click 
fundamental = zeros(pointsNum,2); 
harmonic = zeros(pointsNum,2); 
hold on 
for i = 1:pointsNum 
    [x,y] = ginput(1); 
    fundamental(i,:) = [x,y];    % fundamental band 
    harmonic(i,:) = [x, y+s];    % 2nd harmonic band 
    plot(fundamental(:,1), fundamental(:,2),'.k','MarkerSize',20); 
    plot(harmonic(:,1), harmonic(:,2),'.k','MarkerSize',20); 
end 
hold off 
clear i prmt pointsNum; 
[n1, r1] = newkirk(f_or_hr, fundamental(:,2), activity_deg); 
[n2, r2] = newkirk(f_or_hr, harmonic(:,2), activity_deg); 
t = fundamental(:,1); 
f1 = fundamental(:,2); 
f2 = harmonic(:,2); 
% Save Fig. 
fig = gcf; 
fig.PaperUnits = 'centimeters'; 
fig.PaperPosition = [0 0 30 20]; 
fig.PaperPositionMode = 'manual'; 
figTitle = sprintf('CALLISTO_%s',data_info.PrimaryData.Keywords{15,2}); 
print(figTitle,'-dpng','-r0'); 
%% Proceed Analysis 
for i = 1:length(t) 
    % density jump 
    X(i) = n2(i)/n1(i); 
    % instantaneous bandwidth BDW 
    BDW(i) = (f2(i) - f1(i))/f1(i); 
    % alfven mach number 
    Ma(i) = sqrt((X(i)*(X(i)+5))/(2*(4-X(i)))); 
end 
clear i; 

if f_or_hr == 1 
    for i = 2:length(t) 
        % shock speed 
        Vs(i) = ((r1(i) - r1(i-1))*695500)/(t(i) - t(i-1)); 
        % alfven speed 
        Va(i) = Vs(i)/Ma(i); 
        % coronal magnetic field 
        B(i) = (5.1*(10^-5))*f1(i)*Va(i); 
    end 
elseif f_or_hr == 2 
    for i = 2:length(f2) 
        % shock speed 
        Vs(i) = ((r2(i) - r2(i-1))*695500)/(t(i) - t(i-1)); 
        % alfven speed 
        Va(i) = Vs(i)/Ma(i); 
        % coronal magnetic field 
        B(i) = (5.1*(10^-5))*f2(i)*Va(i); 
    end 
end 
clear i; 
%% Stats 
Vs_avg = mean(Vs); 
fprintf('Mean value of shock speed is %0.2f km/s \n', Vs_avg); 
Va_avg = mean(Va); 
fprintf('Mean value of Alfven speed is %0.2f km/s \n', Va_avg); 
X_avg = mean(X); 
fprintf('Mean value of density jump is %0.2f \n', X_avg); 
Ma_avg = mean(Ma); 
fprintf('Mean value of Alfven Mach number is %0.2f \n', Ma_avg); 
BDW_avg = mean(BDW); 
fprintf('Mean value of inst. band-width is %0.2f \n', BDW_avg); 
B_avg = mean(B); 
fprintf('Mean value of coronal magnetic field is %0.2f G \n', B_avg); 
end 