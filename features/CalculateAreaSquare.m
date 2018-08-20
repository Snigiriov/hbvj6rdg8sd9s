function k1 = CalculateAreaSquare(s)
im = imag(fft(s));
A = im(1:end-1);
B = im(2:end);
%%      ���������� ��������� ����� � �� ���������
k = boundary(A, B);  %% ����� ���������� �� ����
contourDotsX = A(k);
contourDotsY = B(k);
%%      ��������� ����������� � ������������ ��������
minX = min(contourDotsX);
maxX = max(contourDotsX);
minY = min(contourDotsY);
maxY = max(contourDotsY);

b = (minY * maxX - maxY * minX)/(maxX - minX);
k1 = (minY - b)/minX;
k2 = (maxY - b)/maxX;
return
%%      ��������� ���������, ������� ���� ���� �� ��� �
posY = contourDotsY(contourDotsY>0);
posX = contourDotsX(contourDotsY>0);
[posX, Iposx] = sort(posX);
posY = posY(Iposx);
% posX = []
%%      ��������� ���������, ������� ���� ���� �� ��� �
negY = contourDotsY(contourDotsY<0);
negX = contourDotsX(contourDotsY<0);
[negX, Inegx] = sort(negX);
negY = negY(Inegx);
%%      ���������� �������� ��� ���������
posSquare = trapz(posX, posY);
negSquare = trapz(negX, negY);
%%      ���������� ������� � ������������ ��������
crossSquare = posSquare + abs(negSquare);
%%      ���������� ����� �������
width = abs(abs(maxX)+abs(minX));
height = abs(abs(maxY)+abs(minY));
overallSquare = width*height;
%%
areaSquare = overallSquare - crossSquare;
end