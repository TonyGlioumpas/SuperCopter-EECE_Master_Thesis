%Given point in GPS (fi,lamda) coordinates a circular trajectory is designed
%and a file is created
clc;clear;close all;

% % These are the Athena Research Center's coordinates
% ptofint = [24.919836 41.135715];
% ptoftraj = [24.919962 41.135791 ];

%Q2CLU Coordinates
ptofint = [25.058309 41.075585];
ptoftraj = [25.058242 41.075894];


auxiliary = [ptofint(1) ptofint(2); ptoftraj(1) ptoftraj(2)];
radius = pdist(auxiliary,'euclidean');      %desired radius
                                    
numPoints = 10;                              %Number of points in your circle
angles = linspace(0,2*pi,numPoints)';          %Angles evenly spread around the circle, from 0 to 2*pi radians
xyCircle = radius*[cos(angles) sin(angles)];   %This is the matrix of the xy points of the circle 

for i=1:1:length(xyCircle)                  %We transfer the centre of the circle in order to put
    x_mav(i) = ptofint(1)+xyCircle(i,1)     %it on the center of interest we picked above
    y_mav(i) = ptofint(2) +xyCircle(i,2)
end

googleEarth = [y_mav' x_mav'];      %Matrix with the ?,? coordinates to put in google earth
                                    %Google earth wants Y,X or ?,? format
                                    %to show to correct area
mavMatrix = [x_mav' y_mav'];        

plot(x_mav,y_mav,'.'); %Quick plot to check the result
hold
plot(ptofint(1),ptofint(2),'d')
axis equal;


wp_file_create_circular(x_mav,y_mav,10,ptofint)  %Waypoints file creation with the z parameter
                                                %3rd parameter: meters above the ground
   
        
    