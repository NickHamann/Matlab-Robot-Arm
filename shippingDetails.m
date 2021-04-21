function Containers = shippingDetails(Containers)
%shippingDetails is the function for users to assign countries and box
% types to containers.
%  shippingDetails recieves user input for assigning countries and box
%   types to containers without allowing for repeats. The function uses
%   listdlgs to allow for easy user interaction. The function returns a
%   structure with the Country, Weight_limit, and Box_type. The function
%   recieves the structure Containers from the mainMenu and returns it with
%   changes in the fields. 
%   Format: Containers = shippingDetails(Containers) so that the 
%   main strucutre is modified and returned for the mainMenu to use elsewhere.

    %Load excel sheet into a table.
    Details = readtable('ShippingDetails_21.xlsx');

    %Incremental variable for loading the containers in order.
    i = 1;
    countries = Details.Country;
    boxes = Details.Type;

    %Prepping vectors for 'already selected' memory.
    chosen = zeros(1,3);
    newChosen = zeros(1,3);

    %Boolean variables to keep the while loop going.
    happy = false;
    newHappy = false;

    %Boolean variable for checking that the option hasn't already been
    %selected.
    okay = false;

%While the final spot is empty, keep running the program.
while isempty(Containers(3).Box_type)
    %Country while loop.
    while happy == false
        
       selection = listdlg('SelectionMode', 'Single','PromptString',...
           'Please select a country', 'ListString',countries);
       %Check that a selection was made.
       while isempty(selection)
           selection = listdlg('SelectionMode', 'Single','PromptString',...
           'Please select a country', 'ListString',countries);
       end
       
       %Check to see if the country has already been selected.
       for j = 1:3
           if selection == chosen(j)
               fprintf('You have already selected this country\n');
               okay = false;
               break;
           else
               okay = true;
           end
       end
       %If the country hasn't been selected, then assign it to the
       %container.
       if okay
           chosen(i) = selection;
           Containers(i).Country = countries{selection};
           Containers(i).Weight_limit = Details.Container(selection);
           happy = true;
           countries{selection} = 'Already selected';
           okay = false;
       end
    end
    okay = false;
    
    %Box type while loop.
    while newHappy == false
    
       newSelection = listdlg('SelectionMode', 'Single','PromptString',...
           'Please select a box type', 'ListString',boxes);
       %Check that a selection was made.
       while isempty(newSelection)
           newSelection = listdlg('SelectionMode', 'Single','PromptString',...
           'Please select a box type', 'ListString',boxes);
       end
       
        %Check to see if the box type has already been selected.
       for j = 1:3
           if newSelection == newChosen(j)
               fprintf('You have already selected this box type\n');
               okay = false;
               break;
           else
               okay = true;
           end
       end
       %If the box type hasn't been selected, then assign it to the
       %container.
       if okay
           newChosen(i) = newSelection;
           Containers(i).Box_type = boxes{newSelection};
           Containers(i).Small_weight = Details.Small(newSelection);
           Containers(i).Medium_weight = Details.Medium(newSelection);
           Containers(i).Large_weight =Details.Large(newSelection);
           newHappy = true;
           boxes{newSelection} = 'Already selected';
           okay = false;
       end
    end
    okay = false;
    
    %Increment to the next container and reset the boolean variables.
    i = i + 1;
    happy = false;
    newHappy = false;
end

