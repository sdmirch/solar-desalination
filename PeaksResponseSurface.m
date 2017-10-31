a=axes;
[x,y,z]=peaks;


x=x+2;
y=y+10;
z=z+10;

for i=[1:49]
    for j=[1:49]
if x(i,j)<3
    z(i,j)=z(i,j)+10;
end
if y(i,j)>12 
    if x(i,j)>3
    z(i,j) = z(i,j)+10;
    end
end
    end
end

surf(x,y,z);
xlabel('Water Prod (100L)');ylabel('Temp (10F)');zlabel('Cost($K)')
