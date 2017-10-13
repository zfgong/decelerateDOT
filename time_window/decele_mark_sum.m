function sum = decele_mark_sum( x, y )
    xlen = size(x,2);
    ylen = size(y,2);
    if xlen <= ylen
       sum = [x+y(1: xlen),y((xlen+1):ylen)];
    else
      sum = [y+x(1:ylen),x((ylen+1):xlen)];
    end


end

