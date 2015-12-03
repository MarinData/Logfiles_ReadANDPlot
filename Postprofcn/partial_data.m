function [start,stop] = partial_data(start_t,end_t,sflag,time)
% is used in raw_mat_plots.m
%get some of the data..
l_t=length(time);
start=1;
stop=2;

if sflag==1
for i=1:l_t
t_check=floor(time(i));
    if t_check==floor(start_t)
        start=i;    
    elseif t_check>=floor(end_t)
        stop=i;
        break;
    elseif i==l_t
        stop=i;
    else
        stop = length(time);  
    end
end
else
   start = 1;
   stop = length(time); 
end
end