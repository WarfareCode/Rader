%ԭ���PW=10us,Ƶ�ʶ�����ΧΪ5%
%Ϊʹ����������ԣ������PW=80us��Ƶ�ʶ�����ΧΪ50%
clear all;
close all;
RF=3.3*1e7;%330MHz
PW=8*1e-5;%10us
K=.5;%Ƶ�ʶ����ٷֱ�
PRI0=4.3*1e-4;%430us
A=5;%��ȡ5��PRI
for m=1:A
    temp=rand(1,1);%����һ��0��1�������
    PRI(m)=PRI0*(1+K*temp);
end
PA=1;
T=0;
for m=1:A
    T=T+PRI(m);
end
per=PW/T;%ռ�ձ�
N=max(PRI)*RF;
DT=0;
yn=0;
t=linspace(0,5*T,20*N);
for m=1:A
    y=(1+square(2*pi*(t-DT)/T,100*per))/2;
    yn=yn+y;
    DT=DT+PRI(m);
end
x=(1+sin(1000*pi*RF*t))/2;
y=yn.*x;
plot(t,y);
title('��Ƶ�����ź�');
axis([0,2*T,-0.2,1.2]);
grid on