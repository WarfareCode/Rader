% improved algorithm for estimating PRIs applies to interleaved pulse
% trains  with PRI jitter.
clear all
clf
clc
N=1000;
%�����״��toa
t1=0:333;                         
t2=0.1:sqrt(2):(0.1+332*sqrt(2));
t3=0.2:sqrt(5):(0.2+332*sqrt(5));
toa=[t1 t2 t3];
clear t1 t2 t3
a=0.1;                                      %���ö����̶�
jitter=(1-2*rand(1,1000))*a;
toa=toa+jitter;                             %Ϊÿ�������TOA���������
toa=sort(toa);                              %����
K=201;
taumin=0;
taumax=10;
epsilon=a;                                  %epsilonΪPRI��������(=a)
zetazero=0.03;
O=zeros(1,K);
D=zeros(1,K);                               %��ʼ��D(k)
C=zeros(1,K);
A=zeros(1,K);                               %��ʼ�����޺���
for i=1:K                                   %PRI�����ģ���֤��־
    tauk(i)=(i-1/2)*(taumax-taumin)/K+taumin;
    flag(i)=1;
end
bk=2*epsilon*tauk;                          %��k��PRI bin��width
n=2;
while n<=N
    m=n-1;
    while m>=1
        tau=toa(n)-toa(m);
        if (tau>(1-epsilon)*taumin)&(tau<=(1+epsilon)*taumax)                 %��tauֵ�����PRI��ķ�Χ
            k1=fix((tau/(1+epsilon)-taumin)*K/(taumax-taumin)+1);
            k2=fix((tau/(1-epsilon)-taumin)*K/(taumax-taumin)+1);
            if k2>201
                break
            end
            for k=k1:k2
                if flag(k)==1                                                  %����k��PRI���Ƿ��һ��ʹ��
                    O(k)=toa(n);
                end
                etazero=(toa(n)-O(k))/tauk(k);                                 %�����ʼ��λ���ֽ� 
                nu=etazero+0.4999999;
                zeta=etazero/nu-1;
                nu=fix(nu);
                if ((nu==1)&(toa(m)==O(k)))|((nu>=2)&(abs(zeta)<=zetazero))    %ȷ���Ƿ���Ҫ�ƶ�ʱ�����
                    O(k)=toa(n);
                end
                eta=(toa(n)-O(k))/tauk(k);                      %������λ 
                D(k)=D(k)+exp(2*pi*j*eta);                      %����PRI�任
                C(k)=C(k)+1;
                flag(k)=0;                                      %����ʹ�ù���PRI�����־    
            end
        elseif tau>taumax*(1+epsilon)
            break
        else
            ;
        end
        m=m-1;
    end
    n=n+1;
end
D=abs(D);
plot(tauk,D)
axis([0 10 0 800])
hold on         
X=[225./tauk;0.15*C;4*sqrt(N*N*bk/750)]; 
A=max(X);                                                      %���޺���
plot(tauk,A,'r-')
xlabel('tauk')
ylabel('|D(k)|')
i=1;
for k=1:K
    if D(k)>A(k)
        p(i)=tauk(k);
        i=i+1;
    end
end
p=sort(p);                                                     %��ֵ���������������䣬�õ�����PRI 



         
                