clear all;
close all;
RF=2.3*1e7;%230MHz
PW1=1.5*1e-4;%150us
PW2=8*1e-5;%80us
PRI=4.3*1e-4;%430us
dt=4*1e-5;%������Ϊ40us
K=2;%ÿ��PRI�ڷ���K������
PA=1;
T=PRI;
per1=PW1/T;%ռ�ձ�
per2=PW2/T;%ռ�ձ�
N=PRI*RF;
t=linspace(0,2*T,40*N);%ֻ���������ڵ��ź�
y1=(1+square(2*pi*t/T,100*per1))/2;%��һ������
y2=(1+square(2*pi*(t-dt-PW1)/T,100*per2))/2;%�ڶ�������
y3=(1+square(2*pi*(t-dt-PW1)/T,100*per1))/2;%��һ������
yn1=y1+y2;%���ȿ������
yn2=y3+y1;%�ȿ������
x=(1+sin(8000*pi*RF*t))/2;
ym1=yn1.*x;%���ȿ������
ym2=yn2.*x;%�ȿ������
subplot(211);
plot(t,ym1);
title('���ȼ��˫�����ź�');
axis([0,2*T,-0.2,1.2]);
grid on;
subplot(212);
plot(t,ym2);
title('�ȼ��˫�����ź�');
axis([0,2*T,-0.2,1.2]);