function wp_file_create(x,y,z,ptofint)

fileID = fopen('QTCLU.waypoints','w');

fprintf(fileID,'%3s %3s %3s\n','QGC','WPL','110');

%QGC WPL <VERSION>
%<INDEX> <CURRENT WP> <COORD FRAME> <COMMAND> <PARAM1> <PARAM2> 
%<PARAM3> <PARAM4> <PARAM5/X/LONGITUDE> <PARAM6/Y/LATITUDE> <PARAM7/Z/ALTITUDE> <AUTOCONTINUE>

index = [];
current_wp = [];
coord_frame = [];
command =[];
param1 = [];
param2 = [];
param3 = [];
param4 = [];
autocontinue =[];
% param5_x_longtitude = y;
% param6_y_latitude = x;
% param7_z_latitude = z;

param5_x_longtitude = [[0 0] y'];
param6_y_latitude = [[0 0] x'];
param7_z_latitude = z;

ROI = ptofint;

for k=1:1:(length(x)+2)
   index = [index k]; 
   current_wp = [current_wp 0];
   coord_frame = [coord_frame 0];
   command = [command 0];
   param1 = [param1 0];
   param2 = [param2 0];
   param3 = [param3 0];
   param4 = [param4 0];
   autocontinue = [autocontinue 0];
end

%autocontinue = ones(150,1);

%-----------CODE FOR HOME------------%
i=1;
to_print = [0 1 coord_frame(i) 16 param1(i) param2(i) param3(i) param4(i) param5_x_longtitude(i+2) param6_y_latitude(i+2) param7_z_latitude autocontinue(i)];  
fprintf(fileID,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%2.6f\t%2.6f\t%d\t%d\n',to_print(i,:));

%-----------CODE FOR TAKEOFF------------%
to_print = [to_print; [index(1) 0 1 22 param1(1) param2(1) param3(1) param4(1) 0 0 param7_z_latitude autocontinue(2)]];        
fprintf(fileID,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%2.6f\t%2.6f\t%d\t%d\n',to_print(2,:));


%-------CODE FOR REGION OF INTEREST-----%
to_print = [to_print; [index(2) 0 1 201 param1(2) param2(2) param3(2) param4(2) ROI(2) ROI(1) param7_z_latitude autocontinue(2)]];        
fprintf(fileID,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%2.6f\t%2.6f\t%d\t%d\n',to_print(3,:));


for i=3:1:length(index)
    to_print = [to_print; [index(i) current_wp(i) 1 16 param1(i) param2(i) param3(i) param4(i) param5_x_longtitude(i) param6_y_latitude(i) param7_z_latitude autocontinue(i)]];
    fprintf(fileID,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%2.6f\t%2.6f\t%d\t%d\n',to_print(i+1,:));
end

%-----------CODE FOR LANDING------------%
to_print = [to_print; [index(i)+1 0 1 21 0 0 0 0 0 0 0 1]];
fprintf(fileID,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%2.6f\t%2.6f\t%d\t%d\n',to_print(i+2,:));

fclose(fileID);


%We want our file to be at a UTF-8 encoding
%For an already-open document: Edit -> EOL Conversion to chnge the end of
%line characters