clear;
clc;
% Input
x=[0.5 0.4 0.2 0.4 0.0 0.7;
   0.7 0.4 0.1 0.7 0.8 0.7;
   0.5 0.4 0.7 0.7 0.2 0.4;
   1.0 0.8 0.1 0.5 0.4 0.0;
   0.2 0.6 0.5 0.3 0.7 0.3;
   0.1 0.8 0.5 0.1 0.4 0.4; 
   0.1 0.9 0.9 0.6 0.7 0.3;
   0.1 0.1 0.5 0.3 0.4 0.2];
% Weight input to hidden 1
w1=[0.5 0.4 0.2 0.4 0.0 0.7 0.8 0.4;
    0.7 0.4 0.1 0.7 0.8 0.7 0.4 0.2;
    0.5 0.4 0.7 0.7 0.2 0.4 0.9 0.8;
    1.0 0.8 0.1 0.5 0.4 0.0 0.4 0.9;
    0.2 0.6 0.5 0.3 0.7 0.3 0.8 0.3;
    0.1 0.8 0.5 0.1 0.4 0.4 0.4 0.7;];
% Weight hidden 1 to hidden 2
w2=[0.5 0.4 0.2 0.4 0.0 0.7;
    0.7 0.4 0.1 0.7 0.8 0.7;
    0.5 0.4 0.7 0.7 0.2 0.4;
    1.0 0.8 0.1 0.5 0.4 0.0;
    0.2 0.6 0.5 0.3 0.7 0.3;
    0.1 0.8 0.5 0.1 0.4 0.4;
    0.1 0.9 0.9 0.6 0.7 0.3;
    0.1 0.1 0.5 0.3 0.4 0.2];
% Weight hidden 2 to hidden 3
w3=[0.5 0.4 0.2 0.4;
    0.7 0.4 0.1 0.7;
    0.5 0.4 0.7 0.7;
    0.1 0.8 0.1 0.5;
    0.2 0.6 0.5 0.3;
    0.1 0.8 0.5 0.1];
% Weight hidden 3 to output
w4=[0.5 0.4;
    0.7 0.4;
    0.5 0.4;
    1.0 0.8];
% Output
z1=x*w1;
a1=1./(1+exp(-z1));
z2=a1*w2;
a2=1./(1+exp(-z2));
z3=a2*w3;
a3=1./(1+exp(-z3));
z4=a3*w4;
a4=1./(1+exp(-z4));
