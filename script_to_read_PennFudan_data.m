%% 
baseDir = '';
annotDir = [baseDir 'PennFudanPed\Annotation\'];
count = 1;
files = dir(annotDir); files(1:2) = [];
close all;
for ii = 1 : length(files)
    fileName = [annotDir files(ii).name];
    record = PASreadrecord(fileName);
    temp = imread([baseDir record.imgname]);
    imshow([baseDir record.imgname]); hold on;
    [xdim, ydim, zdim] = size(temp);
    for jj = 1 : length(record.objects)
        leftmost = xdim;
        rightmost = 0;
        bbox = record.objects(jj).bbox
        %bbox(3:4) = bbox(3:4) - bbox(1:2)
        if bbox(1) < leftmost
            leftmost = bbox(1)
        end
        if bbox(3) > rightmost
            rightmost = bbox(3)
        end
    end
%     if leftmost  < 75
%         rectangle('Position', bbox, 'EdgeColor','g','LineWidth',2);
%         cropped = imcrop(temp, [0 0 leftmost, ydim]);
%         imwrite(cropped, sprintf('Negatives/temp%d.png', count), 'png');
%         count = count + 1;
%     end
    if rightmost  < (xdim - 75)
        rectangle('Position', bbox, 'EdgeColor','g','LineWidth',2);
        cropped = imcrop(temp, [rightmost 0 (xdim - rightmost) ydim]);
        imwrite(cropped, sprintf('Negatives/temp%d.png', count), 'png');
        count = count + 1;
    end
    
    
    
    hold off;    
    pause(0.05);
end
