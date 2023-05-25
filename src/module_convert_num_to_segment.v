module convert_num_to_segment(input wire clk, input wire rst, input wire [3:0] num, output reg [6:0] segment);
    always @(posedge clk) begin 
        if(rst == 0) begin
            segment <= 0;
        end else begin
            segment <= segdec(num);
        end
    end

    function [6:0] segdec;/*数字を7seg displayの表示データにデコードする。*/
        input [7:0] din;
        begin
            case(din)
                4'h0 : segdec = 7'b0111111;
                4'h1 : segdec = 7'b0000110;
                4'h2 : segdec = 7'b1011011;
                4'h3 : segdec = 7'b1001111;
                4'h4 : segdec = 7'b1100110;
                4'h5 : segdec = 7'b1101101;
                4'h6 : segdec = 7'b1111101;
                4'h7 : segdec = 7'b0100111;
                4'h8 : segdec = 7'b1111111;
                4'h9 : segdec = 7'b1101111;
                4'hA : segdec = 7'b1110111;//A
                4'hB : segdec = 7'b1111100;//b
                4'hC : segdec = 7'b0111001;//C
                4'hD : segdec = 7'b1011110;//d
                4'hE : segdec = 7'b1111001;//E
                4'hF : segdec = 7'b1110001;//F
                default:segdec = 7'b1000000;
            endcase
        end
    endfunction
endmodule