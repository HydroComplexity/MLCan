%-------------------------------------------------------------------------% 
% This function is used to extract hourly data in one month
% Written by: Phong Le
% Date      : 03-07-2010
%-------------------------------------------------------------------------% 

function [var_out,hour_out] = EXTRACT_VAR (daybegin, dayend, hours, var_in)
    j = 1;
    for i = ((daybegin-151)*48+1):((dayend-151+1)*48)
        var_out(j)=var_in(i);
        hour_out(j)=hours(i);
        j = j +1;
    end
end