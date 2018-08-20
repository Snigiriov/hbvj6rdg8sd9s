function [cellArray, cellIndexArray] = GetCellsFromArrayByCondition(s, conditionLow, conditionHigh)
s = [s, 0];
j = 1;
k = 1;
tempArray = 0;
tempIndexArray = 0;
    for i = 1:length(s)-1
        if s(i) > conditionLow && s(i) < conditionHigh
            tempArray(j) = s(i);
            tempIndexArray(j) = i;
            j = j + 1;  
            if  sign(s(i+1)) ~= sign(s(i))
                    cellArray{k} = tempArray;
                    cellIndexArray{k} = tempIndexArray;
                    k = k + 1;
                    tempArray = 0;
                    tempIndexArray = 0;
                    j = 1;
             end
        end   
    end
end