function Containers = containerLocation(Containers)
%containerLocation is designed to receive the inputs from the user to
% establish the coordinate locations of the containers on the board and 
% the reject pile.
%
%containerLocation uses while loops to keep allowing for more input so
% that when the user makes an error (exceeding how far the arm can
% reach), the user can try to input a correct coordinate again. 
%       
% Format: Containers = containerLocation(Containers). It receives the  
%  existing structure for Containers and modifies the values in its fields.
%
% Sam Goertzen & Nick Hamann, April 20, 2021

%Boolean variable for controlling the while loop.
done = false;
%Boolean variable for error checking.
happy = true;

cprintf('*#3f3d3c','Function Loaded\n\n');

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
                    cprintf('err','You have already used these coordinates.\n');
                end
                
            case 3
                if (x == Containers(1).X_coordinate &&...
                        y == Containers(1).Y_coordinate ||...
                        x == Containers(2).X_coordinate &&...
                        y == Containers(2).Y_coordinate)
                    happy = false;
                    cprintf('err','You have already used these coordinates.\n');
                end
        end
        
        %Check the radius.
        radius = sqrt(x^2 + y^2);
        
        %Checking that the coordinates can be reached by the arm.
        if (x >= -30 && x <= 30 && y >= 0 && y <= 30 && ...
                radius <= 30 && radius >= 10 && happy)
            done = true;
            Containers(i).X_coordinate = x;
            Containers(i).Y_coordinate = y;
            cprintf('green', 'Coordinates accepted!\n');
        elseif (radius > 30 || x < -30 || x > 30)
            cprintf('err', 'You have exceeded the arm''s radius\n');
        elseif (radius < 10)
            cprintf('err', 'Your radius is less than 10\n');
        elseif (y < 0)
            cprintf('err', 'You have entered a negative y coordinate\n');
        else
            cprintf('err', 'You have entered an invalid x and y coordinate\n');
        end
        
        %Resetting error checking boolean.
        happy = true;
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
        cprintf('green', 'Coordinates accepted!\n');
    else
        cprintf('err', 'You have entered an invalid x and y coordinate\n');
    end
end

end

