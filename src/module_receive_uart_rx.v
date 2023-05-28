`timescale 1ns / 1ps
`ifdef ENV_VIVADO
`include "./src/common.v"
`endif

module receive_uart_rx(
	input wire clk
	, input wire rst 
	, input wire receive_signal
	, output reg [7:0] receive_data
	, output reg received_toggle_signal);

    parameter STATE_IDLE = 0;
    parameter STATE_1ST_NEGEDGE = 1;
    parameter STATE_FETCH_DATA = 2;
    parameter STATE_WAIT_1PERIOD = 3;

    parameter CLOCK_UART = 10416 ; // 1sec/9600*100MHz
    parameter CLOCK_UART_HALF = CLOCK_UART / 2; // 9BIT

    reg [3:0] state;
    reg [16:0] uart_counter;
    reg [7:0] data_counter;
    reg [7:0] receive_data_buf;

    always @ (posedge clk) begin
        if(rst == 0) begin
            receive_data <= 8'b0;
            state <= 4'b0;
            uart_counter <= 17'b0;
            data_counter <= 8'b0;/*今、uart 8bit dataのうち、何番目のデータを受信待ちか*/
            received_toggle_signal <= 0;/*今、*/
        end else begin
            if(state == STATE_IDLE) begin/*negedge待ち受け状態*/
                if(receive_signal == 0) begin
                    state <= STATE_1ST_NEGEDGE;
                end
            end else if(state == STATE_1ST_NEGEDGE) begin/*1.5BIT分の時間を待つ*/
                if(uart_counter > CLOCK_UART+CLOCK_UART_HALF) begin
                    state <= STATE_FETCH_DATA;
                    uart_counter <= 17'b0;
                end else begin
                    uart_counter <= uart_counter+ 17'b1;                
                end
            end else if(state == STATE_FETCH_DATA) begin
                if(data_counter == 4'h8) begin
                    data_counter <= 4'b0;
                    receive_data <= receive_data_buf;
                    received_toggle_signal <= ~received_toggle_signal;
                    state <= STATE_IDLE;
                end else begin
                    receive_data_buf[data_counter] <= receive_signal;
                    state <= STATE_WAIT_1PERIOD;
                end
            end else if(state == STATE_WAIT_1PERIOD) begin/*1BIT分の時間を待つ*/
                if(uart_counter > CLOCK_UART) begin
                    data_counter <= data_counter+4'b1;
                    state <= STATE_FETCH_DATA;
                    uart_counter <= 17'b0;
                end else begin
                    uart_counter <= uart_counter+ 17'b1;                
                end
            end
        end
    end
endmodule