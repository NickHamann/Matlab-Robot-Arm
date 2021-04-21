clear all;
clear a;
[a, gripper, base, elbow, shoulder, wristUD, forearm, wristTurn] = startUpRoutine();

moveArm(15,15,a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn);
moveArm(7.5,22.5,a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn);
moveArm(-20,4,a,gripper, base, elbow, shoulder, wristUD, forearm, wristTurn);