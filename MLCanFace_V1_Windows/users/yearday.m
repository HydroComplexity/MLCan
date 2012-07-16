function numday_year = yearday(theYear)
if mod(theYear,4) ~= 0
    numday_year = 365;
else
    if mod(theYear,100) == 0
        numday_year = 365;
    	if mod(theYear,1000) == 0
            numday_year = 366;
        end
    else
        numday_year = 366;
    end
end           
end
