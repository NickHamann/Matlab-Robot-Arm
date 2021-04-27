function moveArm(x,y,a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn)
%This function moves the robot arm to grab a box and place it in the
% appropriate location.
%
% Format: moveArm(x,y).
    
    %For setup.
    radius = sqrt(x^2+y^2);
    angle = atand(y/x);
    if (x < 0)
        angle = angle + 180;
    end
    wristMove = 0.5;

    %extra error checking. Shouldn't need it.
    if (radius < 10 || radius > 30)
        fprintf('Ya done goofed\n');

    else
        %Pick Up Procedure.
        fprintf('Picking up\n');
        writePosition(gripper, 0.7);
        moveservo(shoulder, 0.32);
        moveservo(elbow, 0.43); %Thick coin 0.38
        writePosition(gripper, 0.888);
        moveservo(elbow, 0.3);
        moveservo(shoulder, 0.4);
        
        %Drop Down Procedure.
        fprintf('Dropping\n');
        %If the radius is less than 12, then arm will use wristUD.
        if (radius <= 12)
            shoulderMove = 0.8;
            elbowMove = 0.15;
            wristMove = 0.045 * radius - 0.32;

        %If the radius is less than or equal to 15, then arm will use
        % wristUD.
        elseif (radius <= 15)
            shoulderMove = 0.8;
            elbowMove = 0.0167 * radius - 0.05;
            wristMove = 0.06 * radius - 0.5;

        %If the radius is less than or equal to 25, then arm won't use wristUD
        % and elbow is always 0.35.
        elseif (radius <= 25)
%             shoulderMove = -0.0266 * radius + 1.0869;
            shoulderMove = -0.0266 * radius + 1.1269;
            elbowMove = 0.35;

        %If the radius is greater than 25.
        else
%             shoulderMove = -0.018 * radius + 0.89;
            shoulderMove = -0.018 * radius + 0.93;
            elbowMove = -0.01 * radius + 0.6;
        end

        %Angle stuff cuz arm ain't great.
        if (angle > 90 && angle <= 178)
            angle = angle + 2;
        elseif (angle < 90 && angle >= 2)
            angle = angle - 2;
        end

        %Moving time.
        moveservo(base, angle/180);
        moveservo(shoulder, shoulderMove);
        moveservo(elbow, elbowMove);
        moveservo(wristUD, wristMove);
        pause(0.8);
        writePosition(gripper, 0.7);

        %Set to moving position.
        fprintf('Back to Moving Position\n');
        moveservo(wristUD, 0.5);
        moveservo(elbow, 0.3);
        moveservo(shoulder, 0.4);
        
        %Moving back to home position
        moveservo(base, 0);
    end
        
end

