%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Robust Conjugate Direction Search (RCDS) Algorithm
% Orginal Code by X. Huang of SLAC Xiaobiao <xiahuang@slac.stanford.edu>
% Modified Code by R. Auchettl of Australian Synchrotron 20181102
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Disclaimer: The RCDS algorithm or the Matlab RCDS code come with absolutely 
%NO warranty. The author of the RCDS method and the Matlab RCDS code does not 
%take any responsibility for any damage to equipments or personnel injury 
%that may result from the use of the algorithm or the code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A. Ali
% Updates:
%   A generic objective function for RCDS GUI
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function obj = generic_objective(x)
% Do not this section - it sets the parameter boundary %control and scaling. 

global vrange
Nvar = size(vrange, 1);

if size(x,1)==1
    x = x';
end
p = vrange(:,1) + (vrange(:,2) - vrange(:,1)).*x;

if min(x)<0 || max(x)>1
    dxlim = 0;
    for ii=1:Nvar
        if x(ii)<0
            dxlim = dxlim + abs(x(ii));
        elseif x(ii)>1
            dxlim = dxlim + abs(x(ii)-1);
        end
    end
    
    obj = NaN; %-5 + dxlim^2;
    return;
end

%% Objective function definition
% asum = set objective function initially to 0
% e.g asum = 0;
% Over the number of variables, update the initial objfunction -
% formula and update for every parameter p0
% e.g for i = 1 : Nvar - 1
%    asum = asum - 10*exp(-0.2*sqrt((p(i))^2 + (p(i + 1))^2));
%end
% Add random number to simulate noise. 
%asum = asum + randn*0.001;
%obj = asum;

% For optimization of skew quads experimentally:
% Set Skew Quads
%setsp('SKQ', p);
%setsp('SR13CPS10:CURRENT_SP', p(1));
%setsp('SR13CPS11:CURRENT_SP', p(2));
%setsp('SR14CPS10:CURRENT_SP', p(3));
%setsp('SR14CPS11:CURRENT_SP', p(4));
%pause(2); % pause for 1 seconds
%variables
setsp(app.edit15_2.Value, p(1));
setsp(app.edit15_6.Value, p(2));
setsp(app.edit15_25.Value, p(3));
setsp(app.edit15_26.Value, p(4));
setsp(app.edit15_27.Value, p(5));
setsp(app.edit15_28.Value, p(6));
[r,c]=find(ismember(p,Inf));
p(r,:)=[];
%setsp('SR14KM01:PULSE_CENTRE_OF_MASS_MONITOR', p(5));
%setsp('SR01KM01:PULSE_CENTRE_OF_MASS_MONITOR', p(6));
%setsp('SR01KM02:PULSE_CENTRE_OF_MASS_MONITOR', p(7));
%setsp('SR02KM01:PULSE_CENTRE_OF_MASS_MONITOR'), p(8);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Kicker Voltages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Getting values for objective values

rad_dose = app.edit11.Value;
obj2 = app.edit12.Value;
obj3 = app.edit14.Value;
%Assigning min and max
obj1 = -rad_dose;
if app.togglebutton5 == true
    obj2 = -obj2;
end
if app.togglebutton6 == true
    obj3 = -obj3;
end
obj = [obj1; obj2; obj3]; %chose the number of objectives
[r,c]=find(ismember(obj,Inf));
p(r,:)=[];
pause(10);




%% Save Data
global g_data g_cnt
g_cnt = g_cnt+1;
%g_data(g_cnt,:) = [p',obj]; %

% Save data
%g_data(g_cnt, :) = [p', obj];
% Save data including vertical beam size
g_data(g_cnt, :) = [p', obj1, obj2, obj3];
[g_cnt, p', obj1, obj2, obj3]
% Print Solution[g_cnt, p',obj]
