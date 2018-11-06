%% DDC
clear ; close all; clc;

% parameter
f0      =   20e+6;      % 20MHz��Ƶ 
B       =   2e+6;       % 2MHz����
Tao     =   150e-6;     % 200usʱ��
T       =   2e-3;       % 2ms�����ظ����� 
fs      =   15e+6;      % 15MHz����Ƶ��
SNR     =   20;         % �����20dB
dis     =   T*fs/2;     % ��Ŀ�������ڻز��м䴦

% Generate LFM @f0
t = -round(Tao*fs/2):1:round(Tao*fs/2)-1; % ��������� 
median_fre = (10^(SNR/20))* (cos(pi*B/Tao*(t/fs).^2 ).*cos(2*pi*f0*t/fs) - sin(pi*B/Tao*(t/fs).^2 ).*sin(2*pi*f0*t/fs));   % I*cos + Q*sin

figure;
plot(median_fre); title('���е��ƺ�����Ե�Ƶ�ź�');

% Generate echo
echo  = zeros(1,T*fs);
echo(dis:1:dis+Tao*fs-1) = median_fre;
noise = normrnd(0,1,1,T*fs);
% noise = 0.5*ones(1,T*fs);
echo = echo + noise;

figure;plot(echo); title('�ز��ź�');  % ʵ�ʵĻز��źţ�ֻ��ʵ��

% frequence mixing
echo = echo.*exp(-1i*2*pi*f0*(0:1:T*fs-1)/fs);

figure;
subplot(2,1,1); plot(real(echo),'b'); title('��Ƶ��ز��ź�ʵ��');
subplot(2,1,2); plot(imag(echo),'r'); title('��Ƶ��ز��ź��鲿');

figure; plot(abs(fftshift(fft(echo)))); title('��Ƶ��ز��ź�Ƶ��');
% Generate low pass filter coeff
coeff = fir1(127,B/(fs/2),hamming(128)); % 0.4 = B/(fs/2)
figure;freqz(coeff);

% fir filter
ddc_res = conv(echo,coeff);

figure;
subplot(2,1,1); plot(real(ddc_res),'b'); title('��ͨ�˲���ز��ź�ʵ��');
subplot(2,1,2); plot(imag(ddc_res),'r'); title('��ͨ�˲���ز��ź��鲿');
