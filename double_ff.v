module double_ff #(           // この回路はバグの元
    parameter DATA_BITS = 8
) (
    input wire clk,
    input wire [DATA_BITS-1:0] idata,
    output reg [DATA_BITS-1:0] odata
);
    reg [DATA_BITS-1:0] temp;
    always @(clk) begin
        temp <= idata;
        odata <= temp;
    end
endmodule