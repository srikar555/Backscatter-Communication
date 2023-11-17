module radix4_fft( input signed clk,
                  input signed rst,
                  input signed [511:0] pt_r_in,
                  input signed [511:0] pt_i_in,
                  output wire signed  [511:0] pt_r_out,
                  output wire signed  [511:0] pt_i_out);
  wire signed  [31:0]stage1_ff_r_out[15:0];
  wire signed  [31:0]stage1_ff_i_out[15:0];
  wire signed  [31:0]stage2_ff_r_in[15:0];
  wire signed  [31:0]stage2_ff_i_in[15:0];
  wire signed  [31:0]stage2_ff_r_out[15:0];
  wire signed  [31:0]stage2_ff_i_out[15:0];
  wire signed  [31:0]stage3_ff_r_in[15:0];
  wire signed  [31:0]stage3_ff_i_in[15:0];
  genvar i;
  generate
    for(i=0;i<16;i=i+1)
      begin 
        Dff ff_stage1(clk,
               rst,
                      pt_r_in[(i+1)*32-1:i*32],
                      pt_i_in[(i+1)*32-1:i*32],
               stage1_ff_r_out[i],
               stage1_ff_i_out[i]);
      end
    for(i=0;i<16;i=i+4)
      begin 
        butterfly1 bf1(stage1_ff_r_out[i],
                     stage1_ff_i_out[i],
                     stage1_ff_r_out[(i+1)],
                     stage1_ff_i_out[(i+1)],
                     stage1_ff_r_out[(i+2)],
                     stage1_ff_i_out[(i+2)],
                     stage1_ff_r_out[(i+3)],
                     stage1_ff_i_out[(i+3)],
                     stage2_ff_r_in[i],
                     stage2_ff_i_in[i],
                     stage2_ff_r_in[(i+1)],
                     stage2_ff_i_in[(i+1)],
                     stage2_ff_r_in[(i+2)],
                     stage2_ff_i_in[(i+2)],
                     stage2_ff_r_in[(i+3)],
                     stage2_ff_i_in[(i+3)]); 
end
    for(i=0;i<16;i=i+1)
      begin 
        Dff ff_stage2(clk,
               rst,
               stage2_ff_r_in[i],
               stage2_ff_i_in[i],
               stage2_ff_r_out[i],
               stage2_ff_i_out[i]);
      end 
    
    butterfly1 bf21(stage2_ff_r_out[0],
                    stage2_ff_i_out[0],
                    stage2_ff_r_out[4],
                    stage2_ff_i_out[4],
                    stage2_ff_r_out[8],
                    stage2_ff_i_out[8],
                    stage2_ff_r_out[12],
                    stage2_ff_i_out[12],
                    pt_r_out[32*(0+1)-1:32*0],
                    pt_i_out[32*(0+1)-1:32*0],
                    pt_r_out[32*(4+1)-1:32*4],
                    pt_i_out[32*(4+1)-1:32*4],
                    pt_r_out[32*(8+1)-1:32*8],
                    pt_i_out[32*(8+1)-1:32*8],
                    pt_r_out[32*(12+1)-1:32*12],
                    pt_i_out[32*(12+1)-1:32*12]);
    
    butterfly2 bf22(stage2_ff_r_out[1],
                    stage2_ff_i_out[1],
                    stage2_ff_r_out[5],
                    stage2_ff_i_out[5],
                    stage2_ff_r_out[9],
                    stage2_ff_i_out[9],
                    stage2_ff_r_out[13],
                    stage2_ff_i_out[13],
                    pt_r_out[32*(1+1)-1:32*1],
                    pt_i_out[32*(1+1)-1:32*1],
                    pt_r_out[32*(5+1)-1:32*5],
                    pt_i_out[32*(5+1)-1:32*5],
                    pt_r_out[32*(9+1)-1:32*9],
                    pt_i_out[32*(9+1)-1:32*9],
                    pt_r_out[32*(13+1)-1:32*13],
                    pt_i_out[32*(13+1)-1:32*13]);
    butterfly3 bf23(stage2_ff_r_out[2],
                    stage2_ff_i_out[2],
                    stage2_ff_r_out[6],
                    stage2_ff_i_out[6],
                    stage2_ff_r_out[10],
                    stage2_ff_i_out[10],
                    stage2_ff_r_out[14],
                    stage2_ff_i_out[14],
                    pt_r_out[32*(2+1)-1:32*2],
                    pt_i_out[32*(2+1)-1:32*2],
                    pt_r_out[32*(6+1)-1:32*6],
                    pt_i_out[32*(6+1)-1:32*6],
                    pt_r_out[32*(10+1)-1:32*10],
                    pt_i_out[32*(10+1)-1:32*10],
                    pt_r_out[32*(14+1)-1:32*14],
                    pt_i_out[32*(14+1)-1:32*14]);
    butterfly4 bf24(stage2_ff_r_out[3],
                    stage2_ff_i_out[3],
                    stage2_ff_r_out[7],
                    stage2_ff_i_out[7],
                    stage2_ff_r_out[11],
                    stage2_ff_i_out[11],
                    stage2_ff_r_out[15],
                    stage2_ff_i_out[15],
                    pt_r_out[32*(3+1)-1:32*3],
                    pt_i_out[32*(3+1)-1:32*3],
                    pt_r_out[32*(7+1)-1:32*7],
                    pt_i_out[32*(7+1)-1:32*7],
                    pt_r_out[32*(11+1)-1:32*11],
                    pt_i_out[32*(11+1)-1:32*11],
                    pt_r_out[32*(15+1)-1:32*15],
                    pt_i_out[32*(15+1)-1:32*15]);
    
    
  endgenerate
//   $display("stage2_ff%d = %d +%dj",i,stage2_ff_r_in,stage2_ff_r_in);

endmodule


module Dff(input signed clk,
           input signed rst,
           input signed [31:0]D_r,
           input signed [31:0]D_i,
           output wire signed  [31:0]Q_r,
           output wire signed  [31:0]Q_i);
  reg signed  [31:0]R1;
  reg signed  [31:0]R2;
  assign Q_r = R1;
  assign Q_i = R2;
  always@(posedge clk or posedge rst) begin
      if(rst) begin
        R1 <=0;
        R2 <=0;
      end
      else begin
        R1 <=D_r;
        R2 <=D_i;
      end
  end
endmodule

module butterfly1(input signed[31:0]A_r_in,
                  input signed [31:0]A_i_in,
                  input signed [31:0]B_r_in,
                  input signed [31:0]B_i_in,
                  input signed [31:0]C_r_in,
                  input signed [31:0]C_i_in,
                  input signed [31:0]D_r_in,
                  input signed [31:0]D_i_in,
                  output wire signed  [31:0]A_r_out,
                  output wire signed  [31:0]A_i_out,
                  output wire signed  [31:0]B_r_out,
                  output wire signed  [31:0]B_i_out,
                  output wire signed  [31:0]C_r_out,
                  output wire signed  [31:0]C_i_out,
                  output wire signed  [31:0]D_r_out,
                  output wire signed  [31:0]D_i_out);
  real W_br=1,W_bi=0,W_cr=1,W_ci=0,W_dr=1,W_di=0;
  assign A_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
  
  assign A_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
   
  assign C_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
  
  assign C_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
     
  assign D_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign D_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
  
  
endmodule


module butterfly2(input signed[31:0]A_r_in,
                  input signed [31:0]A_i_in,
                  input signed [31:0]B_r_in,
                  input signed [31:0]B_i_in,
                  input signed [31:0]C_r_in,
                  input signed [31:0]C_i_in,
                  input signed [31:0]D_r_in,
                  input signed [31:0]D_i_in,
                  output wire signed  [31:0]A_r_out,
                  output wire signed  [31:0]A_i_out,
                  output wire signed  [31:0]B_r_out,
                  output wire signed  [31:0]B_i_out,
                  output wire signed  [31:0]C_r_out,
                  output wire signed  [31:0]C_i_out,
                  output wire signed  [31:0]D_r_out,
                  output wire signed  [31:0]D_i_out);
  real W_br = 0.9238, W_bi=-0.3826,W_cr=0.7071,W_ci=-0.7071,W_dr=0.3826,W_di=-0.9238; 
  assign A_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
  
  assign A_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
   
  assign C_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
  
  assign C_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
     
  assign D_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign D_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
endmodule





module butterfly3(input signed[31:0]A_r_in,
                  input signed [31:0]A_i_in,
                  input signed [31:0]B_r_in,
                  input signed [31:0]B_i_in,
                  input signed [31:0]C_r_in,
                  input signed [31:0]C_i_in,
                  input signed [31:0]D_r_in,
                  input signed [31:0]D_i_in,
                  output wire signed  [31:0]A_r_out,
                  output wire signed  [31:0]A_i_out,
                  output wire signed  [31:0]B_r_out,
                  output wire signed  [31:0]B_i_out,
                  output wire signed  [31:0]C_r_out,
                  output wire signed  [31:0]C_i_out,
                  output wire signed  [31:0]D_r_out,
                  output wire signed  [31:0]D_i_out);
  real W_br=0.7071,W_bi=-0.7071,W_cr=0,W_ci=-1,W_dr=-0.7071,W_di=-0.7071;
  assign A_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
  
  assign A_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
   
  assign C_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
  
  assign C_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
     
  assign D_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign D_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
    
endmodule

module butterfly4(input signed[31:0]A_r_in,
                  input signed [31:0]A_i_in,
                  input signed [31:0]B_r_in,
                  input signed [31:0]B_i_in,
                  input signed [31:0]C_r_in,
                  input signed [31:0]C_i_in,
                  input signed [31:0]D_r_in,
                  input signed [31:0]D_i_in,
                  output wire signed  [31:0]A_r_out,
                  output wire signed  [31:0]A_i_out,
                  output wire signed  [31:0]B_r_out,
                  output wire signed  [31:0]B_i_out,
                  output wire signed  [31:0]C_r_out,
                  output wire signed  [31:0]C_i_out,
                  output wire signed  [31:0]D_r_out,
                  output wire signed  [31:0]D_i_out);
  real W_br=0.3826,W_bi=-0.9238,W_cr=-0.7071,W_ci=-0.7071,W_dr=-0.9239,W_di=0.3287;
   assign A_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
  
  assign A_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)+ (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
  
  assign B_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_br - B_i_in*W_bi) + (D_r_in*W_dr - D_i_in*W_di);
   
  assign C_r_out = A_r_in + (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
  
  assign C_i_out = A_i_in + (C_r_in*W_ci + C_i_in*W_cr)- (B_r_in*W_bi + B_i_in*W_br) - (D_r_in*W_di + D_i_in*W_dr);
     
  assign D_r_out = A_r_in - (C_r_in*W_cr - C_i_in*W_ci)- (B_r_in*W_bi + B_i_in*W_br) + (D_r_in*W_di + D_i_in*W_dr);
  
  assign D_i_out = A_i_in - (C_r_in*W_ci + C_i_in*W_cr)+ (B_r_in*W_br - B_i_in*W_bi) - (D_r_in*W_dr - D_i_in*W_di);
      
endmodule


module S2P(input clk,
           input rst,
           input [31:0]a_r,
           input [31:0]a_i,
           output [31:0]a0_r,
           output [31:0]a0_i,
           output [31:0]a1_r,
           output [31:0]a1_i,
           output [31:0]a2_r,
           output [31:0]a2_i,
           output [31:0]a3_r,
           output [31:0]a3_i,
           output [31:0]a4_r,
           output [31:0]a4_i,
           output [31:0]a5_r,
           output [31:0]a5_i,
           output [31:0]a6_r,
           output [31:0]a6_i,
           output [31:0]a7_r,
           output [31:0]a7_i,
           output [31:0]a8_r,
           output [31:0]a8_i,
           output [31:0]a9_r,
           output [31:0]a9_i,
           output [31:0]a10_r,
           output [31:0]a10_i,
           output [31:0]a11_r,
           output [31:0]a11_i,
           output [31:0]a12_r,
           output [31:0]a12_i,
           output [31:0]a13_r,
           output [31:0]a13_i,
           output [31:0]a14_r,
           output [31:0]a14_i,
           output [31:0]a15_r,
           output [31:0]a15_i
           );


  Dff f0(clk,rst,a_r,a_i,a0_r,a0_i); 
  Dff f1(clk,rst,a0_r,a0_i,a1_r,a1_i);
  Dff f2(clk,rst,a1_r,a1_i,a2_r,a2_i);
  Dff f3(clk,rst,a2_r,a2_i,a3_r,a3_i);
  Dff f4(clk,rst,a4_r,a4_i,a4_r,a4_i);
  Dff f5(clk,rst,a4_r,a4_i,a5_r,a5_i);
  Dff f6(clk,rst,a5_r,a5_i,a6_r,a6_i);
  Dff f7(clk,rst,a6_r,a6_i,a7_r,a7_i);
  Dff f8(clk,rst,a7_r,a7_i,a8_r,a8_i);
  Dff f9(clk,rst,a8_r,a8_i,a9_r,a9_i);
  Dff f10(clk,rst,a9_r,a9_i,a10_r,a10_i);
  Dff f11(clk,rst,a10_r,a10_i,a11_r,a11_i);
  Dff f12(clk,rst,a11_r,a11_i,a12_r,a12_i);
  Dff f13(clk,rst,a12_r,a12_i,a13_r,a13_i);
  Dff f14(clk,rst,a13_r,a13_i,a14_r,a14_i);
  Dff f15(clk,rst,a14_r,a14_i,a15_r,a15_i);
 

endmodule

module rom(
    input clk,
    input [3:0] address,
  output reg [63:0] data // Re_Im
);

  reg [63:0] memory [15:0];

    initial begin
        // Initialize the ROM with some data
      memory[0] <= 64'h12345678;
      memory[1] <= 64'h9ABCDEF0;
      memory[2] <= 64'hABCDEF12;
      memory[3] <= 64'h34567890;
      memory[4] <= 64'hABCDEFAB;
      memory[5] <= 64'hCDCDCDCD;
      memory[6] <= 64'hEFfffff;
      memory[7] <= 64'hffffffab;
      memory[8] <= 64'hffffffff;
      memory[9] <= 64'h01234567;
      memory[10] <= 64'h89ABCDEF;
      memory[11] <= 64'hFEDCBA98;
      memory[12] <= 64'h76543210;
      memory[13] <= 64'hEDCBACAB;
      memory[14] <= 64'hFEDCBA98;
      memory[15] <= 64'h76543210;
    end

    always @(posedge clk) begin
        // Read the ROM data at the specified address
        data <= memory[address];
    end

endmodule


