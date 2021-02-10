FFTLength = 64;
% Modulator
Mod = comm.OFDMModulator(...
        'FFTLength' ,           FFTLength,...
        'NumGuardBandCarriers', [6;5],...
        'CyclicPrefixLength',   0,...
        'NumSymbols', 2,...
        'InsertDCNull', true);
% Demodulator
Demod = comm.OFDMDemodulator(Mod);