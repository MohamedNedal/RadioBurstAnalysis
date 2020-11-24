%% This function is for analysing solar type-II radio bursts data, 
%% with band-splitting, obtained from the CALLISTO spectrometer. 
% This work is inspired by the IDL code of Pietro Zucca and the Python code 
% of Christian Monstein. 
% It can be found here: https://github.com/MohamedNedal/RadioBurstAnalysis 
% Written by: Mohamed Nedal 
function [X,Ma,BDW,dfdt,Vs,B,Va,f1,f2,n1,n2,r1,r2,t] = callisto_bandsplit(filename,pointsNum,activity_deg,f_or_hr) 
%% This function is to analyze CALLISTO data & Find shock parameters 
% activity_deg: Enter the degree of solar activity (1:low - 4:hight). 
% f_or_hr: Press 1 for fundamental band, or press 2 for harmonic band. 
% bandsplit: If there is band-splitting, Press 1. 

%% Info from the data file 
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
        % frequency drift 
        dfdt(i) = (f1(i) - f1(i-1))/(t(i) - t(i-1)); 
        % alfven speed 
        Va(i) = Vs(i)/Ma(i); 
        % coronal magnetic field 
        B(i) = (5.1*(10^-5))*f1(i)*Va(i); 
    end 
elseif f_or_hr == 2 
    for i = 2:length(f2) 
        % shock speed 
        Vs(i) = ((r2(i) - r2(i-1))*695500)/(t(i) - t(i-1)); 
        % frequency drift 
        dfdt(i) = (f2(i) - f2(i-1))/(t(i) - t(i-1)); 
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

%% Plotting 
figure 
sgtitle(sprintf('Characteristics of the shock wave that occurred in %s %s', ...
    date_obs, time_obs)) 
subplot(2,3,1) 
yyaxis left 
plot(t, f1) 
ylabel('F-Plasma Frequency (MHz)') 
yyaxis right 
plot(t, f2) 
ylabel('H-Plasma Frequency (MHz)') 
xlabel('Time (s)') 
        
subplot(2,3,2) 
yyaxis left 
plot(t, dfdt) 
ylabel('Frequency Drift (MHz/s)') 
yyaxis right 
plot(t, Vs) 
ylabel('Shock Speed (km/s)') 
xlabel('Time (s)') 
        
subplot(2,3,3) 
yyaxis left 
plot(t, r1) 
ylabel('Height for F-band (Rsun)') 
yyaxis right 
plot(t, r2) 
ylabel('Height for H-band (Rsun)') 
xlabel('Time (s)') 
        
subplot(2,3,4) 
yyaxis left 
plot(r2, f1) 
ylabel('F-Plasma Frequency (MHz)') 
yyaxis right 
plot(r2, f2) 
ylabel('H-Plasma Frequency (MHz)') 
xlabel('Height (Rsun)') 
        
subplot(2,3,5) 
yyaxis left 
plot(r1, dfdt) 
ylabel('Frequency Drift (MHz/s)')
yyaxis right 
plot(r1, B) 
ylabel('Magnetic Field (G)')
xlabel('Height (Rsun)') 
        
subplot(2,3,6) 
yyaxis left 
plot(r1, X) 
ylabel('Density Jump') 
yyaxis right 
plot(r1, Ma) 
ylabel('Alfven Mach Number') 
xlabel('Time (s)') 

end 