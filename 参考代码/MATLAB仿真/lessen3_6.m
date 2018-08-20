clear all;
close all;
RF=2.3*1e7;%230MHz
PW=8*1e-5;%80us
PRI0=4.3*1e-4;%430us
for m=1:6
    PRI(m)=PRI0+(m-1)*1e-4;%����PRI����
end
PA=1;
T=0;
for m=1:6
    T=T+PRI(m);
end
per=PW/T;%ռ�ձ�
N=max(PRI)*RF;
t=linspace(0,2*T,40*N);%ֻ���������ڵ��ź�
DT=0;
z=0;
for m=1:6
    y=(1+square(2*pi*(t-DT)/T,100*per))/2;
    DT=DT+PRI(m);
    z=z+y;
end
x=(1+sin(800*pi*RF*t))/2;
ym=z.*x;
plot(t,ym);
title('PRI�����ź�');
axis([0,2*T,-0.2,1.2]);
grid on;