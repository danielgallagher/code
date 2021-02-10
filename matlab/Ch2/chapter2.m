%----------------------------------------------------------------------
% Chapter 2
% "Digital Communication Systems Engineering Using Software Defined Radio
% MATLAB Scripts
%----------------------------------------------------------------------


% Clear workspace
clear all;


% Specify plot parameters
txtsize=10;
ltxtsize=9;
pwidth=4;
pheight=4;
pxoffset=0.65;
pyoffset=0.5;
markersize=5;

figNum = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Understanding Sampling Rate Conversion

% Create deterministic and stochastic digital data streams
n = 0:1:99; % Time index vector consisting of 100 time instances
x_sin = sin(2*pi*n); % Generation of sinusoidal signal
x_bern = 2*round(rand(1,length(n)))-1; % Random string of +1 and -1 values based on Bernoulli RV

% Create lowpass filter and apply it to both data streams
coeffs1 = firls(30,[0 0.2 0.22 1],[1 1 0 0]); % FIR filter coefficients
y_sin = filter(coeffs1,1,x_sin);
y_bern = filter(coeffs1,1,x_bern);

% Visualize time and frequency responses of filtered data sources
% Filtered sinusoidal signal
figure(figNum); figNum = figNum+1;
stem(0:1:(length(y_sin)-1),y_sin);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title('Original Filtered Sinusoidal Signal');
figure(figNum); figNum = figNum+1;
plot((0:1:(length(y_sin)-1))/(0.5*length(y_sin)),abs(fft(y_sin,length(y_sin))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title('Original Filtered Sinusoidal Signal');



% Filtered random sequence
figure(figNum); figNum = figNum+1;
stem(0:1:(length(y_bern)-1),y_bern);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title('Original Filtered Random Binary Sequence');
figure(figNum); figNum = figNum+1;
plot((0:1:(length(y_bern)-1))/(0.5*length(y_bern)),abs(fft(y_bern,length(y_bern))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title('Original Filtered Random Binary Sequence');


% Upsample both digital signals by a factor of N + plot them in frequency (compare with original)
N = 5;
y_sin_up = upsample(y_sin,N);
y_bern_up = upsample(y_bern,N);
figure(figNum); figNum = figNum+1;
plot((0:1:(length(y_sin)-1))/(0.5*length(y_sin)),abs(fft(y_sin,length(y_sin))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title('Original Filtered Sinusoidal Signal');
figure(figNum); figNum = figNum+1;
plot((0:1:(length(y_sin_up)-1))/(0.5*length(y_sin_up)),abs(fft(y_sin_up,length(y_sin_up))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Upsampled ({}\\times{%d}) Filtered Sinusoidal Signal',N));

figure(figNum); figNum = figNum+1;
plot((0:1:(length(y_bern)-1))/(0.5*length(y_bern)),abs(fft(y_bern,length(y_bern))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title('Original Filtered Random Binary Sequence');
figure(figNum); figNum = figNum+1;
plot((0:1:(length(y_bern_up)-1))/(0.5*length(y_bern_up)),abs(fft(y_bern_up,length(y_bern_up))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Upsampled ({}\\times{%d}) Filtered Random Binary Sequence',N));

% Downsampling by M without filtering (bad things happen)
M = 3;
y_sin_up_down1 = downsample(y_sin_up,M);
y_bern_up_down1 = downsample(y_bern_up,M);

% Lowpass filtering of baseband periodic replica followed by downsampling (correct
% approach)
coeffs2 = firls(30,[0 0.17 0.18 1],[1 1 0 0]); % FIR filter coefficients
y_sin_up_down2 = downsample(filter(coeffs2,1,y_sin_up),M);
y_bern_up_down2 = downsample(filter(coeffs2,1,y_bern_up),M);

% Comparing frequency responses of correct and incorrect downsampling
figure(figNum); figNum = figNum+1;


plot((0:1:(length(y_sin_up_down1)-1))/(0.5*length(y_sin_up_down1)),abs(fft(y_sin_up_down1,length(y_sin_up_down1))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Improperly Downsampled ({}\\times{%d}) of Upsampled ({}\\times{%d}) Filtered Sinusoidal Signal',M,N));



figure(figNum); figNum = figNum+1;


plot((0:1:(length(y_sin_up_down2)-1))/(0.5*length(y_sin_up_down2)),abs(fft(y_sin_up_down2,length(y_sin_up_down2))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Properly Downsamples ({}\\times{%d}) of Upsampled ({}\\times{%d}) Filtered Sinusoidal Signal',M,N));




figure(figNum); figNum = figNum+1;


plot((0:1:(length(y_bern_up_down1)-1))/(0.5*length(y_bern_up_down1)),abs(fft(y_bern_up_down1,length(y_bern_up_down1))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Improperly Downsampled ({}\\times{%d}) of Upsampled ({}\\times{%d}) Filtered Random Binary Sequence',M,N));



figure(figNum); figNum = figNum+1;


plot((0:1:(length(y_bern_up_down2)-1))/(0.5*length(y_bern_up_down2)),abs(fft(y_bern_up_down2,length(y_bern_up_down2))));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Properly Downsampled ({}\\times{%d}) of Upsampled ({}\\times{%d}) Filtered Random Binary Sequence',M,N));




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pulse Shaping

% Create impulse train of period L and length len with random +/- one
% values
L = 10;
impulse_num = 10; % Total number of impulses in impulse train
len = L*impulse_num;
temp1 = [2*round(rand(impulse_num,1))-1 zeros(impulse_num,L-1)];
x_impulse = reshape(temp1.',[1,L*impulse_num]);

% Create two transmit filter pulse shapes of order L
txfilt1 = firls(L,[0 0.24 0.25 1],[1 1 0 0]); % Approximate rectangular frequency response --> approximate sinc(x) impulse response
txfilt2 = firls(L,[0 0.5 0.52 1],[1 0 0 0]); % Approximate triangular frequency response --> approximate sinc(x)^2 impulse response

% Pulse shape impulse train
y_impulse1 = filter(txfilt1,1,x_impulse);
y_impulse2 = filter(txfilt2,1,x_impulse);

% Plot resulting pulse shaped impulse train
figure(figNum); figNum = figNum+1;


stem(0:1:(length(y_impulse1)-1),y_impulse1);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title('Pulse Shaped Impulse Train Using txfilt1 coefficients');



figure(figNum); figNum = figNum+1;


stem(0:1:(length(y_impulse2)-1),y_impulse2);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title('Pulse Shaped Impulse Train Using txfilt2 coefficients');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eye Diagrams

% Taking pulse shaped impulse trains from before, let us observe their eye
% diagrams
eyediagram(y_impulse1,L,L,floor(L/2));  % Note that we need an offset of 15 since the FIR pulse shaping filter has a group delay of 15





eyediagram(y_impulse2,L,L,floor(L/2));






% Now let us introduce some Gaussian noise (std dev = 0.025) to affect the "eye"
eyediagram((y_impulse1+0.025*randn(1,length(y_impulse1))),L,L,floor(L/2));





eyediagram((y_impulse2+0.025*randn(1,length(y_impulse2))),L,L,floor(L/2));






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nyquist Pulse Shapes (Raised Cosine)

% Let us generate several types of raised cosine and root raised cosine
% filters of different roll-off factors
rcos_Fd = 1;
rcos_Fs = L;
ro1 = 0.5;
ro2 = 0.25;
[rcos1_num,rcos1_den] = rcosine(rcos_Fd, rcos_Fs, 'fir', ro1);
[rcos2_num,rcos2_den] = rcosine(rcos_Fd, rcos_Fs, 'fir', ro2);
[rrcos1_num,rrcos1_den] = rcosine(rcos_Fd, rcos_Fs, 'sqrt', ro1);
[rrcos2_num,rrcos2_den] = rcosine(rcos_Fd, rcos_Fs, 'sqrt', ro2);

% Plot time and frequency responses
figure(figNum); figNum = figNum+1;


stem(0:1:(length(rcos1_num)-1),rcos1_num);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title(sprintf('Raised Cosine Filter (Roll Off = %d) - Impulse Response',ro1));



figure(figNum); figNum = figNum+1;


plot(abs(fft(rcos1_num,4096)));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Raised Cosine Filter (Roll Off = %d) - Frequency Response',ro1));




figure(figNum); figNum = figNum+1;


stem(0:1:(length(rcos2_num)-1),rcos2_num);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title(sprintf('Raised Cosine Filter (Roll Off = %d) - Impulse Response',ro2));



figure(figNum); figNum = figNum+1;


plot(abs(fft(rcos2_num,4096)));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Raised Cosine Filter (Roll Off = %d) - Frequency Response',ro2));




figure(figNum); figNum = figNum+1;


stem(0:1:(length(rrcos1_num)-1),rrcos1_num);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title(sprintf('Square-Root Raised Cosine Filter (Roll Off = %d) - Impulse Response',ro1));



figure(figNum); figNum = figNum+1;


plot(abs(fft(rrcos1_num,4096)));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Square-Root Raised Cosine Filter (Roll Off = %d) - Frequency Response',ro1));




figure(figNum); figNum = figNum+1;


stem(0:1:(length(rrcos2_num)-1),rrcos2_num);xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title(sprintf('Square-Root Raised Cosine Filter (Roll Off = %d) - Impulse Response',ro2));



figure(figNum); figNum = figNum+1;


plot(abs(fft(rrcos2_num,4096)));xlabel('Frequency ({}\times{\pi})');ylabel({'Power Spectral';'Density'});
%title(sprintf('Square-Root Raised Cosine Filter (Roll Off = %d) - Frequency Response',ro2));




% Show how impulse train is affected by these filters --> Raised Cosine is
% Nyquist but Square-Root Raised Cosine is not
y_rcostx = conv(rcos1_num,x_impulse);
y_rrcostx = conv(rrcos1_num,x_impulse);
y_rrcostxrx = conv(rrcos1_num,y_rrcostx);
figure(figNum); figNum = figNum+1;


stem(y_rcostx((length(rcos1_num)/2):L:((length(rcos1_num)/2)+L*impulse_num)));xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title('Raised Cosine Filtering at Transmitter Only');



figure(figNum); figNum = figNum+1;


stem(y_rrcostx((length(rrcos1_num)/2):L:((length(rrcos1_num)/2)+L*impulse_num)));xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title('Root Raised Cosine Filtering at Transmitter Only');



figure(figNum); figNum = figNum+1;


stem(y_rrcostxrx((length(rrcos1_num)):L:((length(rrcos1_num))+L*impulse_num)));xlabel('Discrete Time (n)');ylabel('Signal Amplitude');
%title('Root Raised Cosine Filtering at Transmitter and Receiver');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tx/Rx Filters

% Create communications channel with some simple intersymbol interference
h_simple_isi = [1 0.15 0.05 0.001];

% Plot how this channel affects impulse train signal using eye diagram
y_impulse_isi = filter(h_simple_isi,1,x_impulse);
eyediagram(y_impulse_isi,L,L,0);






% Filter signal with inverse impulse response of channel and plot eye
% diagram (put h_simple_isi as denominator instead of numerator to cancel out ISI)
y_impulse_anti_isi = filter(1,h_simple_isi,y_impulse_isi);
eyediagram(y_impulse_anti_isi,L,L,0);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Eye Diagram
eyeDiagram;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% END OF CHAPTER 2 EXAMPLES %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
