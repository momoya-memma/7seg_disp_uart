module toggle_sel(input wire clk, input wire rst,output reg sel);
    parameter count_up = 1000000;//100MHz * 10msec
    //parameter count_up = 10000;//100MHz * 10msec
    reg [19:0] counter;
    always @ (posedge clk) begin
        if(rst == 0) begin
            sel <= 0;
            counter <= 20'b0;
        end else begin
            if(counter == count_up) begin
                counter <= 20'b0;
                sel <=~sel;
            end else begin
                counter <= counter +20'b1;
            end
        end
    end
endmodule