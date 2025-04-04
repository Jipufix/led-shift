`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Christian Lopez & Ashton Char
// 
// Create Date: 04/17/2024 01:53:03 PM
// Module Name: led_shift
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_reg(
    input clk,
    input strobe_1hz,
    input [3:0] state,  // State is a 3-bit binary number representing the state of the board where X (dont care) >= 4
    input [7:0] d_in,   // Contains the 8-bit loaded sequence
    output [7:0] led
    );
    
    // Contains the output to be assigned to led
    reg [7:0] out;
    
    //setting up the parameter binary states
    parameter LEFT_SHIFT = 0;   // btnl
    parameter LOAD = 1;         // btnu
    parameter RIGHT_SHIFT = 2;  // btnr
    parameter CLEAR = 3;        // btnd
    
    always @(posedge clk) begin
        if (state[CLEAR]) begin
            out <= 8'b0;
        end
        
        else if (state[LOAD]) begin
            out <= d_in;
        end
        
        else if (strobe_1hz)
            if (state[LEFT_SHIFT]) begin      // Left Shift
                out  <= {out[6:0], out[7]};
            end
            
            else if (state[RIGHT_SHIFT]) begin                          // Right Shift 
                out <= {out[0], out[7:1]};
            end
        
//        case (state)
//            CLEAR: begin
//                register <= 8'b0;
//            end
    
//            LOAD: begin
//                register <= d_in;
//            end
    
//            LEFT_SHIFT: begin
//                register <= {register[6:0], register[7]};
//            end
    
//            RIGHT_SHIFT: begin
//                register <= {register[0], register[7:1]};
//            end
//        endcase
    end
    
    // Assign the output to the led
    assign led = out;
    
endmodule
