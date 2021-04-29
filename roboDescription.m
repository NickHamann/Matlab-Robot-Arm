function roboDescription()
%roboDescription() prints a description of what the robotic arm does and
%describes in more detail what each option of the menu is.
%
% Format: roboDescri.
%
% Sam Goertzen & Nick Hamann, April 20, 2021
cprintf('#007299','Assign countries & box type to containers\n');
help shippingDetails

cprintf('#007299','Set container locations\n');
help containerLocation

cprintf('#007299','Load the containers\n');
help loadContainers

cprintf('#007299','Container stats\n');
help containerStats

cprintf('#007299','Display Countries\n');
help dispCountries

cprintf('#007299','Move Arm\n');
help moveArm

cprintf('#007299','Start Up Routine\n');
help startUpRoutine

cprintf('#007299','Move Servo\n');
help moveservo
end

