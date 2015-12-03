function [index]=northEastPhotomosaicTAG2(timePic, time,start_ind)

l=length(time);
for i=start_ind+1:1:l-1
    if (abs(timePic-time(i))<abs(timePic-time(i+1)))&&(abs(timePic-time(i))<abs(timePic-time(i-1)))
        index=i;
        break
    end
end