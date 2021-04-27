function Containers = containerLocation(Containers)
%containerLocation is designed to receive the inputs from the user to
%establish the coordinate locations of the containers on the board and 
%the reject pile.
%   containerLocation uses while loops to keep allowing for more input so
%    that when the user makes an error (exceeding how far the arm can
%    reach), the user can try to input a correct coordinate again. 
%    Format: Containers = containerLocation(Containers). It receives the  
%    existing structure for Containers and modifies the values in its fields.

%Boolean variable for controlling the while loop.
done = false;
%Boolean variable for error checking.
happy = true;

%Iterates 3 times for the 3 containers.
for i = 1:3
    while(~done)
        %Receiving user input.
        message1 = sprintf('Please enter the x-coordinate of the container for %s: ',Containers(i).Country);
        x = input(message1);
        message2 =  sprintf('Please enter the y-coordinate of the container for %s: ',Containers(i).Country);
        y = input(message2);
        
        %Error checking.
        %Checking that the same coordinates haven't been enters for other
        % containers.
        switch i
            case 2
                if (x == Containers(1).X_coordinate &&...
                        y == Containers(1).Y_coordinate)
                    happy = false;
                end
                
            case 3
                if (x == Containers(1).X_coordinate &&...
                        y == Containers(1).Y_coordinate ||...
                        x == Containers(2).X_coordinate &&...
                        y == Containers(2).Y_coordinate)
                    happy = false;
                end
        end
        
        %Check the radius.
        radius = sqrt(x^2 + y^2);
        
        %Checking that the coordinates can be reached by the arm.
        if (x >= -30 && x <= 30 && y >= 0 && y <= 30 && ...
                radius <= 30 && happy)
            done = true;
            Containers(i).X_coordinate = x;
            Containers(i).Y_coordinate = y;
            fprintf('Coordinates accepted!\n');
        else
            fprintf('You have entered an invalid x and y coordinate\n');
        end
    end
    
    %Resetting the while loop.
    done = false;
end

happy = true;

%Establishing the reject pile.
while(~done)
    
    %Receiving user input.
    x = input('Please enter the x-coordinate of the reject pile: ');
    y = input('Please enter the y-coordinate of the reject pile: ');
    
    %Error checking.
    %Checking that the coordinates for Reject haven't already been used for
    % other containers.
    for i = 1:3
        if(x == Containers(i).X_coordinate && ...
                y == Containers(i).Y_coordinate)
            happy = false;
        end
    end
    
    %Checking that the coordinates can be reached by the arm.
    if (x >= -30 && x <= 30 && y >= 0 && y <= 30 && ...
                radius <= 30 && happy)
        done = true;
        Containers(4).X_coordinate = x;
        Containers(4).Y_coordinate = y;
        fprintf('Coordinates accepted!\n');
    else
        fprintf('You have entered an invalid x and y coordinate\n');
    end
end

end

