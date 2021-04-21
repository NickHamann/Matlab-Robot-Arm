function [Containers,Stats] = moveBoxes(Load,Containers,Stats,...
    a, gripper, base, elbow, shoulder, wristUD, forearm, wristTurn)
%moveBoxes takes the Load information which is the size and type for one
% and move it to the corresponding container or the reject pile.
    %Format: [Containers, Stats] = moveBoxes(Load, Containers, Stats).
    % All inputs and outputs are structures.
    
Fs = 48000;
    
if (Containers(1).isFull && Containers(2).isFull && Containers(3).isFull)
    fprintf('All 3 containers are full!\n The arm will not move!\n');
else
    for i = 1:3
        if (strcmpi(Containers(i).Box_type,Load.Box_type))

            %Getting current weight to see if the limit has been reached.
            call = sprintf("%s_weight",Load.Box_size);
            weight = Containers(i).Weight + Containers(i).(call);

            if (weight > Containers(i).Weight_limit)
               %Send the box to the reject pile.
               [Rejected, ~] = audioread('Rejected.wav');
               sound(Rejected,Fs);
               Containers(4).Weight = Containers(4).Weight ...
                   + Containers(i).(call);
               
               %Set the boolean isFull to true
               Containers(i).isFull = true;

               %Track what goes into reject pile.
               Stats(4).(Load.Box_size) = Stats(4).(Load.Box_size) + 1;

               %Move the arm.
               fprintf('Moving the box to the container for %s\n',...
                    Containers(4).Country);
               moveArm(Containers(4).X_coordinate,Containers(4).Y_coordinate,...
                   a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn);

            else
                %Load the box to container i.
                fprintf('Accepted\n');
                Containers(i).Weight = weight;

                %Track what goes into the containers.
                Stats(i).(Load.Box_size) = Stats(i).(Load.Box_size) + 1;

                %Move the arm.
                fprintf('Moving the box to the container for %s\n',...
                    Containers(i).Country);
                moveArm(Containers(i).X_coordinate,Containers(i).Y_coordinate,...
                   a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn);
            end
        end
    end
end
end