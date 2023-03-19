//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nenad Ilic
// 
// Create Date: 12/22/2021 12:06:30 PM
// Design Name: Breathing Lights
// Module Name: PWM_Modulator
// Project Name: Breathing Lights
// Target Devices: 
// Tool Versions: 
// Description: This is PWM
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PWM_Modulator(
    input clk, // Clock
    input rst, // Synchronous reset
    input SampleInputEnable, // Enable or disable input value update (allows to freeze duty cycle by disabling this signal)
    input [7:0] Duty_Cycle, // PWM duty cycle, value from 0-255 
    output reg PWM_out // PWM output
    );
    reg [7:0] counter; // Internal counter for duty cycle comparing
    reg [7:0] inputValue; 
    
    //Sample input value
    always @(posedge clk) begin
        if (rst) begin
            inputValue <= 0;
        end else if (SampleInputEnable) begin
            inputValue <= Duty_Cycle;
        end
    end
    
    always @(posedge clk) begin // Triggered by rising edge
        if(rst) begin // Synchronous reset
            counter <= 0; // Reset internal counter for comparing duty cycle
            PWM_out <= 0; // Reset output
        end else begin
            if(counter == 255) begin // Return to zero before overflow
                counter <= 0;
            end else if(counter < inputValue) begin // Control output state duration
                PWM_out <= 1;
                counter <= counter + 1;
            end else begin
                PWM_out <= 0;
                counter <= counter + 1;
            end    
        end
    end
endmodule
