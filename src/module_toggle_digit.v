module toggle_digit(input wire clk, input wire sel, input wire [6:0] digit1, input wire [6:0] digit2, output reg [6:0] disp );
    always @ (posedge clk) begin
        if(sel == 0) begin
            disp <= digit1;
        end else begin
            disp <= digit2;
        end
    end
endmodule