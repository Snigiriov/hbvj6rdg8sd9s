function s = Preprocessing(s, fs)
%  Check stereo
    if size(s, 2) == 2
        s = mean(s, 2);
    end
%%  Multiple random volume in db    
%     s = s*db(randi([1,100], 1, 1));
end

