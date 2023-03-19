`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nenad Ilic
// 
// Create Date: 12/24/2022 04:38:32 PM
// Design Name: Breathing Lights
// Module Name: DoubleDFF
// Project Name: Breathing Lights
// Target Devices: 
// Tool Versions: 
// Description: Simple D Flip-Flop
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DoubleDFF(
    input clk,
    input rst,
    input D,
    output reg Q = 0
    );
    
    //First DFF
    reg hiddenInternalDFF = 0;
    
    always @(posedge clk) begin
        if (rst==1'b1) begin //Synchronous reset
            Q <= 1'b0;
            hiddenInternalDFF <= 1'b0;
        end else begin
            Q <= hiddenInternalDFF;
            hiddenInternalDFF <= D;
        end
    end
endmodule
