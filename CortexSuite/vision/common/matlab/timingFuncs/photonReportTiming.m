%! _photonReportTiming_i2_i2i2

function elapsed = photonReportTiming(startCycles, endCycles)
    elapsed = zeros(1,2);
    elapsed(1) = endCycles(1) - startCycles(1);
    elapsed(2) = endCycles(2) - startCycles(2);
end