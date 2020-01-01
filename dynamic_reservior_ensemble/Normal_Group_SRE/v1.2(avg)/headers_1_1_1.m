% header infos for controller learning

%%%%%%% createEmptyFigs
%%%%%%% generateNetold
netDim = 100; connectivity = 0.1; inputLength = 75; outputLength = 2;
%%%%%%% generateTrainTestData
samplelength = 1200;
%%%%%%% learnAndTest
specRad = 0.8; ofbSC = [1,1]; noiselevel = 0.0000; 
linearOutputUnits = 0; linearNetwork = 0; WienerHopf = 0; 
initialRunlength = 100; sampleRunlength = 1000; freeRunlength = 0; plotRunlength = 100;
inputscaling = ones(inputLength,1); inputshift = zeros(inputLength,1);
teacherscaling = ones(outputLength,1); teachershift = zeros(outputLength,1);
