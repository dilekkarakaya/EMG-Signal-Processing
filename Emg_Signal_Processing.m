%% EMG SIGNAL PROCESSING
raw_data=load('deneme.txt');
data=zeros(length(raw_data),3);
time=zeros(length(raw_data),1);
time=raw_data(:,1)./1000;
L=length(data);
for i=1:L
    data(i,1)=((((raw_data(i,3)/2^16)-0.5)*3)/1000)*1000;
end
 
figure;
    subplot(3,1,1);
    plot(time,data(:,1));
    xlabel('Time(s)');
    ylabel('Voltage(mV)');  
    grid
    hold on
 sgtitle('Raw EMG');   
hold off
 %% FFT
fs=1000;
f=fs*(0:(L/2))/L;
figure;
p1=fft(data(:,1));
p1=abs(p1/L);
p1=p1(1:L/2+1);
p1(2:end-1)=2*p1(2:end-1);
subplot(3,1,1);
plot(f,p1);
 xlabel('Frequency(Hz)');
 ylabel('Intensity');
 grid
%% BP Filter
fnyq=fs/2;
fcuthigh=30;
fcutlow=300;
 
[b,a]=butter(4,[fcuthigh,fcutlow]/fnyq,'bandpass');
data(:,1)=filtfilt(b,a,data(:,1));
%% FULL WAVE 
rec_signal=zeros(length(data),3);
rec_signal(:,1)=abs(data(:,1));
figure;
    subplot(3,1,1);
    plot(time,rec_signal(:,1));
    xlabel('Time(s)');
    ylabel('Voltage(mV)'); 
    grid 
    hold on
    %% RMS ENVELOPE
    envelope=zeros(L,3);
    window=50;
    envelope(:,1)=sqrt(movmean((rec_signal(:,1).^2),window));
    %% NORMALISATION
    MVC =[1.4 1.49 1.3];
    
    MVC_normalised=zeros(L,3);
    
    MVC_normalised(:,1)=(envelope(:,1)./MVC(1,1)).*100;
    %% Plotting Normalised Enveelope Against Rectified Signal
    lim1=5;
    lim2=10;
    figure;
    subplot(3,1,1);
    plot(time,rec_signal(:,1));
    hold on
    
    plot(time,envelope(:,1),'r','linewidth',2);
    xlim([lim1 lim2]);
    
    xlabel('Time (s)');
    ylabel('Voltage(mV)');
    grid
    


