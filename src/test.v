`timescale 1ns / 1ps

`ifdef ENV_VIVADO
`include "./src/common.v"
`endif
//`include "./src/module_receive_uart_rx.v"

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/10 22:31:29
// Design Name: 
// Module Name: 7seg_disp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
        input wire CLK100MHZ
        , input wire ck_rst
        , input wire rx
        , output wire [3:0] ja
        , output wire [3:0] jb
    );

	/*against meta stabel register*/
	wire r_rx;

	/*wire among module*/
    wire [7:0] disp_number;
    wire [3:0] disp_number_digit1;
    wire [3:0] disp_number_digit2;
    wire [6:0] disp_signal;
    wire [6:0] disp_signal_digit1;
    wire [6:0] disp_signal_digit2;
    wire sel;
    wire [7:0] r_data;
    wire [3:0] num;
    wire received_toggle_signal;/*1セットのascii dataを受信するたびにトグルする信号*/
	wire convert_complete_toggle_signal;


	input_buf i_buf_rx(.clk(CLK100MHZ), .input_signal(rx), .r_bufferd_signal(r_rx)) ;

    /*uartから信号を受信してレジスタに格納する*/
    receive_uart_rx i_receive_uart_rx(
        . clk(CLK100MHZ)
        , .rst(ck_rst)
        , .receive_signal(r_rx)
        , .receive_data(r_data)
        , .received_toggle_signal(received_toggle_signal));

    /*受信データ（asciiコード）を16進数にデコードする*/
    convert_data_to_ascii i_convert_data_to_ascii(
        . clk(CLK100MHZ)
        , .ascii_data(r_data)
        , .rst(ck_rst)
        , .input_strobe(received_toggle_signal)
        , .decoded_hex_num(num)
		, .convert_complete_toggle_signal(convert_complete_toggle_signal));

    /*UART受信完了トグル毎に、受信した番号をFIFOに入れる*/
    add_num_to_fifo i_add_num_to_fifo(
        . clk(CLK100MHZ)
        , .input_data(num)
        , .input_strobe(convert_complete_toggle_signal)
        , .rst(ck_rst)
        , .digit1_data(disp_number_digit1)
        , .digit2_data(disp_number_digit2) );

    /*numに入れた数字（16進数）を7seg表示用の信号にデコードする*/
    convert_num_to_segment i_convert_num_to_segment_digit1(
        . clk(CLK100MHZ)
        ,.num(disp_number_digit1)
        , .rst(ck_rst)
        , .segment(disp_signal_digit1));
    convert_num_to_segment i_convert_num_to_segment_digit2(
        . clk(CLK100MHZ)
        ,.num(disp_number_digit2)
        , .rst(ck_rst)
        , .segment(disp_signal_digit2));

    /*表示桁切り替え信号selを高速で切り替える*/
    toggle_sel i_toggle_sel(
        . clk(CLK100MHZ)
        , .rst(ck_rst)
        , .sel(sel));

    /*sel信号に応じて、表示内容を切り替える。*/
    toggle_digit i_toggle_digit(
        . clk(CLK100MHZ)
        , .sel(sel)
        , .digit1(disp_signal_digit1)
        , .digit2(disp_signal_digit2)
        , .disp(disp_signal));

	genvar i;

	generate
		for(i=0; i<4;i=i+1) begin: block1
			assign ja[i] = disp_signal[i];
		end

		for(i=0; i<3;i=i+1) begin: block2
			assign jb[i] = disp_signal[i+4];
		end
	endgenerate

    assign jb[3] = sel;
endmodule










