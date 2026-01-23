% This should taken as input from user
format long;

data=readmatrix("GUI_values.xlsx");

L=data(1,1);
W =data(1,2);
t_final=data(1,3) ;
delta_x=data(1,4) ;
delta_y=data(1,5) ;
delta_t = data(1,6);
alpha = data(1,11);

top_bc= data(1,7);
bottom_bc= data(1,8)  ;
right_bc=data(1,9)  ;
left_bc=data(1,10);

% Creating the 3D matrix for storing simulation data
col_num = ceil(L/delta_x) + 1;
new_delta_x = L/(col_num - 1);
x_values = 0:new_delta_x:L;
row_num = ceil(W/delta_y) + 1;
new_delta_y = W/(row_num - 1);
y_values = 0:new_delta_y:W;
time_points = ceil(t_final/delta_t) + 1;
new_delta_t = t_final/(time_points - 1);
t_values = 0:new_delta_t:t_final;
disp(x_values);

% Initial condition; they are also inputs from user
% Set the whole plate to a baseline
simulation_data(:,:,1) = 10;
simulation_data(1:40, 1:40, 1) = 500;

% Boundary condition
simulation_data(1,:,:) = top_bc;
simulation_data(end,:,:) = bottom_bc;
simulation_data(:,end,:) = right_bc;
simulation_data(:,1,:) = left_bc;
disp(simulation_data);

% The main code which calculates the simulation data
for t = 2:time_points
    % Note: Vectorizing this loop in MATLAB is much faster than nested for-loops
    simulation_data(2:end-1, 2:end-1, t) = ...
        simulation_data(2:end-1, 2:end-1, t-1) + ...
        (alpha * new_delta_t / new_delta_x^2) * ...
        (simulation_data(2:end-1, 3:end, t-1) - 2*simulation_data(2:end-1, 2:end-1, t-1) + simulation_data(2:end-1, 1:end-2, t-1)) + ...
        (alpha * new_delta_t / new_delta_y^2) * ...
        (simulation_data(3:end, 2:end-1, t-1) - 2*simulation_data(2:end-1, 2:end-1, t-1) + simulation_data(1:end-2, 2:end-1, t-1));
end

% The following code for animation:
fig = uifigure('Name', 'Heat Flow Player', 'Position', [100 100 700 550]);
ax = uiaxes(fig, 'Position', [50 150 600 350]);

h = imagesc(ax, x_values, y_values, simulation_data(:,:,1));
colorbar(ax); axis(ax, 'equal', 'tight');
clim(ax, [min(simulation_data(:)), max(simulation_data(:))]);
disp(min(simulation_data(:)));
title(ax, 'Time: 0.000s');

% --- Slider ---
sld = uislider(fig, 'Position', [150 100 400 3], ...
    'Limits', [1, time_points], 'Value', 1);

% --- Play/Pause Button ---
btn = uibutton(fig, 'state', 'Position', [280 40 140 30], ...
    'Text', 'Play', 'ValueChangedFcn', @(btn, event) playAnimation(btn, sld, h, ax, simulation_data, t_values));

% --- Reset Button ---
uibutton(fig, 'push', 'Position', [440 40 80 30], ...
    'Text', 'Reset', 'ButtonPushedFcn', @(b, e) resetSim(sld, h, ax, simulation_data, t_values));

% Continuous update when dragging slider
sld.ValueChangingFcn = @(s, e) updateFrame(e.Value, h, ax, simulation_data, t_values);


function playAnimation(btn, sld, h, ax, data, times)
    % 1. Update text based on the button state
    if btn.Value == 1
        btn.Text = 'Pause';
    else
        btn.Text = 'Play';
    end

    % 2. Run the loop only while the button is "pressed" (Value == 1)
    while btn.Value == 1 && sld.Value < length(times)
        % Advance the slider
        sld.Value = sld.Value + 5; 
        
        % Update the visual plot
        updateFrame(sld.Value, h, ax, data, times);
        
        % This pause is critical—it allows the UI to process the 
        % "Un-click" if you press the button again to pause.
        pause(0.01); 
        
        % If we hit the end of the simulation
        if sld.Value >= length(times)
            btn.Value = 0; % Pop the button back out
            btn.Text = 'Play';
        end
    end
end

function updateFrame(val, h, ax, data, times)
    idx = round(val);
    if idx < 1, idx = 1; end
    if idx > length(times), idx = length(times); end
    set(h, 'CData', data(:,:,idx));
    title(ax, ['Time: ', num2str(times(idx), '%.3f'), 's']);
end

function resetSim(sld, h, ax, data, times)
    sld.Value = 1;
    updateFrame(1, h, ax, data, times);
end