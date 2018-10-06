%Original algorithm based on PRI transform applies to interleaved pulse
%train with PRI jitter.Mean PRIs are 1,sqrt(2) and sqrt(5),and jitter
%follows uniform distribution with width 2a 
clear all
clf
clc
N=1000;
t1=0:333;
t2=0.1:sqrt(2):(0.1+332*sqrt(2));
t3=0.2:sqrt(5):(0.2+332*sqrt(5));
t=[t1 t2 t3];
clear t1 t2 t3
a=0.1;                                               %���ö����̶�
jitter=(1-2*rand(1,1000))*a;
t=t+jitter;                                          %Ϊÿ�������TOA���������
t=sort(t);
%���ϳ����������ɽ����������е���ʱ�䣬�������������������״����
K=201;
taumin=0;
taumax=10;
b=(taumax-taumin)/K;
D=zeros(1,K);                                         %��ʼ��D(k)
for i=1:K
    tauk(i)=(i-1/2)*(taumax-taumin)/K+taumin;
end
n=2;
while n<=N
    m=n-1;
    while m>=1
        tau=t(n)-t(m);
        if (tau>taumin)&(tau<=taumax)
            for k=1:K                                 %ѡ��k������PRI�任
                if (tau>(tauk(k)-b/2))&(tau<=(tauk(k)+b/2))  
                    D(k)=D(k)+exp(2*pi*t(n)*j/tau);
                end
            end
        elseif tau>taumax
            break
        else 
            ;
        end
        m=m-1;
    end
    n=n+1;
end
plot(tauk,abs(D)) 
axis([0 10 0 800])