function meanL = PathCalculator(A)
    %formatSpec = '%f';
    %fileID = fopen('D:\SYNPATIC\RESEARCH\2.txt');
    %fprintf(fileID,formatSpec,WT);

%     step=1; % величина шага для метода Рюэля-Такенса
    [numRows, numColumns]=size(A); % размер вектора значений одной переменной, по которой описываем динамику системы
    %for i=1:t1(1)
    %w(i)=str2num(WT1{i}) % преобразование символов в числа
    %end
    %size(w);
%     comet(A,B) % визуализация
    %определение длин всех фрагментов фазовой траектории и среднего значения
for i = 1:numColumns
    for j=1:numRows-2
        L(j, i)=sqrt(((A(j,i)-A(j+1,i))^2)+(A(j+1,i)-A(j+2,i))^2);
    end
end
    meanL=mean(L, 1);
end