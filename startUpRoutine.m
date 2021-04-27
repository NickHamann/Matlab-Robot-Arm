function [a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn] = startUpRoutine()
%startUpRoutine() creates a connection to the arduino and creates a
% variable connected to each motor.
%
% Format: [a, gripper, base, elbow, shoulder, wristUD, forearm,
%  wristTurn] = startUpRoutine().

    clear all;
    close all;
    comdef = 'COM14';
    
    [a,gripper,base,elbow,shoulder,wristUD,forearm,wristTurn] = init_servos(comdef);
end

function [a,gripper,base,elbow,shoulder,wristUD,forearm,wristTurn] = init_servos(comdef)
    %This function loads the Arduino library and initializes the DX_6 servos
    %to the indicated names and default settings.
    %The library and associated COM port are stored in a.
    %Initialize Arduino
    %Dr. Randy Fish, February 20, 2021.

    a = arduino(comdef,'uno', 'Libraries', 'Servo');
    % Initialize the servos
    
    
    base = servo(a, 'D3');
    writePosition(base, 0);
%     moveservo(base, 0.5);
    
    shoulder = servo(a, 'D5');
    writePosition(shoulder, 0.5);
%     moveservo(shoulder, 0.4);
    
    elbow = servo(a, 'D6');
    writePosition(elbow, 0.2);
%     moveservo(elbow, 0.3);
    
    wristUD = servo(a, 'D9');
    writePosition(wristUD, 0.5);
%     moveservo(wristUD, 0.5);
    
    wristTurn = servo(a, 'D11');
    writePosition(wristTurn, 0.5);
%     moveservo(wristTurn, 0.5);
    
    forearm = servo(a, 'D10');
    writePosition(forearm, 0.5);
%     moveservo(forearm, 0.5);

gripper = servo(a, 'D2');
    writePosition(gripper, 0.7);
%     moveservo(gripper, 0.5);
    
end