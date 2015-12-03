function [index]=northEastPhotomosaic(time_searched, time)

l=length(time);
for i=2:1:l
    tt=time{i};
    if str2double(tt(1:2))==time_searched(1) && str2double(tt(4:5))==time_searched(2) && str2double(tt(7:8))==time_searched(3)
        index=i;
    end
end

end