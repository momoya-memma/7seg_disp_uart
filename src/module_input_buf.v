`timescale 1ns / 1ps
`ifdef ENV_VIVADO
`include "./src/common.v"
`endif

module input_buf(
	input wire clk
    ,input wire input_signal
    ,output reg r_bufferd_signal
    );

	always @ (posedge clk) begin
		r_bufferd_signal <= input_signal;
	end

endmodule