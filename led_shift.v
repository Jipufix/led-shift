`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Christian Lopez & Ashton Char
// 
// Create Date: 04/17/2024 01:53:03 PM
// Module Name: led_shift
// 
//////////////////////////////////////////////////////////////////////////////////

module led_shift(
    input [7:0] switch,
    input [3:0] btns,
    input clk,
    output [7:0] led
    );
    
    //setting up the parameter binary states
    parameter LEFT_SHIFT = 0;   // BTNL
    parameter LOAD = 1;         // BTNU
    parameter RIGHT_SHIFT = 2;  // BTNR
    parameter CLEAR = 3;        // BTND
    
    // Variables for current state and next stat
    reg [3:0] state = 4'b1000; // Initialize both as clear initially
    reg [3:0] next_state;
    
    // Generate the strobe frequency, which should be around 1 Hz
    reg [31:0] counter;
    reg strobe_1hz;
    parameter top_count = 100000000 - 1; // 1 Hz
    
    always @(posedge clk) begin
        if (counter >= top_count) begin
            strobe_1hz = 1'b1;
            counter = 32'b0;
        end else begin
            strobe_1hz = 1'b0;
            counter = counter + 32'b1;
        end
    end
     
    always @ (posedge clk) begin
        state <= next_state;
    end
    
    // Combinational logic
    always @(*) begin
    
        next_state = 4'b0;
        
        case (1'b1)
        
            state[CLEAR]: begin
                if (btns[1])
                    next_state[LOAD] = 1'b1;
                else
                    next_state[CLEAR] = 1'b1;
            end
                
            state[LOAD]: begin
                if (btns[0])
                    next_state[LEFT_SHIFT] = 1'b1;
                else if (btns[2]) 
                    next_state[RIGHT_SHIFT] = 1'b1;
                else if (btns[3])
                    next_state[CLEAR] = 1'b1;
                else
                    next_state[LOAD] = 1'b1;
            end
                
            state[LEFT_SHIFT]: begin
               if (btns[1])
                    next_state[LOAD] = 1'b1;
               else if (btns[2]) 
                    next_state[RIGHT_SHIFT] = 1'b1;
               else if (btns[3])
                    next_state[CLEAR] = 1'b1;
               else
                    next_state[LEFT_SHIFT] = 1'b1;
            end
               
            state[RIGHT_SHIFT]: begin
               if (btns[1])
                    next_state[LOAD] = 1'b1;
               else if (btns[0]) 
                    next_state[LEFT_SHIFT] = 1'b1;
               else if (btns[3])
                    next_state[CLEAR] = 1'b1;
               else
                    next_state[RIGHT_SHIFT] = 1'b1;
            end
            
        endcase
        
    end
    
    shift_reg sr(clk, strobe_1hz, state, switch, led);
    
endmodule
