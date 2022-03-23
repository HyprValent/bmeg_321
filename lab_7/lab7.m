%% Reading csv files
matt_1 = readtable("data\Matt-C_raw.csv");
matt_2 = readtable("data\Matt-C_2_raw.csv");
matt_3 = readtable("data\Matt-C_3_raw.csv");
matt_4 = readtable("data\Matt-C_4_raw.csv");

matt_1 = removevars(matt_1, "BioRadioEvent");
matt_2 = removevars(matt_2, "BioRadioEvent");
matt_3 = removevars(matt_3, "BioRadioEvent");
matt_4 = removevars(matt_4, "BioRadioEvent");

%% Convert time
matt_1_converted = matt_1;
matt_2_converted = matt_2;
matt_3_converted = matt_3;
matt_4_converted = matt_4;

matt_1_converted.ElapsedTime = convertTimes(matt_1_converted.ElapsedTime);
matt_2_converted.ElapsedTime = convertTimes(matt_2_converted.ElapsedTime);
matt_3_converted.ElapsedTime = convertTimes(matt_3_converted.ElapsedTime);
matt_4_converted.ElapsedTime = convertTimes(matt_4_converted.ElapsedTime);

%% Plots
figure(1)
plot(matt_1_converted.ElapsedTime, matt_1_converted.BloodPressureBP);
xlabel("Elapsed Time (s)");
ylabel("Pressure (mmHg)");
xlim([matt_1_converted.ElapsedTime(1) matt_1_converted.ElapsedTime(length(matt_1_converted.ElapsedTime))]);
title("Air Pressure vs. Time in Sphygmomanometer Cuff (Trial 1)");

figure(2)
plot(matt_2_converted.ElapsedTime, matt_2_converted.BloodPressureBP);
xlabel("Elapsed Time (s)");
ylabel("Pressure (mmHg)");
xlim([matt_2_converted.ElapsedTime(1) matt_2_converted.ElapsedTime(length(matt_2_converted.ElapsedTime))]);
title("Air Pressure vs. Time in Sphygmomanometer Cuff (Trial 2)");

figure(3)
plot(matt_3_converted.ElapsedTime, matt_3_converted.BloodPressureBP);
xlabel("Elapsed Time (s)");
ylabel("Pressure (mmHg)");
xlim([matt_3_converted.ElapsedTime(1) matt_3_converted.ElapsedTime(length(matt_3_converted.ElapsedTime))]);
title("Air Pressure vs. Time in Sphygmomanometer Cuff (Trial 3)");

figure(4)
plot(matt_4_converted.ElapsedTime, matt_4_converted.BloodPressureBP);
xlabel("Elapsed Time (s)");
ylabel("Pressure (mmHg)");
xlim([matt_4_converted.ElapsedTime(1) matt_4_converted.ElapsedTime(length(matt_4_converted.ElapsedTime))]);
title("Air Pressure vs. Time in Sphygmomanometer Cuff (Trial 4)");

%% Functions
function converted = convertTimes(array)
    [~,m,s] = hms(array);
    converted = m * 60 + s;
end