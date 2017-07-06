`timescale 1ns / 1ps

module ring_osc #(NUM_LUTS = 9) (
    input en,
	output osc_out
);

wire [NUM_LUTS:0] lut_wire;

genvar i;

generate for (i=0;i<NUM_LUTS-1;i=i+1)
begin : lut_ring

	(*DONT_TOUCH= "true"*) LUT1 #(
            .INIT(2'b01) //Logic function (to make the lut behave as a not. lut1 2'h1, lut2 2'h4 for first bit)
        ) 
        lcell_inst (
            .I0  ( lut_wire[i] ),
            .O ( lut_wire[i+1] )
    );

end
endgenerate

    assign osc_out = lut_wire[NUM_LUTS];
    
    (*DONT_TOUCH= "true"*) LUT2 #(
                .INIT(4'b1010) //Logic function  
            ) 
            en_lut (
                .I0(lut_wire[NUM_LUTS-1]), 
                .I1(en), .
                O(osc_out)
    );
    
    assign lut_wire[0] = osc_out;

endmodule
