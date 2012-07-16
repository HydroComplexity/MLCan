function [dd,mm] = doy2date(year,doy)

if mod(year,4) ~= 0 
    dayspermonth = [0 31 28 31 30 31 30 31 31 30 31 30 31];
else
    if mod(theYear,100) == 0
        dayspermonth = [0 31 28 31 30 31 30 31 31 30 31 30 31];
        if mod(theYear,1000) == 0
            dayspermonth = [0 31 29 31 30 31 30 31 31 30 31 30 31];
        end
    else
        dayspermonth = [0 31 29 31 30 31 30 31 31 30 31 30 31];
    end
end
    
mm = ones(size(doy))*NaN;
dd = ones(size(doy))*NaN;

for im = 1:12
   I = find(doy > sum(dayspermonth(1:im)) & doy <= sum(dayspermonth(1:im+1)));
   mm(I) = ones(size(I)).*im;
   dd(I) = doy(I) - ones(size(I))*sum(dayspermonth(1:im));
end


return;

if mod(year,4) ~= 0 
    dayspermonth = [0 31 28 31 30 31 30 31 31 30 31 30 31];
else
    if mod(theYear,100) == 0
        dayspermonth = [0 31 28 31 30 31 30 31 31 30 31 30 31];
        if mod(theYear,1000) == 0
            dayspermonth = [0 31 29 31 30 31 30 31 31 30 31 30 31];
        end
    else
        dayspermonth = [0 31 29 31 30 31 30 31 31 30 31 30 31];
    end
end

im = 0;
found = 0;
while ~found
   im = im+1;
   if doy > sum(dayspermonth(1:im)) & doy <= sum(dayspermonth(1:im+1))
      found = 1;
      mm = im;
      dd = doy - sum(dayspermonth(1:im));
   end
end
