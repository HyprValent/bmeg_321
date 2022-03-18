%% Reading csv files
deep_raw = readtable(".\lab6PA\deep.csv");
norm_raw = readtable(".\lab6PA\norm.csv");
nothing_raw = readtable(".\lab6PA\nothing.csv");

deep_raw = removevars(deep_raw, "BioRadioEvent");
norm_raw = removevars(norm_raw, "BioRadioEvent");
nothing_raw = removevars(nothing_raw, "BioRadioEvent");

%% Normalize data from offset
deep_raw.FlowRateSPIRO = normalize(deep_raw.FlowRateSPIRO);
norm_raw.FlowRateSPIRO = normalize(norm_raw.FlowRateSPIRO);
nothing_raw.FlowRateSPIRO = normalize(nothing_raw.FlowRateSPIRO);

%% Changing elapsed time to seconds
deep_raw_converted = deep_raw;
nothing_raw_converted = nothing_raw;
norm_raw_converted = norm_raw;

deep_raw_converted.ElapsedTime = convertTimes(deep_raw.ElapsedTime);
norm_raw_converted.ElapsedTime = convertTimes(norm_raw.ElapsedTime);
nothing_raw_converted.ElapsedTime = convertTimes(nothing_raw.ElapsedTime);

%% Plots
figure(1)
plot(deep_raw_converted.ElapsedTime, deep_raw.FlowRateSPIRO);
xlabel("Elapsed Time (s)");
ylabel("Flow Rate (L/s)");
xlim([deep_raw_converted.ElapsedTime(1) deep_raw_converted.ElapsedTime(length(deep_raw_converted.ElapsedTime))]);
title("Normalized Flow Rate vs. Time for 'Deep' Data");

figure(2)
plot(norm_raw_converted.ElapsedTime, norm_raw.FlowRateSPIRO);
xlabel("Elapsed Time (s)");
ylabel("Flow Rate (L/s)");
xlim([norm_raw_converted.ElapsedTime(1) norm_raw_converted.ElapsedTime(length(norm_raw_converted.ElapsedTime))]);
title("Normalized Flow Rate vs. Time for 'Norm' Data");

figure(3)
plot(nothing_raw_converted.ElapsedTime, nothing_raw.FlowRateSPIRO);
xlabel("Elapsed Time (s)");
ylabel("Flow Rate (L/s)");
xlim([nothing_raw_converted.ElapsedTime(1) nothing_raw_converted.ElapsedTime(length(nothing_raw_converted.ElapsedTime))]);
title("Normalized Flow Rate vs. Time for 'Nothing' Data");

%% Calculating integral
deep_int = findIntegral(deep_raw_converted.ElapsedTime, deep_raw.FlowRateSPIRO, 3.632, 6.448);
norm_int = findIntegral(norm_raw_converted.ElapsedTime, norm_raw.FlowRateSPIRO, 2.184, 3.992);

% norm_int = trapz(norm_raw_converted.ElapsedTime, norm_raw.FlowRateSPIRO);
% nothing_int = trapz(nothing_raw_converted.ElapsedTime, nothing_raw.FlowRateSPIRO);

%% Functions
function converted = convertTimes(array)
    [~,m,s] = hms(array);
    converted = m * 60 + s;
end

function integral = findIntegral(arrayTime, arrayValues, tmin, tmax)
    temp = cumtrapz(arrayTime, arrayValues);
    minIndex = arrayTime == tmin;
    maxIndex = arrayTime == tmax;
    integral = temp(maxIndex) - temp(minIndex);
end