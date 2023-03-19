//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nenad Ilic
// 
// Create Date: 12/21/2021 04:55:52 PM
// Design Name: Breathing Lights
// Module Name: Color_Source
// Project Name: Breathing Lights
// Target Devices: 
// Tool Versions: 
// Description: This is implementation of state machine for selecting color mode change on LEDs
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Color_Source(
    input clk, //Clock
    input rst, //Synchonous reset
    input SelectMode, //Change machine state - color mix mode 
    output reg [7:0] PWM_Red, //Output signal for intensity on Red LED (0-255)
    output reg [7:0] PWM_Green, //Output signal for intensity on Green LED (0-255)
    output reg [7:0] PWM_Blue //Output signal for intensity on Blue LED (0-255)
    );

    //-------------State Machine sates--------------------------
    parameter MachineSize = 3;
    parameter IDLE  = 3'b001, MIXED_COLORS = 3'b010, SINGLE_COLORS = 3'b100;

    //-------------Machine states---------------------------
    reg   [MachineSize-1:0]          state;		// Seq part of the FSM
    wire  [MachineSize-1:0]          next_state;	// combo part of FSM
    
    //Internal counter for prescaling frequency
    reg [32:0] counter = 0;
    
    //Previous state of input SelectMode
    reg PreviousSelectMode;
    
    //Prescaler register
    reg [32:0] toggle_after_cycles = 32'h40000; //32 bit hex value of (262144)DEC for dividing frequency;
    reg scaled_clk = 0; //Prescaled clock
    reg scaled_clk_g = 0; //clock for green color
    reg scaled_clk_b = 0; //clock for blue color
    
    //Direction of counters for individual colors (1 - incrementing; 0 - decrementing)
    reg Direction_Red = 1;
    reg Direction_Green = 1;
    reg Direction_Blue = 1;
    
    //Change of colors on RGB LEDs, bit 0 - direction of counting, bit 1 - enable change on this diode
    reg [1:0] Change_Red_S = 2'b11;
    reg [1:0] Change_Green_S = 2'b00;
    reg [1:0] Change_Blue_S = 2'b00;
    
    //Enable operation modes
    reg EnableMixedColors = 0;
    reg EnableSingleColors = 0;
    
    //PWM values for MIXED_COLORS mode
    reg [7:0] MixedColor_PWM_r;
    reg [7:0] MixedColor_PWM_g;
    reg [7:0] MixedColor_PWM_b;
    
    //PWM values for SINGLE_COLORS mode 
    reg [7:0] SingleColor_PWM_r;
    reg [7:0] SingleColor_PWM_g;
    reg [7:0] SingleColor_PWM_b;

    assign next_state = fsm_function(state, SelectMode);
    
    //----------Function for Combo Logic-----------------
    function [MachineSize-1:0] fsm_function;
        input  [MachineSize-1:0]  state;	
        input    SelectMode;
        case(state)
            IDLE : if (SelectMode == 1'b1 && PreviousSelectMode == 1'b0) begin
                fsm_function = MIXED_COLORS;
            end else begin
                fsm_function = IDLE;
            end
            MIXED_COLORS : if (SelectMode == 1'b1 && PreviousSelectMode == 1'b0) begin
                fsm_function = SINGLE_COLORS;
            end else begin
                fsm_function = MIXED_COLORS;
            end
            SINGLE_COLORS : if (SelectMode == 1'b1 && PreviousSelectMode == 1'b0) begin
                fsm_function = IDLE;
            end else begin
                fsm_function = SINGLE_COLORS;
                end
            default : fsm_function = MIXED_COLORS;
            endcase
    endfunction

    //----------Seq Logic-----------------------------
    always @ (posedge clk)
    begin : FSM_SEQ
        if (rst == 1'b1) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end            

    always @(posedge clk) //Triggered by rising edge
    begin : OUTPUT_LOGIC
        if (rst == 1'b1) begin //Synchronous reset
           //counter=0;
        end else begin
            case(state)
                IDLE : begin
                    EnableMixedColors <= 0;
                    EnableSingleColors <= 0;
                    PWM_Red <= 0;
                    PWM_Green <= 0;
                    PWM_Blue <= 0;
                end
                MIXED_COLORS : begin
                    EnableMixedColors <= 1;
                    EnableSingleColors <= 0;
                    PWM_Red <= MixedColor_PWM_r;
                    PWM_Green <= MixedColor_PWM_g;
                    PWM_Blue <= MixedColor_PWM_b;
                end
                SINGLE_COLORS : begin
                    EnableSingleColors <= 1;
                    EnableMixedColors <= 0;
                    PWM_Red <= SingleColor_PWM_r;
                    PWM_Green <= SingleColor_PWM_g;
                    PWM_Blue <= SingleColor_PWM_b;
                end
                default : begin
                    EnableMixedColors <= 0;
                    PWM_Red <= 255;
                    PWM_Green <= 0;
                    PWM_Blue <= 0;
                end
            endcase
        end
     end
 
    //Store last SelectMode value
    always @(posedge clk) begin
        PreviousSelectMode <= SelectMode;
    end
    
    //Clock prescaler
    always @(posedge clk) begin //Triggered by rising edge
        if(rst) begin //Synchronous reset
            counter=0;
        end else begin
            counter <= counter + 1;
            if(counter >= toggle_after_cycles) begin
                scaled_clk = ~scaled_clk;
                counter <= 0;
            end
        end
    end

    //----------------- MIXED_COLORS mode -----------------//
    //Determine RED color intensity
    always @(posedge scaled_clk) begin
        if (rst) begin
            MixedColor_PWM_r <= 0;
        end else if(EnableMixedColors) begin 
            if(MixedColor_PWM_r == 255) begin
                Direction_Red = 0;
                MixedColor_PWM_r = MixedColor_PWM_r - 1;
            end else begin
                if(MixedColor_PWM_r == 0) begin
                    Direction_Red = 1;
                    MixedColor_PWM_r = MixedColor_PWM_r + 1;
                end else begin
                    if (Direction_Red == 1) begin
                        MixedColor_PWM_r = MixedColor_PWM_r + 1;
                    end else begin
                        MixedColor_PWM_r = MixedColor_PWM_r - 1;
                    end                            
                end
            end
        end
        scaled_clk_g = ~scaled_clk_g;
    end
    
    //Determine GREEN color intensity
    always @(posedge scaled_clk_g) begin
        if (rst) begin
            MixedColor_PWM_g <= 0;
        end else if(EnableMixedColors) begin
            if(MixedColor_PWM_g == 255) begin
                Direction_Green = 0;
                MixedColor_PWM_g = MixedColor_PWM_g - 1;
            end else begin
                if(MixedColor_PWM_g == 0) begin
                    Direction_Green = 1;
                    MixedColor_PWM_g = MixedColor_PWM_g + 1;
                end else begin
                    if (Direction_Green == 1) begin
                        MixedColor_PWM_g = MixedColor_PWM_g + 1;
                    end else begin
                        MixedColor_PWM_g = MixedColor_PWM_g - 1;
                    end                            
                end
            end
        end
        scaled_clk_b = ~scaled_clk_b;
    end
    
    //Determine BLUE color intensity
    always @(posedge scaled_clk_b) begin
        if (rst) begin
            MixedColor_PWM_b <= 0;
        end else if(EnableMixedColors) begin
            if(MixedColor_PWM_b == 255) begin
                Direction_Blue = 0;
                MixedColor_PWM_b = MixedColor_PWM_b - 1;
            end else begin
                if(MixedColor_PWM_b == 0) begin
                    Direction_Blue = 1;
                    MixedColor_PWM_b = MixedColor_PWM_b + 1;
                end else begin
                    if (Direction_Blue == 1) begin
                        MixedColor_PWM_b = MixedColor_PWM_b + 1;
                    end else begin
                        MixedColor_PWM_b = MixedColor_PWM_b - 1;
                    end                            
                end
            end
        end
    end
    
    //----------------- SINGLE_COLORS mode -----------------//
    always @(posedge scaled_clk) begin
    if(rst) begin //Synchronous reset
        SingleColor_PWM_r <= 0;
        SingleColor_PWM_g <= 0;
        SingleColor_PWM_b <= 0;
    //Control change on RED diode   
    end else if(Change_Red_S[1] && EnableSingleColors) begin //Red is seleted for a change
        if(Change_Red_S[0]) begin//Increasing intensity on red channel
            if(SingleColor_PWM_r < 255) begin
                SingleColor_PWM_r <= SingleColor_PWM_r + 1;
            end else begin
                SingleColor_PWM_r <= SingleColor_PWM_r - 1;
                Change_Red_S[0] <= 0; //Decrease intensity on RED LED from now on
            end
        end else begin //Decreasing intensity on red channel
            if(SingleColor_PWM_r > 0) begin
                SingleColor_PWM_r <= SingleColor_PWM_r -1;
            end else begin
                SingleColor_PWM_r <= 0;
                Change_Red_S[1] <= 0; //Stop change on RED LED
                Change_Green_S <= 2'b11; //Start change on Green LED
            end
       end
    //Control change of color on green diode   
    end else if (Change_Green_S[1] && EnableSingleColors) begin //Green is seleted for a change
        if(Change_Green_S[0]) begin//Increasing intensity on green channel
            if(SingleColor_PWM_g < 255) begin
                SingleColor_PWM_g <= SingleColor_PWM_g + 1;
            end else begin
                SingleColor_PWM_g <= SingleColor_PWM_g - 1;
                Change_Green_S[0] <= 0; //Decrease intensity on GREEN LED from now on
            end
        end else begin //Decreasing intensity on green channel
            if(SingleColor_PWM_g > 0) begin
                SingleColor_PWM_g <= SingleColor_PWM_g -1;
            end else begin
                SingleColor_PWM_g <= 0;
                Change_Green_S[1] <= 0; //Stop change on Green LED
                Change_Blue_S <= 2'b11; //Start change on Blue LED
            end
       end
    //Control change of color on blue diode      
    end else if (Change_Blue_S[1] && EnableSingleColors) begin //Blue is seleted for a change
        if(Change_Blue_S[0]) begin//Increasing intensity on blue channel
            if(SingleColor_PWM_b < 255) begin
                SingleColor_PWM_b <= SingleColor_PWM_b + 1;
            end else begin
                SingleColor_PWM_b <= SingleColor_PWM_b - 1;
                Change_Blue_S[0] <= 0; //Decrease intensity on BLUE LED from now on
            end
        end else begin //Decreasing intensity on blue channel
            if(SingleColor_PWM_b > 0) begin
                SingleColor_PWM_b <= SingleColor_PWM_b -1;
            end else begin
                SingleColor_PWM_b <= 0;
                Change_Blue_S[1] <= 0; //Stop change on Blue LED
                Change_Red_S <= 2'b11; //Start change on Red LED
            end
       end
    end

end                                      

endmodule
