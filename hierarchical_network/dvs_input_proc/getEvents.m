% Return matrix of DVS events in the format [x, y, polarity, timestamp]
% @param fileName the name of the file to open. If no argument is provided,
% the user is prompted to open a file via the file explorer GUI. File must 
% be .aerdat format (ask Scott for code for .aer2).
%
% Original code written by Robert Quinn
% Slight modifications by Alex Lee 

function events = getEvents(fileName)
    %loads all the addresses and times into matrices
    [allAddr, allTs] = loadaerdat();
    %extracts all the information from the address matrices in the form
    %[xcoordinate, ycoordinate, polarity]
    [x, y, pol] = extractRetina128EventsFromAddr(allAddr);
    %combines this to give a final matrix of the form [xcoordinate,
    %ycoordinate, polarity, timestamp]
    allTs = int32(allTs);
    events = [x, y, pol, allTs];
end 
