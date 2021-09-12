clear;clc;close all;

%Read the .off file and store the xyz values of the vertices of the mesh at
%the xyz matrix and the sequential number of each vertex that compose a face
%at the faces matrix
[xyz,faces] = read_off('QTCLU_Model_last.off');
xyz=xyz';

% 3D plot all the vertexes of the mesh
x=xyz(:,1);
y=xyz(:,2);
z=xyz(:,3);
scatter3(x(:),y(:),z(:),'.');
title('Vertices of the 3D mesh')
%zlim([0 4]);
figure

%Calculate: the number of rows of the xyz matrix / the number of vertices
xyz_size = size(xyz);
rows = xyz_size(1);

%Calculate: the middle z value / the middle of the model's height
[v i] = min(xyz(:,3));
z_low = v;
[v i] = max(xyz(:,3));
z_high = v;
meso_z = z_low+(z_high-z_low)/2-0.4;
%meso_z=0.1;

%Define the thickness of the slice of the model 
%where I will pick my perimeter points 
slice_high = meso_z+meso_z/18;
slice_low = meso_z-meso_z/18;

%Find the rows of the xyz matrix / the vertices of the mesh whose z value
%is between the upper and lower z values of the slice 
right_rows =[];
for j=1:1:rows
    if(xyz(j,3)>=slice_low)&&(xyz(j,3)<=slice_high)
       right_rows(end+1)=j;         
    end      
end

%Pick the mesh points/vertices that belong on the slice defined above
points = zeros(length(right_rows),3);
for k=1:1:length(right_rows)
    curr = right_rows(k);
    points(k,1:3)=xyz(curr,1:3);
end
   
%3D plot the vertices of the slice
X=points(:,1);
Y=points(:,2);
Z=points(:,3);

scatter3(X(:),Y(:),Z(:),'.')
title('3d plot of the vertices of the slice');
figure

%3D Plot the vertices of the slice on a plane 
%(eliminate the z values of the points)
planar_cut = points;
planar_cut(:,3)=meso_z;
X=planar_cut(:,1);
Y=planar_cut(:,2);
Z=planar_cut(:,3);

scatter3(X(:),Y(:),Z(:),'.')
title('3D Plot the vertices of the slice on a plane (z values eliminated)');
figure 

%2D Plot boundary line of the perimeter points
plot(X,Y,'.');
shr_par = 0.96; %shrinking parameter
k = boundary(X,Y,shr_par);

%returns a single conforming boundary around the points 
%(X,Y). X and Y are column vectors of equal size that specify the coordinates. 
%K is a vector of point indices that represents a compact boundary around 
%the points. The boundary can shrink towards the 
%interior of the hull to envelop the points

plot(X(k),Y(k));
axis equal

%--Normals Method to create the new perimeter
V=[X(k) Y(k)];
%The vector that holds the X and Y coordinates of 
%the points that compose the FIRST perimeter
%It is actually a selection of the outermost points that belong to the
%slice, hence the index k that shows which ones of them are.

N=LineNormals2D(V);
 scale_factor =0.6;
 hold on;
%This function calculates the normals, of the line points
%using the neighbouring points of each contour point, and 
%forward an backward differences on the end points 
%matrix N holds the vertical unit vectors to the curve shaped by the 
%building's perimeter. The beggining of the vectors are on (0,0)
 
xy_new = [V(:,1)+scale_factor*N(:,1),V(:,2)+scale_factor*N(:,2)];
%The vector that holds the X and Y coordinates of 
%the points that compose the SECOND perimeter
k1=boundary(xy_new(:,1),xy_new(:,2),0.97);

plot(xy_new(k1,1),xy_new(k1,2),'r');
%Plot the SECOND perimeter curve
plot([V(k1,1) xy_new(k1,1)]',[V(k1,2) xy_new(k1,2)]');
%Plot the vectors 
%scatter(xy_new(:,1),xy_new(:,2));
%Plot the SECOND perimeter's points


% ~~~~~~~~~~~~~~~~~~~~SPLINES PLOT METHOD~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
x_splines = xy_new(k1,1)';
y_splines = xy_new(k1,2)';
xy_splines = [x_splines;y_splines];

%Auxiliary piece of code to extract the number of points we use to perform
%the interpolation
%[nxy npts] = size(xy_splines);

%By changing the first input of the function we modify the density of the
%splines curve points
pt = interparc(50,x_splines,y_splines,'spline');
 
% Plot the result
% plot(x_splines,y_splines,'r*',pt(:,1),pt(:,2),'b-o')
  plot(pt(:,1),pt(:,2),'b-o')
  %axis([-10 10 -10 10])
  axis equal  
  grid on
  xlabel X
  ylabel Y
  title 'Points in blue are uniform in arclength around the circle'
  figure
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

x_for_mavlink = pt(:,1);
%Prohgoumeno = x_for_mavlink(1)
y_for_mavlink = pt(:,2);

%We have to insert the part of the number that was cut off here 
%Th
for i=1:1:length(x_for_mavlink)
    x_for_mavlink(i) = repdig(25.058,x_for_mavlink(i));
    y_for_mavlink(i) = repdig(41.075,y_for_mavlink(i));
end

%Add an offset value to center the trajectory onto the buildings shape
for i=1:1:length(x_for_mavlink)
    x_for_mavlink(i) = x_for_mavlink(i)+0.00002;
    y_for_mavlink(i) = y_for_mavlink(i)+ 0.00007 ;
end


%Add an offset value to center the trajectory onto the buildings shape
for i=1:1:length(x_for_mavlink)
    x_for_mavlink(i) = x_for_mavlink(i);
    y_for_mavlink(i) = y_for_mavlink(i)- 0.0001 ;
end

ptofint_x = mean(x_for_mavlink); 
ptofint_y = mean(y_for_mavlink);
plot(x_for_mavlink,y_for_mavlink,'b-o');
hold
plot(ptofint_x,ptofint_y,'d');
title('Path coordinates & Point of interest')

ptofint = [ptofint_x ptofint_y];

%Waypoint file creation using the georeferenced x,y,z points created above
%The WP
wp_file_create(x_for_mavlink,y_for_mavlink,10,ptofint)

