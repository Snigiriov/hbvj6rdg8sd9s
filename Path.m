function Path
    persistent triggered
    if isempty(triggered)
        addpath('E:\Synpatic\Solution 11', 'features','lib/rastamat', 'lib/voicebox', 'lib/jsonlab', 'test', 'utils');
        triggered = true;
    end 
end