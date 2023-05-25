module convert_data_to_ascii(input wire clk,input wire [7:0] ascii_data, input wire rst, input wire received_toggle_signal, output reg [3:0] decoded_hex_num);
    reg previous_toggle_signal;
    always @ (posedge clk) begin
        if(rst == 0) begin
            decoded_hex_num <= 0;
            previous_toggle_signal <= 0;
        end else begin
            if(previous_toggle_signal == received_toggle_signal) begin
            end else begin
                decoded_hex_num <= asciidec(ascii_data);
                previous_toggle_signal <= received_toggle_signal;
            end

        end
    end

    function [3:0]asciidec;/*8bitデータをasciiコードで数字にデコードする。*/
    input [7:0] din;
    begin
        case(din)
            8'h30 : asciidec = 4'h0;
            8'h31 : asciidec = 4'h1;
            8'h32 : asciidec = 4'h2;
            8'h33 : asciidec = 4'h3;
            8'h34 : asciidec = 4'h4;
            8'h35 : asciidec = 4'h5;
            8'h36 : asciidec = 4'h6;
            8'h37 : asciidec = 4'h7;
            8'h38 : asciidec = 4'h8;
            8'h39 : asciidec = 4'h9;
            8'h61 : asciidec = 4'hA;//a
            8'h62 : asciidec = 4'hB;//b
            8'h63 : asciidec = 4'hC;//c
            8'h64 : asciidec = 4'hD;//d
            8'h65 : asciidec = 4'hE;//e
            8'h66 : asciidec = 4'hF;//f
            8'h41 : asciidec = 4'hA;//A
            8'h42 : asciidec = 4'hB;//B
            8'h43 : asciidec = 4'hC;//C
            8'h44 : asciidec = 4'hD;//D
            8'h45 : asciidec = 4'hE;//E
            8'h46 : asciidec = 4'hF;//F
            default:asciidec = 4'h0;
        endcase
    end
    endfunction

endmodule