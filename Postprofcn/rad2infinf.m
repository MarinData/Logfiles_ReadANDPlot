function [psi_out]= rad2infinf(psi_in)
% make angles continuous: 
% is used in NavDataPic in  the folder 3D representation

l_data=length(psi_in);  
psi_mes=zeros(l_data,1);

count=0;
for i=1:l_data     
    if i==1
        psi_mes(i)=rad2pipi(psi_in(i));
    else
        
        heading_check_l=rad2pipi(psi_in(i-1)); 
        heading_check=rad2pipi(psi_in(i));    

        if heading_check_l>pi/2 && heading_check<0
            count=count+1;    
        elseif heading_check_l<-pi/2 && heading_check>0
            count=count-1;   
        end

        psi_mes(i)=(heading_check+2*pi*count);
    end
end

psi_out=psi_mes; %array of continuous angles

