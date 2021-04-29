function dispCountries(Containers, isCoordinatesSet)
% dispCountries displays the Country and box type of each Container. It
% also receives a boolean isCoordinatesSet which will additionally display 
% the X and Y coordinates of each container.
%
% Format: dispCountries(Containers, isCoordinatesSet)
% Inputs are a main structure with container details and a boolean that
% specifies whether or not to display the coordinates.
%
% Sam Goertzen & Nick Hamann, April 25, 2021
for i = 1:3
    cprintf([1, 0.5, 0], 'Container %d:\n', i);
    cprintf([1, 0.5, 0], '  Country: %s\n', Containers(i).Country);
    cprintf([1, 0.5, 0], '  Type: %s\n', Containers(i).Box_type);
    if isCoordinatesSet
        cprintf([1, 0.5, 0], '  Coordinates: [%.2f, %.2f]\n', ...
            Containers(i).X_coordinate, Containers(i).Y_coordinate);
    end
end

if isCoordinatesSet
        cprintf([1, 0.5, 0], 'Reject Pile:\n');
        cprintf([1, 0.5, 0], '  Coordinates: [%.2f, %.2f]\n', ...
            Containers(4).X_coordinate, Containers(4).Y_coordinate);
end

end

