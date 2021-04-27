function roboDescription()
%roboDescription() prints a description of what the robotic arm does and
%describes in more detail what each option of the menu is.
cprintf('#007299','Assign countries & box type to containers\n');
help shippingDetails

cprintf('#007299','Set container locations\n');
help containerLocation

cprintf('#007299','Load the containers\n');
help loadContainers

cprintf('#007299','Container stats\n');
help containerStats

cprintf('#007299','Move to home position\n');
help homePosition
end

