//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nenad Ilic
// 
// Create Date: 12/21/2021 11:56:31 AM
// Design Name: Breathing Lights
// Module Name: PWM_Lights
// Project Name: Breathing Lights
// Target Devices: Arty A7-100T
// Tool Versions: Vivado v2019.1 (64-bit)
// Description: This project implements state machine for selecting mode for selection of color intensity on LEDs
// 
// Dependencies: 
// 
// Revision: 2.0
// Revision 2.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module PWM_Lights(
    input clk, //Clock
    input rst, //Synchronous reset
    input SampleInputEnable, //Enable sampling (continue/freeze color change)
    input SelectMode, //Change machine state - color mix mode
    output out_r1, //Output of Red LED 1
    output out_g1, //Output of Green LED 1
    output out_b1, //Output of Blue LED 1
    output out_r2, //Output of Red LED 2
    output out_g2, //Output of Green LED 2
    output out_b2, //Output of Blue LED 2
    output out_r3, //Output of Red LED 3
    output out_g3, //Output of Green LED 3 
    output out_b3, //Output of Blue LED 3
    output out_r4, //Output of Red LED 4
    output out_g4, //Output of Green LED 4
    output out_b4 //Output of Blue LED 4
    );
    
    //Wires for connecting color source to PWM modulators
    wire [7:0] PWM_R;
    wire [7:0] PWM_G;
    wire [7:0] PWM_B;
    
    //Wires for connecting PWM signals to module output
    wire PWM_O_R, PWM_O_G, PWM_O_B;
    
    //Wires for double D flip-floped input signals (SelectMode, SampleInputEnable)
    wire SelectModeDFFd;
    wire SampleInputEnableDFFd;
    
    //Wire for debouncing SelectMode input
    wire DebouncedSelectMode;
    
    //Double flip-flop inputs
    DoubleDFF DoubleDFF_SelectMode_input(clk, rst, SelectMode, SelectModeDFFd);
    DoubleDFF DoubleDFF_SampleInputEnable_input(clk, rst, SampleInputEnable, SampleInputEnableDFFd);
    
    //Debounce input for SelectMode
    DeBounce DebounceSelectMode_input(clk, ~rst, SelectModeDFFd, DebouncedSelectMode);
    
    //Controls RGB values for PWM
    Color_Source Color_Controller(clk, rst, DebouncedSelectMode, PWM_R, PWM_G, PWM_B);
    
    //PWM modulators for Red, Green, and Blue color:
    PWM_Modulator PWM_Modulator_R(clk, rst, SampleInputEnableDFFd, PWM_R, PWM_O_R);
    PWM_Modulator PWM_Modulator_G(clk, rst, SampleInputEnableDFFd, PWM_G, PWM_O_G);
    PWM_Modulator PWM_Modulator_B(clk, rst, SampleInputEnableDFFd, PWM_B, PWM_O_B);
    
    //Connect PWM signals with module outputs
    assign out_r1 = PWM_O_R;
    assign out_g1 = PWM_O_G;
    assign out_b1 = PWM_O_B;
    assign out_r2 = PWM_O_R;
    assign out_g2 = PWM_O_G;
    assign out_b2 = PWM_O_B;
    assign out_r3 = PWM_O_R;
    assign out_g3 = PWM_O_G;
    assign out_b3 = PWM_O_B;
    assign out_r4 = PWM_O_R;
    assign out_g4 = PWM_O_G;
    assign out_b4 = PWM_O_B;
endmodule

