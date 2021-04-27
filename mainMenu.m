  
%mainMenu() is the central location for the robotic arm code. Users will
%select whatever they want to do from the menu until the user decides to
%exit the program.

%Initialize a structure called Containers.
Containers(4) = struct('Country','Reject','Weight_limit',100000,...
    'Box_type','any','X_coordinate',[],'Y_coordinate',[],...
    'Weight',0,'Small_weight',[],'Medium_weight',[],'Large_weight',[],...
    'isFull',[]);
for i = 1:3
    Containers(i) = struct('Country',[],'Weight_limit',[],'Box_type',[],...
        'X_coordinate',[],'Y_coordinate',[],'Weight',0,'Small_weight',[],...
        'Medium_weight',[],'Large_weight',[],'isFull',false);
end
%Booleans for preventing users from accessing functions out of order.
countriesAssigned = false;
containerLocationAssigned = false;
containersLoaded = false;

%Menu-driven loop.
choice = menu('Choose a function to call','Description',...
    'Assign countries & box type to containers','Set container locations',...
     'Load the containers','Container stats','Exit the program');
%The user will remain in the menu loop until they select 'Exit the Program'
% or close the menu.
while choice ~= 6 && choice ~= 0
    switch choice
        case 1
            %Calls a function that will print a detailed description of the
            %code.
            roboDescription();
            
        case 2
            %Calls a function that will link each container to a
            %country and box type. A structure is returned.
            Containers = shippingDetails(Containers);
            countriesAssigned = true;
                        
        case 3
            %Calls a function that will establish the locations of the
            %containers for the arm to use later and puts them into a
            %structure.
            if countriesAssigned
                Containers = containerLocation(Containers);
                containerLocationAssigned = true;
            else
                cprintf('err', 'You have not yet assigned countries or box types to container\n');
            end
   
        case 4
            %Calls a function that will ask for x and y coordinates for the
            %boxes and move the boxes to their appropriate locations.
            if containerLocationAssigned
                [Containers, Stats] = loadContainers(Containers);
                containersLoaded = true;
            else
                cprintf('err', 'You have not yet established the locations of the containers\n');
            end
            
        case 5
            %Calls a function that will display the bar graph of what each
            %country is receiving (box type and size).
            if containersLoaded
                containerStats(Stats);
            else
                cprintf('err', 'You have not yet loaded the containers\n');
            end
    end
    choice = menu('Choose a function to call','Description',...
    'Assign countries & box type to containers','Set container locations',...
     'Load the containers','Container stats','Exit the program');
end