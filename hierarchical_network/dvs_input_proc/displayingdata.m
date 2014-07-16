%loads all the addresses and times into matrices
[allAddr, allTs] = loadaerdat();
%extracts all the information from the address matrices in the form
%[xcoordinate, ycoordinate, polarity]
[infomatrix1, infomatrix2, infomatrix3] = extractRetina128EventsFromAddr(allAddr);
%combines this to give a final matrix of the form [xcoordinate,
%ycoordinate, polarity, timestamp]
allTs = int32(allTs);
total = [infomatrix1, infomatrix2, infomatrix3 ,allTs];

%get dimensions of total matrix
[xsize, ysize] = size(total);
%set figure properties
video = figure('color','white');
%find out the starting timestamp (in microseconds)
plottime = total(1,4)

%set entire total matrix to int32
total = int32(total);

%set figure to grayscale
colormap(gray)

for j = 1:xsize
    % Break data into 10000 microsecond blocks
    ind = find(total(:,4) >= plottime & total(:,4)<=plottime+10000);
    plottime = plottime + 10000;
    
    %set up the background for the matrix to display
    background = zeros(128,128);
%     bind=[total(ind,1)+1,total(ind,2)+1]
%     background(bind)=total(ind,3);
   
   %for each set of 10000 microsecond blocks of data, adjust the zeros
   %matrix to account for the changed events in that time block (-1 or 1)
   %and finally adjust to values between 0 and 255 (grayscale values)
   for k = ind(1,1):ind(size(ind),1)
       background(total(k,2)+1, total(k,1)+1) = total(k,3);
   end
   %set up the escape root for the for loop (I need to change this)
    if plottime > total(xsize,4)
        break;
    end
    %end
    %set the size of the image
    xlim([0, 128])
    ylim([0, 128])
    
    %display the stuff in real time (not sure if necessary yet)
    drawnow;
    %flip the images the correct way around again
    background = flipud(background);
    %actually display the images at the speed of the for loop
    imagesc(background);
end
