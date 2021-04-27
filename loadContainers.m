function [Containers,Stats] = loadContainers(Containers)
%loadContainers identifies the box that is being loaded and determine
% which container it goes into. The arm will then pick of the box and place
% it in the correct container (1, 2, 3, or reject aka 4).
%
% Format: [Containers, Stats] = loadContainers(Containers). All inputs
%  and outputs are structures.

%Initialize arm.
clear a;
[a, gripper, base, elbow, shoulder, wristUD, forearm, wristTurn] = startUpRoutine();

%Iteration number.
i = 1;

%Boolean control variable.
done = false;

%Structure for loading.
Load = struct('Box_type',[],'Box_size',[]);
%Structure for container stats.
Stats(4) = struct('Country',Containers(4).Country,'Small',0,'Medium',...
    0,'Large',0);
for j = 1:3
Stats(j) = struct('Country',Containers(j).Country,'Small',0,'Medium',...
    0,'Large',0);
end

%While the user wants to continue, the program will keep loading and
% processing boxes.
while(~done)
    if(i < 46)
        file = sprintf('%d.png',i);
        pic = imread(file);
        
        box_type = pic(1,1,1);
        
        switch box_type
            case 20
                Load.Box_type = "Medical";
                
            case 30
                Load.Box_type = "Food";
                
            case 40
                Load.Box_type = "Housing";
        end
        
        %Analyze where the picture starts.
        [rows,~] = size(pic);
        large_check = round(rows * .10);
        medium_check = round(rows * .35);
        
        %if pic begins at top 10%, then large
        if sum(sum(pic(1:large_check,:,1) == 0))
            Load.Box_size = "Large";
            
            %if pic begins between 11 and 35%, then medium
        elseif sum(sum(pic(large_check+1:medium_check,:,1) == 0))
            Load.Box_size = "Medium";
            
            %if pic begins below 35%, then small
        else
            Load.Box_size = "Small";
        end
        
        %Display image to user and play a sound announcing box size
        % and type.
        figure(1);
        imshow(pic);
        
        %Tells the user the box type and size.
        Fs = 48000;
        if strcmpi(Load.Box_type,'Food')
            type_message = sprintf('%s.wav',Load.Box_type);
        else
            type_message = sprintf('%sSupplies.wav',Load.Box_type);
        end
        size_message = sprintf('%s.wav',Load.Box_size);
        [ThisIsA,~] = audioread('ThisIsA.wav');
        [boxSize,~] = audioread(size_message);
        [BoxOf,~] = audioread('BoxOf.wav');
        [type,~] = audioread(type_message);
        message = [ThisIsA;boxSize;BoxOf;type];
        sound(message,Fs);
        pause(4);

        close figure;
%Moves the boxes to the appropriate container or 
% the reject pile depending on its type and size and weight 
% limit.
Fs = 48000;
    
if (Containers(1).isFull && Containers(2).isFull && Containers(3).isFull)
    fprintf('All 3 containers are full!\n The arm will not move!\n');
else
    for j = 1:3
        if (strcmpi(Containers(j).Box_type,Load.Box_type))

            %Getting current weight to see if the limit has been reached.
            call = sprintf("%s_weight",Load.Box_size);
            futureWeight = Containers(j).Weight + Containers(j).(call);
    
            %If the future weight will be greater than the limit,
            % then reject the box.
            if (futureWeight > Containers(j).Weight_limit)
               %Send the box to the reject pile.
               [Rejected, ~] = audioread('Rejected.wav');
               sound(Rejected,Fs);
               Containers(4).Weight = Containers(4).Weight ...
                   + Containers(j).(call);
               
               %Set the boolean isFull to true
               Containers(j).isFull = true;

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
                Containers(i).Weight = futureWeight;

                %Track what goes into the containers.
                Stats(j).(Load.Box_size) = Stats(j).(Load.Box_size) + 1;

                %Move the arm.
                fprintf('Moving the box to the container for %s\n',...
                    Containers(j).Country);
                moveArm(Containers(j).X_coordinate,Containers(j).Y_coordinate,...
                   a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn);
            end
        end
    end
end

%Have you finished loading container? Or do you want to load another?
finished = menu('Do you want to load another box','YES','NO');
if (finished == 2)
    done = true;

    %Move the arm to a final rest position.
    moveservo(base, 0.5);
    moveservo(elbow, 0.1);
    moveservo(shoulder, 0.9);
else
    i = i + 1;
end
%There are no more images
    else
        fprintf('There are no more boxes to sort. Please select NO\n');
        finished = menu('Do you want to load another box','YES','NO');
        if (finished == 2)
            done = true;
        else
            i = i + 1;
        end
    end
end

end

