
module add_num_to_fifo(input wire clk,input wire [3:0] input_data, input wire shift_clk, input wire rst, output reg [3:0]digit1_data, output reg [3:0]digit2_data);
    reg previous_shift_clk;
    reg [6:0] delay_counter;

    always @(posedge clk) begin
        if(rst == 0) begin
            digit1_data <= 0;
            digit2_data <= 0;
            previous_shift_clk <= 0;
            delay_counter <= 0;
        end else begin
            if(previous_shift_clk == shift_clk) begin
            end else begin
                if(delay_counter > 7'd100) begin/*input_dataの値が確定するまで100カウント遅延させてから取得する*/
                    digit1_data <= input_data;
                    digit2_data <= digit1_data;
                    previous_shift_clk <= ~previous_shift_clk;
                    delay_counter <= 7'b0;
                end else begin
                    delay_counter <= delay_counter+7'b1;
                end
            end
        end
    end
endmodule