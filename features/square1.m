clear
clc
wt=audioread('D:\SYNPATIC\RESEARCH\WAV\Joy_50.wav');
classif=audioread('D:\SYNPATIC\RESEARCH\WAV\Negative_50.wav');
t1=size(wt) % размерность исходного вектора
t1c=size(classif); % размерность классифицируемого сигнала

%строим фазовый портрет
step=1;
A=zeros(1,t1(1));
B=zeros(1,t1(1));
for i=1:step:t1(1)-step
    A(1,i)=wt(i,1);
    B(1,i)=wt(i+step,1); % вторая координата точки (формируется сдвигом на величину шага)
end
%comet(A,B) % визуализация
%plot(A,B)
%set(gca, 'Visible', 'off');
%saveas(gcf, 'D:\SYNPATIC\RESEARCH\Portrets\Time\Neutral\image.bmp')

% вычисляем геометрический центр фазового портрета
Xc=0;
Yc=0;
for i=1:(t1(1)-1)
    Xc=Xc+wt(i);
    Yc=Yc+wt(i+1);
end
Xc=Xc/(t1(1)-1) % координата Х геометрического центра 
Yc=Yc/(t1(1)-1) % координата Y геометрического центра
% сейчас оценим симметрию по вертикали и горизонтали
round(Xc)
round(Yc)
%сформируем вектора X и Y с абсциссами и ординатами фазового портрета
for i=1:(t1(1)-1)
    X(i)=wt(i); % абсцисса
    Y(i)=wt(i+1); % ордината
end
% теперь найдем точки, у которых абсцисса равна Xc, а также их ординаты
b=0;
for i=2:(t1(1)-2)
    %if abs(roundn(X(i),-2))<0.1 % &((abs(X(i)-0.01)<0.05)) %round(X(i))==0
     %   Yv(i)=Y(i);
    %end
    if abs(roundn(X(i),-2))<0.1
        bufer=(X(i+1)*Y(i-1)-Y(i+1)*X(i-1))/(X(i+1)-X(i-1));
    end
    if bufer>b
        b=bufer;
    end
end
%_______________________________Alexey
% s - исходный сигнал
A1 = wt(1:end-1);
B1 = wt(2:end);

A1c=classif(1:end-1);
B1c=classif(2:end);

for i = 1:length(A1) - 1
    if sign(A1(i)) ~= sign(A1(i+1))
        y3(i) = ( B1(i)*A1(i+1)-A1(i)*B1(i+1) )/( A1(i+1)-A1(i) );
    end
end

for i = 1:length(A1c) - 1
    if sign(A1c(i)) ~= sign(A1c(i+1))
        y3c(i) = ( B1c(i)*A1c(i+1)-A1c(i)*B1c(i+1) )/( A1c(i+1)-A1c(i) );
    end
end

maxY = max(y3(y3>0))
minY = min(y3(y3<0))
rasst = maxY - minY

maxYc = max(y3c(y3c>0))
minYc = min(y3c(y3c<0))
rasstC = maxYc - minYc % расстояние для классифициремой траектории
%_____________________________________________Alexey

Yvert=b;
%Yvert=max(Yv)
B1=B;
for i=1:(t1(1)-1)
    B1(i)=Yvert;
end
%plot(A,B,'b');
%hold on;
%plot(A,B1,'r');
%hold off;
vert=0;
vertYcur=0;
%for i=1:(t1(1)-1)
%    if wt(i)==round(Xc)
%        %vert=vert+1; % число точек на вертикали, пересекающей центр
%        vertYnext=Y(i);
%        if vertYcur<vertYnext
%            vertYcur=vertYnext;
%        end
%            
%    end
%end
%vertYcur
%
x1=textread('D:\SYNPATIC\RESEARCH\Portrets\Time\Negative\Geometry\vertNEG.txt');
x2=textread('D:\SYNPATIC\RESEARCH\Portrets\Time\Neutral\Geometry\vertNEU.txt');
x3=textread('D:\SYNPATIC\RESEARCH\Portrets\Time\Joy\Geometry\vertJOY.txt');
  [a1,b1]=size(x1)
  [a2,b2]=size(x2)
  [a3,b3]=size(x3)
  
  srednNEG=sum(x1)/a1
  srednNEU=sum(x2)/a2
  srednJOY=sum(x3)/a3
  
   x=zeros(1,a1+a2);
   y=zeros(1,a1+a2);
   
    for i=1:a1
        x(1,i)=x1(i);
        y(1,i)=1;
    end
    
    for i=(a1+1):(a1+a2)
        x(1,i)=x2(i-a1);
        y(1,i-a1)=2;
    end
    
    %scatter(x,y)
 
 otvet={'Negative' 'Neutral' 'Joy'};
 if (abs(rasstC-srednNEG)<abs(rasstC-srednNEU))%&(abs(rasstC-srednNEG)<abs(rasstC-srednJOY)))
     DoNEG=abs(rasstC-srednNEG)
     DoNEU=abs(rasstC-srednNEU)
     %DoJOY=abs(rasstC-srednJOY)
     result=otvet{1}
 end
 if (abs(rasstC-srednNEU)<abs(rasstC-srednNEG))%&(abs(rasstC-srednNEU)<abs(rasstC-srednJOY)))
     DoNEG=abs(rasstC-srednNEG)
     DoNEU=abs(rasstC-srednNEU)
     DoJOY=abs(rasstC-srednJOY)
     result=otvet{2}
 end
 %if ((abs(rasstC-srednJOY)<abs(rasstC-srednNEU))&(abs(rasstC-srednJOY)<abs(rasstC-srednNEG)))
  %   DoNEG=abs(rasstC-srednNEG)
   %  DoNEU=abs(rasstC-srednNEU)
   %  DoJOY=abs(rasstC-srednJOY)
   %  result=otvet{3}
 %end
 






