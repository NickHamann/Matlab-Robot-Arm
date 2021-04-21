function [Containers,Stats] = loadContainers(Containers)
%loadContainers identifies the box that is being loaded and determine
% which container it goes into. The arm will then pick of the box and place
% it in the correct container (1, 2, 3, or reject aka 4).
%   Format: [Containers, Stats] = loadContainers(Containers). All inputs
%    and outputs are structures.

    %Initialize arm.
    clear a;
    [a, gripper, base, elbow, shoulder, wristUD, forearm, wristTurn] = startUpRoutine();

    %Iteration number.
    i = 1;

    %Boolean control variable.
    yes = true;

    %Structure for loading.
    Load = struct('Box_type',[],'Box_size',[]);
    %Structure for container stats.
    Stats(4) = struct('Country',Containers(4).Country,'Small',0,'Medium',...
        0,'Large',0);
    Stats(1) = struct('Country',Containers(1).Country,'Small',0,'Medium',...
        0,'Large',0);
    Stats(2) = struct('Country',Containers(2).Country,'Small',0,'Medium',...
        0,'Large',0);
    Stats(3) = struct('Country',Containers(3).Country,'Small',0,'Medium',...
        0,'Large',0);

    %While the user wants to continue, the program will keep loading and
    % processing boxes.
    while(yes)
        if( i < 46)
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

            %moveBoxes moves the boxes to the appropriate container or 
            % the reject pile depending on its type and size and weight 
            % limit.
            [Containers,Stats] = moveBoxes(Load,Containers,Stats,a,... 
                gripper, base, elbow, shoulder, wristUD, forearm, wristTurn);

            done = menu('Do you want to load another box','YES','NO');
            if (done == 2)
                yes = false;
            else
                i = i + 1;
            end
        %There are no more images    
        else
            fprintf('There are no more boxes to sort. Please select NO\n');
            done = menu('Do you want to load another box','YES','NO');
            if (done == 2)
                yes = false;
            else
                i = i + 1;
            end
        end
    end

end

