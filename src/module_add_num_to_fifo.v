
`timescale 1ns / 1ps

`ifdef ENV_VIVADO
`include "./src/common.v"
`endif

module add_num_to_fifo(
	input wire clk
	,input wire [3:0] input_data
	, input wire input_strobe
	, input wire rst
	, output reg [3:0]digit1_data
	, output reg [3:0]digit2_data);

    reg previous_shift_clk;
	reg input_strobe_buf;

	/*ストローブ信号とほかの入力信号が同位相で入ってくると、入力信号を入力ストローブ信号でフェッチする際に、
	set up時間が満たせないので、一度ストローブ信号をレジスタで受けることで位相を遅らせる。*/
	always @ (posedge clk) begin
        if(rst == 0) begin
			input_strobe_buf <= 0;
        end else begin
			input_strobe_buf <= input_strobe;
		end
	end

    always @(posedge clk) begin
        if(rst == 0) begin
            digit1_data <= 0;
            digit2_data <= 0;
            previous_shift_clk <= 0;
        end else begin
            if(previous_shift_clk == input_strobe_buf) begin
            end else begin
                digit1_data <= input_data;
                digit2_data <= digit1_data;
                previous_shift_clk <= input_strobe_buf;
            end
        end
    end

endmodule