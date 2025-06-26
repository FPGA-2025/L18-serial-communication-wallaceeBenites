module transmitter (
    input clk,
    input rstn,
    input start,
    input [6:0] data_in,
    output reg serial_out
);

reg [6:0] intern_data;
wire parity;
reg [3:0] state_machine;


assign parity = ^intern_data;


parameter [3:0] S0  = 4'b0000, 
                S1  = 4'b0001,
                S2  = 4'b0010, 
                S3  = 4'b0011, 
                S4  = 4'b0100, 
                S5  = 4'b0101, 
                S6  = 4'b0110, 
                S7  = 4'b0111, 
                S8  = 4'b1000, 
                S9  = 4'b1001; 

always @(posedge clk, negedge rstn) begin
    if (~rstn) begin
        intern_data <= 7'bxxxxxxx;
        serial_out <= 1'b1;
        state_machine <= S0;
    end
    else begin
        case (state_machine)
            S0: begin
                serial_out <= 1;
                if (start) begin
                  intern_data <= data_in;
                  state_machine <= S1;
                end  
                else begin
                  state_machine <= S0;
                end
            end
            S1: begin
                serial_out <= 0;
                state_machine <= S2;
            end
            S2: begin
                serial_out <= intern_data[0];
                state_machine <= S3;
            end
            S3: begin
                serial_out <= intern_data[1];
                state_machine <= S4;
            end
            S4: begin
                serial_out <= intern_data[2];
                state_machine <= S5;
            end
            S5: begin
                serial_out <= intern_data[3];
                state_machine <= S6;
            end
            S6: begin
                serial_out <= intern_data[4];
                state_machine <= S7;
            end
            S7: begin
                serial_out <= intern_data[5];
                state_machine <= S8;
            end
            S8: begin
                serial_out <= intern_data[6];
                state_machine <= S9;
            end
            S9: begin
                serial_out <= parity;
                state_machine <= S0;
            end
            default: state_machine <= S0;
        endcase
    end
end

endmodule