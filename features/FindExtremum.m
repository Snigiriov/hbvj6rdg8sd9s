function [ratioX, ratioY] = FindExtremum(s)
if nargin == 0
    data = load('mtlb');
    s = data.mtlb;
end
%%      ������������� ������(�������� �������� ���� � � �)
A = s(1:end-1);
B = s(2:end);
%%      ���������� ���� �����, ������������ ��� Y
for i = 1:length(A) - 1
    if sign(A(i)) ~= sign(A(i+1))
        b = (B(i)*A(i+1)-A(i)*B(i+1))/(A(i+1)-A(i));
        y3(i) = b;
    end
end
%%      ���������� �����������
maxY = max(y3(y3>0));
minY = min(y3(y3<0));
stdYpos = std(y3(y3>0));
stdYneg = -std(y3(y3<0));
%%      ���������� ������������� ����������
maxRasstY = maxY - minY;
medianRasstY = stdYpos - stdYneg;
%%      ���������� ���� �����, ������������ ��� �
for i = 1:length(B) - 1
    if sign(B(i)) ~= sign(B(i+1))
        b = (B(i)*A(i+1)-A(i)*B(i+1))/( A(i+1)-A(i));
        k = (B(i) - b)/A(i);
        x3(i) = (-1)*(b/k);
    end
end
%%      ���������� �����������
maxX = max(x3(x3>0));
minX = min(x3(x3<0));
stdXpos = std(x3(x3>0));
stdXneg = -std(x3(x3<0));
%%      ���������� ������������� ����������
maxRasstX = maxX - minX;
medianRasstX = stdXpos - stdXneg;
%%
ratioX = medianRasstX/maxRasstX;
ratioY = medianRasstY/maxRasstY;
%%      ���������� ��������
if  nargin == 0
    hold on
    plot(A, B)
    
%     plot(zeros(1, length(y3)), y3, 'or')
%     plot(x3, zeros(1, length(x3)), 'or')
    
    plot([0, 0], [stdYneg, stdYpos], 'or')
    plot([stdXneg, stdXpos], [0, 0], 'or')
end
end