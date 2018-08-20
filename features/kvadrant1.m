function Chisloserii = kvadrant1(WT)
step=1; % �������� ���� ��� ������ �����-�������
t1=size(WT); % ������ ������� �������� ����� ����������, �� ������� ��������� �������� �������

% ������, ����� �������� ����������� ������ �������� ������� ����������.
% ������� �������� ������� ��������� �������� ������� ����� �������
% ����������

%kvadro=zeros(1,t1(1)-step-1); % ������ � �������� ����������

for i=1:(t1(1)-step-1)
    kv1(i)=WT(i+1)-WT(i);
    kv2(i)=WT(i+2)-WT(i+1);
    if (kv1(i)>0)&(kv2(i)>0)
        kvadro(1,i)=1;
    end
    if (kv1(i)>0)&(kv2(i)<0)
        kvadro(1,i)=4;
    end
    if (kv1(i)<0)&(kv2(i)<0)
        kvadro(1,i)=3;
    end
    if (kv1(i)<0)&(kv2(i)>0)
        kvadro(1,i)=2;
    end
end
kvadro';
%dlmwrite('D:\SYNPATIC\RESEARCH\Portrets\Time\Joy\kvadroJOY1.txt',kvadro, '\t'); %������ ������� � ��������� ����!
%a=textread('D:\SYNPATIC\RESEARCH\Portrets\Time\Joy\kvadroJOY1.txt'); % ������ �� ���������� �����
%a'
%histogram(kvadro)
%histogram(a)

a=kvadro;
S=size(a); %����������� ��������� ����
serii=0; % ����� ����������� �����
    j=1;
    while j<S(1,2)
        if a(1,j+1)==a(1,j)
            j=j+1;
        else
            serii=serii+1;
            j=j+1;
        end
        
    end
    if a(1,S(1,2))==a(1,S(1,2)-1)
        serii=serii;
    else
        serii=serii+1;
    end
   %symbol'     
   Chisloserii=serii;
   
end