%% Reading csv files
alice_1 = readtable("recordings\Alice_1a_filtered.csv");
alice_2 = readtable("recordings\Alice_1b_filtered.csv");

alice_1 = removevars(alice_1, "BioRadioEvent");
alice_2 = removevars(alice_2, "BioRadioEvent");

%% Convert time
alice_1_converted = alice_1;
alice_2_converted = alice_2;

alice_1_converted.ElapsedTime = convertTimes(alice_1_converted.ElapsedTime, 61.3185000000000);
alice_1_converted(1:122637,:) = [];
alice_2_converted.ElapsedTime = convertTimes(alice_2_converted.ElapsedTime, 0);

%% Plots
figure(1)
stackedplot(alice_1_converted, 'XVariable', "ElapsedTime");
xlim([alice_1_converted.ElapsedTime(1) alice_1_converted.ElapsedTime(length(alice_1_converted.ElapsedTime))]);
title("ECG Readings in Relaxed State vs. Time");

figure(2)
stackedplot(alice_2_converted, 'XVariable', "ElapsedTime");
xlim([alice_2_converted.ElapsedTime(1) alice_2_converted.ElapsedTime(length(alice_2_converted.ElapsedTime))]);
title("ECG Readings After Exercise vs. Time");

%% 6 Lead system
alice_1_new = alice_1_converted;
alice_1_new.aVR = -1.0 * (alice_1_converted.ECG1 + alice_1_converted.ECG2) / 2.0;
alice_1_new.aVL = (alice_1_converted.ECG1 - alice_1_converted.ECG3) / 2.0;
alice_1_new.aVF = (alice_1_converted.ECG2 + alice_1_converted.ECG3) / 2.0;

figure(3)
stackedplot(alice_1_new, 'XVariable', "ElapsedTime");
xlim([alice_1_new.ElapsedTime(1) alice_1_new.ElapsedTime(length(alice_1_new.ElapsedTime))]);
title("ECG Readings in Relaxed State (6 Lead) vs. Time");

%% CAI
figure(4)
sp = stackedplot(alice_1_new, ["ECG1", "aVF"], 'XVariable', "ElapsedTime");
xlim([alice_1_new.ElapsedTime(1) alice_1_new.ElapsedTime(length(alice_1_new.ElapsedTime))]);
sp.AxesProperties(1).YLimits = [-0.4 0.4];
sp.AxesProperties(2).YLimits = [-1 1.5];
title("ECG Readings in Relaxed State (6 Lead) vs. Time");

%% Functions
function converted = convertTimes(array, offset)
    [~,m,s] = hms(array);
    converted = m * 60 + s;

    if offset ~= 0
        converted = converted - offset;
    end
end