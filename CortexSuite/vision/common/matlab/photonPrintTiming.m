%! _photonPrintTiming_NA_i2

function photonPrintTiming(elapsed)
    if(elapsed(2) == 0)
        fprintf(1,'Cycles elapsed\t\t- %u\n',elapsed(1));
    else
        fprintf(1,'Cycles elapsed\t\t- %u%\u\n',elapsed(2),elapsed(1));
    end
end


