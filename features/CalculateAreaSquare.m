function k1 = CalculateAreaSquare(s)
im = imag(fft(s));
A = im(1:end-1);
B = im(2:end);
%%      вычисление граничных точек и их координат
k = boundary(A, B);  %% потом переписать на свое
contourDotsX = A(k);
contourDotsY = B(k);
%%      выявление минимальных и максимальных значений
minX = min(contourDotsX);
maxX = max(contourDotsX);
minY = min(contourDotsY);
maxY = max(contourDotsY);

b = (minY * maxX - maxY * minX)/(maxX - minX);
k1 = (minY - b)/minX;
k2 = (maxY - b)/maxX;
return
%%      выделение координат, лежащих выше нуля по оси у
posY = contourDotsY(contourDotsY>0);
posX = contourDotsX(contourDotsY>0);
[posX, Iposx] = sort(posX);
posY = posY(Iposx);
% posX = []
%%      выделение координат, лежащих ниже нуля по оси у
negY = contourDotsY(contourDotsY<0);
negX = contourDotsX(contourDotsY<0);
[negX, Inegx] = sort(negX);
negY = negY(Inegx);
%%      вычисление площадей под контурами
posSquare = trapz(posX, posY);
negSquare = trapz(negX, negY);
%%      вычисление площади с перекающейся областью
crossSquare = posSquare + abs(negSquare);
%%      вычисление общей площади
width = abs(abs(maxX)+abs(minX));
height = abs(abs(maxY)+abs(minY));
overallSquare = width*height;
%%
areaSquare = overallSquare - crossSquare;
end