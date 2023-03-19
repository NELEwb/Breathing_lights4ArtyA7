`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nenad Ilic
// 
// Create Date: 22/11/2021 06:23:58 PM
// Design Name: 
// Module Name: BreathingLightsSim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BreathingLightsSim;

    reg clk, rst, SampleInputEnable, SelectMode;
    wire out_r1, out_g1, out_b1;
    //clock clk_period = 5 * timescale = 5 * 1 ns  = 5ns
    localparam clk_period = 5;
    PWM_Lights PWM_MODULATORS_4TESTING (.clk(clk), .rst(rst), .SampleInputEnable(SampleInputEnable), .SelectMode(SelectMode), .out_r1(out_r1), .out_g1(out_g1), .out_b1(out_b1));
    
    initial
    begin
        clk = 1'b0; //Inital clk is 0 
        SampleInputEnable = 1'b1; //Enable input on PWM
        SelectMode = 1'b0; 
        rst = 1'b0;
        #(4*clk_period); // wait for 4 periods
        rst = 1'b1;
        #(40000); // wait 4 periods
        rst = 1'b0;
        #(10000); // wait 1 period
        SelectMode = 1'b1; //Change machine state
        #(10000); // wait 1 period
        SelectMode = 1'b0;
    end
    
    always
    begin
        clk = ~clk;
        #clk_period;
    end

endmodule
