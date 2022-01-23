clear
clc

dims = [10, 10, 550, 650];
fig = 0;

% Part A.3

%% Reading patient data
path = ".\COVID-19-Wearables\COVID-19-Wearables\"; % COVID-19-Wearables should be in the same directory as code

hr_1 = readtable(path + "A0NVTRV_hr.csv");
hr_2 = readtable(path + "A36HR6Y_hr.csv");
hr_3 = readtable(path + "A1K5DRI_hr.csv");
hr_4 = readtable(path + "A1ZJ41O_hr.csv");
hr_5 = readtable(path + "A7EM0B6_hr.csv");

% Sleep and step data must be collated to a daily basis observation,
% otherwise major outliers will be present that cannot be used
sleep_1_temp = readtable(path + "A0NVTRV_sleep.csv");
sleep_2_temp = readtable(path + "A36HR6Y_sleep.csv");
sleep_3_temp = readtable(path + "A1K5DRI_sleep.csv");
sleep_4_temp = readtable(path + "A1ZJ41O_sleep.csv");
sleep_5_temp = readtable(path + "A7EM0B6_sleep.csv");

steps_1_temp = readtable(path + "A0NVTRV_steps.csv");
steps_2_temp = readtable(path + "A36HR6Y_steps.csv");
steps_3_temp = readtable(path + "A1K5DRI_steps.csv");
steps_4_temp = readtable(path + "A1ZJ41O_steps.csv");
steps_5_temp = readtable(path + "A7EM0B6_steps.csv");

% Remove observations from sleep that are not sleep stages/provide no conclusive data
stages_to_remove = ["wake", "restless", "awake", "unknown"];
sleep_1_removed = sleep_1_temp(~(ismember(sleep_1_temp.stage, stages_to_remove)),:);
sleep_2_removed = sleep_2_temp(~(ismember(sleep_2_temp.stage, stages_to_remove)),:);
sleep_3_removed = sleep_3_temp(~(ismember(sleep_3_temp.stage, stages_to_remove)),:);
sleep_4_removed = sleep_4_temp(~(ismember(sleep_4_temp.stage, stages_to_remove)),:);
sleep_5_removed = sleep_5_temp(~(ismember(sleep_5_temp.stage, stages_to_remove)),:);

% Create tables that show daily input, rather than singular observations
sleep_1 = combine_times(sleep_1_removed, 2, 3);
sleep_2 = combine_times(sleep_2_removed, 2, 3);
sleep_3 = combine_times(sleep_3_removed, 2, 3);
sleep_4 = combine_times(sleep_4_removed, 2, 3);
sleep_5 = combine_times(sleep_5_removed, 2, 3);

steps_1 = combine_times(steps_1_temp, 2, 3);
steps_2 = combine_times(steps_2_temp, 2, 3);
steps_3 = combine_times(steps_3_temp, 2, 3);
steps_4 = combine_times(steps_4_temp, 2, 3);
steps_5 = combine_times(steps_5_temp, 2, 3);

%% Calculate central tendency and dispersion
% The median was chosen for CT due to being robust to outliers
median_hr_1 = median(hr_1.(3));
median_hr_2 = median(hr_2.(3));
median_hr_3 = median(hr_3.(3));
median_hr_4 = median(hr_4.(3));
median_hr_5 = median(hr_5.(3));

% All observations with 0 
median_steps_1 = median(steps_1.(2));
median_steps_2 = median(steps_2.(2));
median_steps_3 = median(steps_3.(2));
median_steps_4 = median(steps_4.(2));
median_steps_5 = median(steps_5.(2));

median_sleep_1 = double(median(sleep_1.(2)) / 3600.0);
median_sleep_2 = double(median(sleep_2.(2)) / 3600.0);
median_sleep_3 = double(median(sleep_3.(2)) / 3600.0);
median_sleep_4 = double(median(sleep_4.(2)) / 3600.0);
median_sleep_5 = double(median(sleep_5.(2)) / 3600.0);

% The IQR was chosen for dispersion due to also being robus to outliers
iqr_hr_1 = iqr(hr_1.(3));
iqr_hr_2 = iqr(hr_2.(3));
iqr_hr_3 = iqr(hr_3.(3));
iqr_hr_4 = iqr(hr_4.(3));
iqr_hr_5 = iqr(hr_5.(3));

iqr_steps_1 = iqr(steps_1.(2));
iqr_steps_2 = iqr(steps_2.(2));
iqr_steps_3 = iqr(steps_3.(2));
iqr_steps_4 = iqr(steps_4.(2));
iqr_steps_5 = iqr(steps_5.(2));

iqr_sleep_1 = double(iqr(sleep_1.(2)) / 3600.0);
iqr_sleep_2 = double(iqr(sleep_2.(2)) / 3600.0);
iqr_sleep_3 = double(iqr(sleep_3.(2)) / 3600.0);
iqr_sleep_4 = double(iqr(sleep_4.(2)) / 3600.0);
iqr_sleep_5 = double(iqr(sleep_5.(2)) / 3600.0);

% Represent IQR and Median values as bar graphs to compare each patient
fig = fig + 1;
median_hr = [median_hr_1; median_hr_2; median_hr_3; median_hr_4; median_hr_5];
median_hr_bar = create_bar(median_hr, fig, ...
    ["A0NVTRV","A36HR6Y","A1K5DRI","A1ZJ41O","A7EM0B6"], ...
    'Median values of heart rate per observation', dims, [0 90], '%.0f');

fig = fig + 1;
median_steps = [median_steps_1; median_steps_2; median_steps_3; median_steps_4; median_steps_5];
median_steps_bar = create_bar(median_steps, fig, ...
    ["A0NVTRV","A36HR6Y","A1K5DRI","A1ZJ41O","A7EM0B6"], ...
    'Median values of steps per day', dims, [0 8000], '%.0f');

fig = fig + 1;
median_sleep = [median_sleep_1; median_sleep_2; median_sleep_3; median_sleep_4; median_sleep_5];
median_sleep_bar = create_bar(median_sleep, fig, ...
    ["A0NVTRV","A36HR6Y","A1K5DRI","A1ZJ41O","A7EM0B6"], ...
    'Median values of hours of sleep per day', dims, [0 8], '%.2f');

%% Function declarations

function new_bar = create_bar(inputs, figure_number, xtick, title_name, dimensions, ylims, declim)
    figure(figure_number)
    new_bar = bar(inputs);
    title(title_name)
    set(gcf,'position',dimensions)
    set(gca,'xticklabel',xtick)
    ylim(ylims)

    for k1 = 1:size(inputs,2)
    ctr(k1,:) = bsxfun(@plus, new_bar(1).XData, new_bar(k1).XOffset');  
    ydt(k1,:) = new_bar(k1).YData;                                    
    text(ctr(k1,:), ydt(k1,:), sprintfc(declim, ydt(k1,:)), 'HorizontalAlignment','center', 'VerticalAlignment','bottom', 'FontSize',8, 'Color','b')
    end
end

function combined_set = combine_times(inputs, time_section, input_section)
    input = [];
    time = [];
    overall_cycle = string(inputs.(time_section)(1));
    overall_time = str2double(extractBetween(overall_cycle,9,10));
    recorded_input = 0;

    for i = 1:size(inputs.(input_section))
        current_cycle = string(inputs.(time_section)(i));
        current_time = str2double(extractBetween(current_cycle,9,10));

        if (current_time == overall_time)
            recorded_input = recorded_input + inputs.(input_section)(i);
        else
            input = [input, recorded_input];
            time = [time, overall_cycle];
            overall_cycle = string(inputs.(time_section)(i));
            recorded_input = inputs.(input_section)(i);
        end

        overall_time = current_time;
    end

    combined_set = table(time', input');
end