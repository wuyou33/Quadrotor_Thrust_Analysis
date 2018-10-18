function UMASS_Lowell_Data
% This function exists to provide a baseline rpm vs thrust plot for the
% T-Motor MT2212 motor used on the quadrotor with an 8x5 prop

filename = 'Vertical_Test1.csv';
[rpmv1,thrustv1] = read_file(filename);
[rpm_v1,thrust_v1] = clean_thrust(thrustv1,rpmv1);
s = 36;
e = 1838;
[rpmv1_crop,thrustv1_crop] = crop_sets(rpm_v1,thrust_v1,s,e);
% figure
% plot(rpmv1_crop)

filename = 'Vertical_Test2.csv';
[rpmv2,thrustv2] = read_file(filename);
[rpm_v2,thrust_v2] = clean_thrust(thrustv2,rpmv2);
s = 56;
e = 1646;
[rpmv2_crop,thrustv2_crop] = crop_sets(rpm_v2,thrust_v2,s,e);
% figure
% plot(rpmv2_crop)

filename = 'Horizontal_Forward.csv';
[rpmhf,thrusthf] = read_file(filename);
[rpm_hf,thrust_hf] = clean_thrust(thrusthf,rpmhf);
s = 56;
e = 1857;
[rpmhf_crop,thrusthf_crop] = crop_sets(rpm_hf,thrust_hf,s,e);
% figure
% plot(rpmhf_crop)

filename = 'Horizontal_Left.csv';
[rpmhl,thrusthl] = read_file(filename);
[rpm_hl,thrust_hl] = clean_thrust(thrusthl,rpmhl);
s = 34;
e = 1816;
[rpmhl_crop,thrusthl_crop] = crop_sets(rpm_hl,thrust_hl,s,e);
% figure
% plot(rpmhl_crop)

figure
plot(rpmv1_crop.^2,thrustv1_crop,'.r',rpmv2_crop.^2,thrustv2_crop,'b.',rpmhf_crop.^2,thrusthf_crop,'g.',rpmhl_crop.^2,thrusthl_crop,'k.')
legend('Vertical Close','Vertical Far','Horizontal Close','Horizontal Far','Location','Northeast')
xlabel('\omega^2')
ylabel('Thrust')
title('\omega^2 vs Thrust for all UMASS Tests')

%linfit_RPMvsThrust(rpm_crop,thrust_crop)

load('rpm_thrust')
omega = rad_sec.^2;
figure
plot(omega(1,:),thrust,'.',omega(2,:),thrust,'.',omega(3,:),thrust,'.',omega(4,:),thrust,'.')
xlabel('\omega^2')
ylabel('Thrust(N)')
title('\omega^2 vs Thrust for Quadrotor')
legend('Motor 1','Motor 2','Motor 3','Motor 4','Location','Northwest')



%This function opens the .csv given and returns the rpm(rad/s) and thrust
%value (kg*f)
function [rpm,thrust] = read_file(filename)
vals = csvread(filename,1);
rpm = vals(:,14);
thrust = (vals(:,10)).*9.80665;

% This function eliminates the 0 value readings within the dataset
function [rpm_out,thrust_out] = clean_thrust(thrust,rpm)
% out = thrust';
% out(abs([diff(thrust') 0])>0.1)=NaN;
thrust_out = [];
rpm_out = [];
for i = 1:length(thrust)
    if abs(thrust(i)) > .025
        rpm_out(end+1) = rpm(i);
        thrust_out(end+1) = thrust(i);
    end
end

% This function normalizes the vector s to be on a scale of 0 --> 1
function s_o = condition(s)
mins = min(s);
maxs = max(s);
s_o = (s-mins)./(maxs-mins);

% This function crops the datasets to start at 's', and end at 'e'
function [rpm_crop,thrust_crop] = crop_sets(rpm,thrust,s,e)
rpm_crop = rpm(s:e);
thrust_crop = thrust(s:e);

% This function applies a linear fit to the rpm vs thrust plot and displays
% it
function linfit_RPMvsThrust(rpm,thrust)
rpm_sq = rpm.^2;
lin_fit = fitlm(rpm_sq,thrust,'linear');
q=table2array(lin_fit.Coefficients(1,'Estimate'));
p=table2array(lin_fit.Coefficients(2,'Estimate'));

figure
plot(rpm_sq,thrust,'.')
hold on
%plot(t,omega.*p+q,'b',t,rpm,'r')
linfit = rpm_sq.*p+q;
plot(rpm_sq,linfit)

legend('Thrust','Linear Fit','Location','Northwest')
xlabel('\omega^{2}')
ylabel('Thrust')


