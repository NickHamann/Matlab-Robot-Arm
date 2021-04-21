% OVERVIEW OF CODE:
% This FinalProjectAlgorithm begins by collecting the shipping details
% through the readAndStoreShippingDetails() function, displaying a header
% titled "Setting up Containers", prompting the user to select [x,y]
% coordinates for each country and its associated type.
% The code then creates structure for each container, a boolean vector to
% manage the "fullness" of each container, and a counter to display a bar
% graph at the end.
% After the "Loading Process" header, a while loop starts that's only 
% stopped once all containers are full. In this while loop, the size and
% type of an incoming box are determined, follwed by indexing which
% container they are to be placed in. The weightToAdd() is also found. If
% this weight to be added exceeds the weight limit, it is placed in the
% reject pile, "rejected" is audibly played, the container is marked as
% full, and the rejected counter increments. If this weight DOES NOT exceed
% the weight limit, it tracks the added weight, places the box in the
% correct container, plays the corresponding audio message, and increments
% the container tracker.
% Finally, a stacked bar graph displays the results of the run.



[mCountry, mContainer, mTypes, mCode, mSmall, mMedium, mLarge] = ...
    readAndStoreShippingDetails();

fprintf('\n------------------------------\n');
fprintf('Setting up Containers\n');
fprintf('------------------------------\n\n');

[xCoords, yCoords, selectedCountries, selectedTypes] = ...
    promptShippingMenu(mCountry, mTypes);

% Initiate a structure for the 3 containers and
% fill containerStruct(i) with the user's selected country, its 
% corresponding weight limit, and the user's selected type.

containerStruct(3) = struct('country', '', 'weight_limit', '', ...
    'current_weight', '', 'type', '', 'xcoord', '', 'ycoord', '');
for i = 1:3
    containerStruct(i) = struct('country', mCountry(selectedCountries(i)), ...
        'weight_limit', mContainer(selectedCountries(i)), ...
        'current_weight', 0, ...
        'type', mTypes(selectedTypes(i)), ...
        'xcoord', xCoords(i), ...
        'ycoord', yCoords(i));
end

isCFull = [false, false, false];

% 4 rows: 1 for each container and 1 for reject pile
% 3 columns: 1 for each size
numBoxesPerContainer = zeros(4, 3);

% Create a variable to align the chosen Type to its container
findContainer = [find(selectedTypes == 1), find(selectedTypes == 2), ...
    find(selectedTypes == 3)];

fprintf('\n------------------------------\n');
fprintf('Loading Process\n');
fprintf('------------------------------\n\n');

counter = 1;

% While the containers still have room to fit more boxes...
while ~(isCFull(1) && isCFull(2) && isCFull(3))
    
    % Determine size and type and the right container based off of the 
    % type. Index is either 1, 2, or 3 corresponding to the 1st, 2nd, or
    % 3rd container.
    boxImg = counter + ".png";
    [size, type] = determineBoxSizeAndType(boxImg);
    index = findContainer(type/10 - 1);
    
    % sizeInt represents the numerical of small, medium, or large
    if(strcmpi(size, "small"))
        sizeInt = 1;
    elseif(strcmpi(size, "medium"))
        sizeInt = 2;
    else
        sizeInt = 3;
    end
    
    % Determine weight needed to add
    weightToAdd = findWeightToAdd(mSmall, mMedium, mLarge, ...
        size, index);
    
    % If the weight that needs to be added exceeds the weight limit
    % THIS ISN'T ENTIRELY CORRECT. It should only become true if not even a
    % small box can fit in. (Not entirely sure how to do that tho)
    if containerStruct(index).current_weight + weightToAdd > ...
            containerStruct(index).weight_limit
        playRejectAudio();
        
        % Move the arm to wherever the reject location is
        moveRobotArm(0, 0);
        isCFull(index) = true;      %Maybe I could alter this statement to better measure if a container is full
        fprintf('CONTAINER %d IS FULL\n', index);
        numBoxesPerContainer(4, sizeInt) = ...
            numBoxesPerContainer(4, sizeInt) + 1;
    else 
        % Add the weight to the container
        containerStruct(index).current_weight = ...
            containerStruct(index).current_weight + weightToAdd;
        numBoxesPerContainer(index, sizeInt) = ...
            numBoxesPerContainer(index, sizeInt) + 1;
    
        playAudioFile(size, type);

        % Move the robot arm to the coordinates of the corresponding type
        moveRobotArm(containerStruct(index).xcoord, ...
            containerStruct(index).ycoord);

        % Move the robot arm back to origin
        moveRobotArm(0, 4);
    end
    
    counter = counter + 1;
end

dispGraph(numBoxesPerContainer);

function [mat_country, mat_container, mat_types, mat_code, mat_small, ...
    mat_med, mat_lg] = readAndStoreShippingDetails
    % readAndStoreShippingDetails loads 'ShippingDetails.xlsx' into a table
    % then stores the non-zero values in a matrix of each column.
    % Format: [mat_country, mat_container, mat_types, mat_code, ...
    %     mat_small, mat_med, mat_lg] = readAndStoreShippingDetails

    fid = fopen('ShippingDetails.xlsx');
    if fid == -1
        disp('File open not successful');
    else
        mat = readtable("ShippingDetails.xlsx");
        mat_country = mat.Country(1:length(mat.Country));
        mat_container = mat.Container(1:length(mat.Country));
        mat_types = mat.Type(1:3);
        mat_code = mat.Code(1:3);
        mat_small = mat.Small(1:3);
        mat_med = mat.Medium(1:3);
        mat_lg = mat.Large(1:3);
    end


    closeresult = fclose(fid);
    if closeresult ~= 0
        disp('File close not successful');
    end
end

function [xCoords, yCoords, countryLabel, typeLabel] = ...
    promptShippingMenu(countryList, typeList)
    % promptShippingMenu accepts a list of countries and types, then uses
    % ListDlg to prompt the user to select three countries and their
    % corresponding types. (With error checking and no repeats).
    % Format: [xCoords, yCoords, countryLabel, typeLabel] = 
    % promptShippingMenu(countryList, typeList)
    
    origCountryList = countryList;
    origTypeList = typeList;
    countryLabel = [0, 0, 0];
    typeLabel = [0, 0, 0];
    xCoords = [30.0, 30.0, 30.0];
    yCoords = [30.0, 30.0, 30.0];
    limit = 30;

    % Initiate a structure for the 3 containers
    container(3) = struct('country', '', 'type', '');

    for i = 1:3

        % Accept [X, Y] coordinates
        xCoords(i) = input("Please enter X coordinate of Container " + i +...
            ": ");
        yCoords(i) = input("Please enter Y coordinate of Container " + i +...
            ": ");

        % Error check to make sure coordinates are inside coordinate limit.
        while sqrt(xCoords(i)^2 + yCoords(i)^2) > limit
            fprintf('ERROR: [X, Y] coordinate out of range.\n');
            xCoords(i) = input("Please enter X coordinate of Container " ...
                + i + ": ");
            yCoords(i) = input("Please enter Y coordinate of Container " ...
                + i + ": ");
        end
        % Prompt user to select a country for each i
        countryLabel(i) = listdlg('SelectionMode', 'Single',...
            'PromptString','Please Enter Country Label: ',...
            'ListString', countryList);
        % Error checking
        while strcmp(countryList(countryLabel(i)), '-----') || ...
                strcmp(countryList(countryLabel(i)), '')
            fprintf('ERROR: Invalid selection.\n');
            countryLabel(i) = listdlg('SelectionMode', 'Single',...
                'PromptString','Please Enter Country Label: ',...
                'ListString', countryList);
        end

        % Prompt user to select a type for selected country
        typeLabel(i) = listdlg('SelectionMode', 'Single',...
            'PromptString',"Please enter box type to ship to country.",...
            'ListString', typeList);
        % Error checking
        while strcmp(typeList(typeLabel(i)), '-----') || ...
                strcmp(typeList(typeLabel(i)), '')
            fprintf('ERROR: Invalid selection.\n');
            typeLabel(i) = listdlg('SelectionMode', 'Single',...
                'PromptString',"Please enter box type to ship to country.",...
                'ListString', typeList);
        end

        % Fill container(i) with the user's selected country, its 
        % corresponding weight limit, and the user's selected type
        container(i) = struct('country', countryLabel(i), 'type', ...
            origTypeList(typeLabel(i)));

        % Cross out the previously selected country and type so that the 
        % user can't select it again
        countryList(countryLabel(i)) = {'-----'};
        typeList(typeLabel(i)) = {'-----'};
    end
    
    for i = 1:3
        fprintf('%s will receive %s boxes at [%.2f, %.2f].\n', ...
            char(origCountryList(countryLabel(i))), ...
            char(origTypeList(typeLabel(i))), xCoords(i), yCoords(i));
    end
end

function [boxSize, boxType] = determineBoxSizeAndType(numPNG)
    % determineBoxSize receives an input of a .png file with
    % a picture of a supply on it. This function determines the size of
    % said box and returns either 'Small', 'Medium', or 'Large' for boxSize
    % and returns either 20 (medical), 30 (Food), and 40 (Housing) for 
    % boxType. Currently it simply returns a random selection of one of the
    % three. 
    % Format: [boxSize, boxType] = determineBoxSizeAndType(numPNG)
    
    box = imread(numPNG);
    image(box);
    boxType = box(1,1,1);

    [r0, ~] = find(box == 0);
    first_line = min(r0);

    [rbox, ~] = size(box);
    percent_empty = first_line*100/rbox;
    
    if percent_empty <= 10
        boxSize = "Large";
    elseif percent_empty <= 35
        boxSize = "Medium";
    else
        boxSize = "Small";
    end
end

% function boxType = determineBoxType
%     % determineBoxType will eventually receive an input of a .png file with a
%     % picture of a supply on it. This function will determine the type of
%     % said box and return either 20 for medical, 30 for Food, and 40 for
%     % Housing.
%     % Currently it simply returns a random selection of one of the three
%     % Format: boxType = determineBoxType
% 
%     types = [20, 30, 40];
%     boxType = types(randi([1 3]));
% end

function playAudioFile(boxSize, boxType)
    % playAudioFile will eventually play an audio message saying conveying the
    % size and type of box to the user. For example, a boxSize of 'Large' and
    % boxType of '30' will say:
    % "This is a large box of food."
    % Currently it simply prints out what will be said.
    % Format: playAudioFile(boxSize, boxType)

    if boxType == 20
        strType = 'medical supplies';
    elseif boxType == 30
        strType = 'food';
    else
        strType = 'housing supplies';
    end
    
    printedAudioFile = 'This is a ' + boxSize + ' box of ' + strType + '.';
    fprintf('%s\n', printedAudioFile);
end

function playRejectAudio
    % playRejectAudio audibly says "Rejected"
    % Format: playRejectAudio
    
    fprintf('REJECTED\n');
end

function moveRobotArm(x, y)
    % moveRobotArm moves the robot arm to the provided x and y coordinates.
    % Format: moveRobotArm(x, y)
    
    fprintf('Moved robot arm to [%.2f, %.2f]\n', x, y);
end

function weight = findWeightToAdd(mSmall, mMedium, mLarge, cSize, index)
    % findWeightToAdd gets the weight of the small, medium, or large object and
    % adds it to the correct container to keep track of how full the capacity
    % is.
    % Format: weight = addWeightToContainer(mSmall, mMedium, mLarge, cSize, index)
    
    if(strcmpi(cSize, "small"))
        weight = mSmall(index);
    elseif(strcmpi(cSize, "medium"))
        weight = mMedium(index);
    else
        weight = mLarge(index);
    end
    fprintf('Will add %f weight to container %d.\n', weight, index);
end

function dispGraph(numBoxes)
    % dispGraph displays a stacked bar graph of the number of boxes in each
    % container
    % Format: dispGraph(numBoxes)
    
    b = bar(numBoxes, 'stacked');
    title('Boxes of Each Size in Each Container');
    xlabel('Containers (1,2,3) and Reject Pile (4)');
    ylabel('Number in each Size');
    legend('Small', 'Medium', 'Large', 'Location', 'northwest');
    
    xtips1 = b(1).XEndPoints;
    ytips1 = b(1).YEndPoints;
    labels1 = string(b(1).YData);
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom')
end