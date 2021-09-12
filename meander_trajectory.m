%Given point in GPS (fi,lamda) coordinates a circular trajectory is designed
%and a file is created
clc;clear;close all;

% %These are the corner coordinates of a rectangular area near Athena Research Center
% UpLeft = [24.919716 41.135857];
% DownLeft = [24.919710 41.135621];
% DownRight = [24.919915 41.135627];
% UpRight = [24.919904 41.135782];

% %These are the corner coordinates of a rectangular area enclosing QTCLU
UpLeft = [25.058059 41.075762];
DownLeft = [25.058063 41.075427];
DownRight = [25.058623 41.075483];
UpRight = [25.058586 41.075837];

% SquareX = [41.135857 41.135621 41.135627 41.135782];
% SquareY = [24.919716 24.919710 24.919915 24.919904];

%Calculate the length and the width of the rectangular area
L = sqrt((UpRight(2)-UpLeft(2))^2+(UpRight(1)-UpLeft(1))^2);    
W = sqrt((UpLeft(2)-DownLeft(2))^2+(UpLeft(1)-DownLeft(1))^2);
 
n=10;   %Increase/Decrease for a Denser/Sparser number of paths along the x/longitudinal axis
m=10;   %Increase/Decrease for a Denser/Sparser number of paths along the y/latiitudinal axis
 
L_div = L/n;    %Length divisions
W_div = W/m;    %Width Divisions

%The divisions are used to create discrete points through which the hexacopter is going to fly 


Len = zeros(n,1);
Wid = zeros(m,1);
 
Len(1)=UpLeft(1);
for i=2:1:n
    Len(i)= Len(i-1)+ L_div;
end
 
Wid(1)=UpLeft(2);
for k=2:1:m
    Wid(k)= Wid(k-1)- W_div;
end
%Wid vector holds the discrete latitudinal values
%Len vector holds the discrete longitudinal values


%Row vector holds the latitudinal values of the turning points of the path
%Column vector holds the longitudinal values of the turning points of the
%path
s=1;
for j=1:2:2*n
    Row(j)=s ;
    Row(j+1)= s;
    s=s+1;
end

a=1;
Collumn(a)=1;
a=a+1;
Collumn(a)=m;
a=a+1;
while a~=2*m+1
    if(Collumn(a-2)==1 && Collumn(a-1)==1)
        Collumn(a)=m;
        a=a+1;
    elseif(Collumn(a-2)==m && Collumn(a-1)==m)
        Collumn(a)=1;
        a=a+1;   
    elseif(Collumn(a-2)==m && Collumn(a-1)==1)
        Collumn(a)=1;
        a=a+1;  
    elseif(Collumn(a-2)==1 && Collumn(a-1)==m)
        Collumn(a)=m;
        a=a+1;
    end
end

%plot(Row,Collumn)

for q=1:1:length(Collumn)
    MeanderX(q) = Len(Collumn(q));
end 

for w=1:1:length(Row)
    MeanderY(w) = Wid(Row(w));
end

plot(MeanderX,MeanderY,'.'); %Quick plot to check the key points of the path

% googleEarth = [MeanderY' MeanderX'];      %Matrix with the ?,? coordinates to put in google earth
%                                     %Google earth wants Y,X or ?,? format
%                                     %to show to correct area
% mavMatrix = [MeanderX' MeanderY'];        
 
wp_file_create_no_ptofint(MeanderX,MeanderY,10)  %Waypoints file creation with the z parameter
                                                %fixed at 10 meters above the ground
   
       
    