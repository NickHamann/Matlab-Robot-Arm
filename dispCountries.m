function dispCountries(Containers, isCoordinatesSet)
% dispCountries displays the Country and box type of each Container. It
% also receives a boolean isCoordinatesSet which will additionally display 
% the X and Y coordinates of each container.
%
% Format: dispCountries(Containers, isCoordinatesSet)
for i = 1:3
    cprintf([1, 0.5, 0], 'Container %d:\n', i);
    cprintf([1, 0.5, 0], '  Country: %s\n', Containers(i).Country);
    cprintf([1, 0.5, 0], '  Type: %s\n', Containers(i).Box_type);
    if isCoordinatesSet
        cprintf([1, 0.5, 0], '  Coordinates: [%s, %s]\n', ...
            Containers(i).X_coordinate, Containers(i).Y_coordinate);
    end
end

end

