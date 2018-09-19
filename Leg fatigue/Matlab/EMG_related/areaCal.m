function area=areaCal(x,y)

% input x, y: y is a function of x, Or length of x and y are same (n x 1);
% and y should be all positive.
% Area: area under curve y

nx=length(x); 
ny=length(y);

area=0;
if nx==ny
    for k=1:1:nx-1
        area=area+0.5*(x(k+1)-x(k))*(y(k+1)+y(k));
    end
end

    
        
    


    