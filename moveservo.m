function moveservo(servosel, des_position)
    % This function smoothly moves the servo specifed by servosel to the
    % desired position (des_position).  The servo specified by servosel must
    % have already been defined with a command such as base = servo(a, 'D3'),
    % where a is the arduino a = arduino('COM10','uno', 'Libraries', 'Servo');
    % Rather than jump as quickly as possible to the desired location, the
    % servo is moved 0.01 every del_dur (0.0005 seconds).
    % Dr. Randy Fish, August 20, 2019

        del_dur = 0.0005; %Delay between each position update
        pos_delta = 0.01; % amount to update the current position
        current_pos = readPosition(servosel);
        if des_position < current_pos
            pos_delta = -pos_delta; % reduce the current position
        end
        while abs(des_position - current_pos) > abs(pos_delta)
            updated_pos = current_pos + pos_delta;
            writePosition(servosel,updated_pos);
            pause(del_dur);
            current_pos = readPosition(servosel);
        end
end