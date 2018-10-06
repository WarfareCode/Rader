clear; 
clc; 
close all; 
 
% �״��źŷ�ѡ�������ݲ��� 
% �Ĳ��״� 
% վ����� 100km 
% author: xiacx 
% 2008-3-10 
 
% ����վ���źŷ���Դλ�� 
aStation = [50e3 0 0]'; % x���� 
bStation = [-50e3 0 0]'; 
xCoordinate = random('unif',0,7e3,1,4);    % 4���״��x������ 
yCoordinate = random('unif',0,4e3,1,4); 
zCoordinate = random('unif',0,4e3,1,4); 
radarCoordinate = [xCoordinate;yCoordinate;zCoordinate];   % �þ����ʾ�Ĳ��״� 
 
c = 3e8;  % ���� 
aDelay(1) = norm(aStation-radarCoordinate(:,1))/c;    % Ŀ��1��aվ�Ĵ���ʱ�� 
aDelay(2) = norm(aStation-radarCoordinate(:,2))/c; 
aDelay(3) = norm(aStation-radarCoordinate(:,3))/c; 
aDelay(4) = norm(aStation-radarCoordinate(:,4))/c; 
 
bDelay(1) = norm(bStation-radarCoordinate(:,1))/c;    % Ŀ��1��bվ�Ĵ���ʱ�� 
bDelay(2) = norm(bStation-radarCoordinate(:,2))/c; 
bDelay(3) = norm(bStation-radarCoordinate(:,3))/c; 
bDelay(4) = norm(bStation-radarCoordinate(:,4))/c; 
 
% �Ĳ��״�ķ���ʱ�䲻һ����ͬ 
% ���ڻ���ֻ��100km�����ʱ��Ϊ330us����ô��Ƶ���30kʱ��ǡ����������Ϊ10us 
% ʵ�����źŵ� ʱ�� ��С��10us�� 
% �����Ĳ��״��źŵ���aվ���ź���10us�ھ��ȷֲ� 
% �ɵ���aվ��ʱ����ȥ�����źŷ���ʱ�̣��Ӷ��õ�����bվ��ʱ�� 
aToa(1) = random('unif',0,10e-6,1,1); 
aToa(2) = random('unif',0,30e-6,1,1); 
aToa(3) = random('unif',0,60e-6,1,1); 
aToa(4) = random('unif',0,80e-6,1,1); 
% �źŷ������ʱ�� 
radarTime = aToa- aDelay; 
% bվ����ʱ��ļ��� 
bToa = radarTime + bDelay;

% ������100M 
fs = 100e6; 
 
% �ظ����� 
% �����޸ĵĲ��� 
pir = [100,1e3,10e3,100e3];  % �״��ź��ظ�Ƶ�� 
pit = 1./pir;   
pw = [15e-6,15e-6,8e-6,0.8e-6];  % ���� 
pf = random('unif',23e6+20000,37e6-20000,1,4);  % ��Ƶ 


% �ź��������ȡ���Ƶ����������� 
% ���������������ݵõ���ͳһ��һ��������� 
% ��Ƶ��15M�����ڸ�һ������� 
%-------------------- 
k = fix(0.1/pit(1));      % 0.1s���� 
for i = 1 : k 
    aToaRadar1(i) = (i-1)*pit(1)+aToa(1);    %�����������ڣ�����ÿ������ĵ���ʱ�� 
    bToaRadar1(i) = (i-1)*pit(1)+bToa(1); 
    pwRadar1(i) = pw(1);     %ÿ�����������Ӧ���������Ƶ 
    pfRadar1(i) = pf(1); 
end 
k = fix(0.1/pit(2)); 
for i = 1 : k 
    aToaRadar2(i) = (i-1)*pit(2)+aToa(2); 
    bToaRadar2(i) = (i-1)*pit(2)+bToa(2); 
    if k>30 & k<=60                     % ���ֲβ�Ƶ�ʣ��ظ����ڸı��� 
        aToaRadar2(i) = (i-1)*1/1100+aToa(3); 
        bToaRadar2(i) = (i-1)*1/1100+bToa(3); 
    end 
    pwRadar2(i) = pw(2); 
    pfRadar2(i) = pf(2); 
end 
k = fix(0.1/pit(3)); 
for i = 1 : k 
    aToaRadar3(i) = (i-1)*pit(3)+aToa(3); 
    bToaRadar3(i) = (i-1)*pit(3)+bToa(3); 
    pwRadar3(i) = pw(3); 
    pfRadar3(i) = pf(3); 
end 
k = fix(0.1/pit(4)); 
for i = 1 : k 
    aToaRadar4(i) = (i-1)*pit(4)+aToa(4); 
    bToaRadar4(i) = (i-1)*pit(4)+bToa(4); 
    pwRadar4(i) = pw(4); 
    pfRadar4(i) = pf(4); 
end 
%--------------------------- 
 
lenRadar1 = length(aToaRadar1);   % ÿ���״��յ����ٸ����� 
lenRadar2 = length(aToaRadar2); 
lenRadar3 = length(aToaRadar3); 
lenRadar4 = length(aToaRadar4); 
 
% �����￼������Ķ�ʧ 
aLostIndex = fix(random('unif',1,lenRadar1,1,fix(lenRadar1/10))); 
bLostIndex = fix(random('unif',1,lenRadar1,1,fix(lenRadar1/10))); 
aToaRadar1(aLostIndex) = []; 
bToaRadar1(bLostIndex) = []; 
aLostNum1 = lenRadar1 - length(aToaRadar1); 
bLostNum1 = lenRadar1 - length(bToaRadar1); 
 
aLostIndex = fix(random('unif',1,lenRadar2,1,fix(lenRadar2/10))); 
bLostIndex = fix(random('unif',1,lenRadar2,1,fix(lenRadar2/10))); 
aToaRadar2(aLostIndex) = []; 
bToaRadar2(bLostIndex) = []; 
aLostNum2 = lenRadar2 - length(aToaRadar2); 
bLostNum2 = lenRadar2 - length(bToaRadar2); 
 
aLostIndex = fix(random('unif',1,lenRadar3,1,fix(lenRadar3/10))); 
bLostIndex = fix(random('unif',1,lenRadar3,1,fix(lenRadar3/10))); 
aToaRadar3(aLostIndex) = []; 
bToaRadar3(bLostIndex) = []; 
aLostNum3 = lenRadar3 - length(aToaRadar3); 
bLostNum3 = lenRadar3 - length(bToaRadar3); 
 
aLostIndex = fix(random('unif',1,lenRadar4,1,fix(lenRadar4/10))); 
bLostIndex = fix(random('unif',1,lenRadar4,1,fix(lenRadar4/10))); 
aToaRadar4(aLostIndex) = []; 
bToaRadar4(bLostIndex) = []; 
aLostNum4 = lenRadar4 - length(aToaRadar4); 
bLostNum4 = lenRadar4 - length(bToaRadar4); 
 
 
% ��Ҫһ�����򣬸��ݵ���ʱ�� 
aToaRadar = [aToaRadar1,aToaRadar2,aToaRadar3,aToaRadar4]; 
bToaRadar = [bToaRadar1,bToaRadar2,bToaRadar3,bToaRadar4]; 
pwRadar = [pwRadar1,pwRadar2,pwRadar3,pwRadar4]; 
pfRadar = [pfRadar1,pfRadar2,pfRadar3,pfRadar4]; 
 
 
 
[aToaRadar,index] = sort(aToaRadar);   % ���ݽ��յ�ʱ��˳�򣬶������״��������� 
for i = 1 : length(index) 
    tempPw(i) = pwRadar(index(i)); 
    tempPf(i) = pfRadar(index(i)); 
end 
aPwRadar = tempPw; 
aPfRadar = tempPf; 
 
[bToaRadar,index] = sort(bToaRadar); 
for i = 1 : length(index) 
    tempPw(i) = pwRadar(index(i)); 
    tempPf(i) = pfRadar(index(i)); 
end 
bPwRadar = tempPw; 
bPfRadar = tempPf; 
 
% ������ʱ�����һ��������� 100ns 
% ���������һ��������� 140ns 
% ����Ƶ����һ���������  2000Hz 
aDataLen = length(aToaRadar);   % �����״�����������ܺ� 
bDataLen = length(bToaRadar); 
% ����ʱ�������� 
aToaRadar = aToaRadar + random('norm',0,10e-6,1,aDataLen); 
bToaRadar = bToaRadar + random('norm',0,10e-6,1,bDataLen); 
 
% Ϊ��֤����ʱ�䲻Ϊ��ֵ����ͳһ��һ��ʱ�� 
timeStart = min([aToaRadar,bToaRadar]); 
aToaRadar = aToaRadar + abs(timeStart); 
bToaRadar = bToaRadar + abs(timeStart); 
 
% ����ʱ��ת��Ϊ����������100M������ 
aToaRadar = fix(aToaRadar*100e6); 
bToaRadar = fix(bToaRadar*100e6); 
 
% ���������� 
aPwRadar = aPwRadar + random('norm',0,10e-6,1,aDataLen); 
bPwRadar = bPwRadar + random('norm',0,10e-6,1,bDataLen); 
aPwRadar = fix(aPwRadar*100e6); 
bPwRadar = fix(bPwRadar*100e6); 
% ��Ƶ������� 
aPfRadar = aPfRadar + random('norm',0,2000,1,aDataLen); 
bPfRadar = bPfRadar + random('norm',0,2000,1,bDataLen); 
 
% ���� 
aPaRadar = random('unif',3988,7440,1,aDataLen); 
bPaRadar = random('unif',3988,7440,1,bDataLen); 
 
 
 
fid = fopen('aStation2.txt','w'); 
fprintf(fid,'��⵽%d�����壺toa,pw�Ե�ǰ��������\r\n',aDataLen);%%%%%%%% 
for i = 1:aDataLen 
     aDoa(i)=random('unif',110,120,1,1);
    fprintf(fid,'  %3d    %7.2f   %7.2f    %6.3f    %7.3f    %7.4f\r\n',i,aToaRadar(i),aPwRadar(i),aPaRadar(i),aPfRadar(i)/1000000,aDoa(i)); 
end 
status = fclose(fid); 
 
fid = fopen('bStation2.txt','w'); 
fprintf(fid,'��⵽%d�����壺toa,pw�Ե�ǰ��������\r\n',bDataLen); 
for i = 1:bDataLen 
    bDoa(i)=random('unif',110,120,1,1);
    fprintf(fid,'%3d   %7.2f  %7.2f %6.3f  %7.3f  %7.4f\r\n',i,bToaRadar(i),bPwRadar(i),bPaRadar(i),bPfRadar(i)/1000000,bDoa(i)); 
end 
status = fclose(fid); 
 
fid = fopen('parameter2.txt','w'); 
fprintf(fid,'����ʱ��Ϊ�ֱ�Ϊ��dt1=%7.2f,dt2=%7.2f,dt3=%7.2f,dt4=%7.2f\r\n',... 
    (aToa(1)-bToa(1))*100e6,(aToa(2)-bToa(2))*100e6,(aToa(3)-bToa(3))*100e6,(aToa(4)-bToa(4))*100e6); 
fprintf(fid,'aվ���峤�ȷֱ�Ϊ��dt1=%5d,dt2=%5d,dt3=%5d,dt4=%5d\r\n',... 
    lenRadar1-aLostNum1,lenRadar2-aLostNum2,lenRadar3-aLostNum3,lenRadar4-aLostNum4); 
fprintf(fid,'bվ���峤�ȷֱ�Ϊ��dt1=%5d,dt2=%5d,dt3=%5d,dt4=%5d\r\n',... 
    lenRadar1-bLostNum1,lenRadar2-bLostNum2,lenRadar3-bLostNum3,lenRadar4-bLostNum4); 
status = fclose(fid); 
clc; 
clear; 
disp('yuanzhishu'); 
 
