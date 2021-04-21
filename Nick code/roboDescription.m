function roboDescription()
%roboDescription() prints a description of what the robotic arm does and
%describes in more detail what each option of the menu is.
fprintf('Assign countries & box type to containers\n');
help shippingDetails

fprintf('Set container locations\n');
help containerLocation

fprintf('Load the containers\n');
help loadContainers

fprintf('Container stats\n');
help containerStats

fprintf('Move to home position\n');
help homePosition
end

