// Code your testbench here
// or browse Examples
module TB;
  reg signed  clk;
  reg signed  rst;
  reg signed  [31:0]pt1_r;
  reg signed  [31:0]pt1_i;
  reg signed  [31:0]pt2_r;
  reg signed  [31:0]pt2_i;
  reg signed  [31:0]pt3_r;
  reg signed  [31:0]pt3_i;
  reg signed  [31:0]pt4_r;
  reg signed  [31:0]pt4_i;
  reg signed  [31:0]pt5_r;
  reg signed  [31:0]pt5_i;
  reg signed  [31:0]pt6_r;
  reg signed  [31:0]pt6_i;
  reg signed  [31:0]pt7_r;
  reg signed  [31:0]pt7_i;
  reg signed  [31:0]pt8_r;
  reg signed  [31:0]pt8_i;
  reg signed  [31:0]pt9_r;
  reg signed  [31:0]pt9_i;
  reg signed  [31:0]pt10_r;
  reg signed  [31:0]pt10_i;
  reg signed  [31:0]pt11_r;
  reg signed  [31:0]pt11_i;
  reg signed  [31:0]pt12_r;
  reg signed  [31:0]pt12_i;
  reg signed  [31:0]pt13_r;
  reg signed  [31:0]pt13_i;
  reg signed  [31:0]pt14_r;
  reg signed  [31:0]pt14_i;
  reg signed  [31:0]pt15_r;
  reg signed  [31:0]pt15_i;
  reg signed  [31:0]pt16_r;
  reg signed  [31:0]pt16_i;
  reg signed  [511:0]pt_r_in;
  reg signed  [511:0]pt_i_in;
  wire signed   [511:0]pt_r_out;
  wire signed   [511:0]pt_i_out;
  integer i;
  radix4_fft DUT(clk,rst,pt_r_in,pt_i_in,pt_r_out,pt_i_out);
  initial begin
    rst = 1;
    clk = 0;
 
    $dumpfile("TB.vcd");
    $dumpvars(0,TB);
    #15 rst = 0; 
  end
  always #10 clk=!clk;
  initial begin
    pt1_r = 32'h00010000;
    pt1_i = 32'h00010000;
    pt2_r = 32'h00010000;
    pt2_i = 32'h00010000;
    pt3_r = 32'h00010000;
    pt3_i = 32'h00010000;
    pt4_r = 32'h00010000;
    pt4_i = 32'h00010000;
    pt5_r = 32'h00010000;
    pt5_i = 32'h00010000;
    pt6_r = 32'h00010000;
    pt6_i = 32'h00010000;
    pt7_r = 32'h00010000;
    pt7_i = 32'h00010000;
    pt8_r = 32'h00010000;
    pt8_i = 32'h00010000;
    pt9_r = 32'h00010000;
    pt9_i = 32'h00010000;
    pt10_r = 32'h00010000;
    pt10_i = 32'h00010000;
    pt11_r = 32'h00010000;
    pt11_i = 32'h00010000;
    pt12_r = 32'h00010000;
    pt12_i = 32'h00010000;
    pt13_r = 32'h00010000;
    pt13_i = 32'h00010000;
    pt14_r = 32'h00010000;
    pt14_i = 32'h00010000;
    pt15_r = 32'h00010000;
    pt15_i = 32'h00010000;
    pt16_r = 32'h00010000;
    pt16_i = 32'h00010000;
     pt_r_in = {pt16_r,pt12_r,pt8_r,pt4_r,pt15_r,pt11_r,pt7_r,pt3_r,pt14_r,pt10_r,pt6_r,pt2_r,pt13_r,pt9_r,pt5_r,pt1_r};
 

//     pt_r_in = {pt1_r,pt5_r,pt9_r,pt13_r,pt2_r,pt6_r,pt10_r,pt14_r,pt3_r,pt7_r,pt11_r,pt15_r,pt4_r,pt8_r,pt12_r,pt16_r};
   pt_i_in = {pt16_i,pt12_i,pt8_i,pt4_i,pt15_i,pt11_i,pt7_i,pt3_i,pt14_i,pt10_i,pt6_i,pt2_i,pt13_i,pt9_i,pt5_i,pt1_i};
    
 $display("pt1 = %d + %dj", pt_r_in[31:0], pt_i_in[31:0]);
$display("pt2 = %d + %dj", pt_r_in[63:32], pt_i_in[63:32]);
$display("pt3 = %d + %dj", pt_r_in[95:64], pt_i_in[95:64]);
$display("pt4 = %d + %dj", pt_r_in[127:96], pt_i_in[127:96]);
$display("pt5 = %d + %dj", pt_r_in[159:128], pt_i_in[159:128]);
$display("pt6 = %d + %dj", pt_r_in[191:160], pt_i_in[191:160]);
$display("pt7 = %d + %dj", pt_r_in[223:192], pt_i_in[223:192]);
$display("pt8 = %d + %dj", pt_r_in[255:224], pt_i_in[255:224]);
$display("pt9 = %d + %dj", pt_r_in[287:256], pt_i_in[287:256]);
$display("pt10 = %d + %dj", pt_r_in[319:288], pt_i_in[319:288]);
$display("pt11 = %d + %dj", pt_r_in[351:320], pt_i_in[351:320]);
$display("pt12 = %d + %dj", pt_r_in[383:352], pt_i_in[383:352]);
$display("pt13 = %d + %dj", pt_r_in[415:384], pt_i_in[415:384]);
$display("pt14 = %d + %dj", pt_r_in[447:416], pt_i_in[447:416]);
$display("pt15 = %d + %dj", pt_r_in[479:448], pt_i_in[479:448]);
$display("pt16 = %d + %dj", pt_r_in[511:480], pt_i_in[511:480]);
#100

    
    comp(pt_r_out[31:0],pt_i_out[31:0]);  
    comp(pt_r_out[63:32], pt_i_out[63:32]);
    comp(pt_r_out[95:64], pt_i_out[95:64]);
    comp(pt_r_out[127:96], pt_i_out[127:96]);
    comp(pt_r_out[159:128], pt_i_out[159:128]);
    comp(pt_r_out[191:160], pt_i_out[191:160]);
    comp(pt_r_out[223:192], pt_i_out[223:192]);
    comp(pt_r_out[255:224], pt_i_out[255:224]);
    comp(pt_r_out[287:256], pt_i_out[287:256]);
    comp(pt_r_out[319:288], pt_i_out[319:288]);
    comp(pt_r_out[351:320], pt_i_out[351:320]);
    comp(pt_r_out[383:352], pt_i_out[383:352]);
    comp(pt_r_out[415:384], pt_i_out[415:384]);
    comp(pt_r_out[447:416], pt_i_out[447:416]);
    comp(pt_r_out[479:448], pt_i_out[479:448]);
    comp(pt_r_out[511:480], pt_i_out[511:480]);

    #300 $finish;
  end
  
  
    task comp;
      input signed [31:0]x;
      input signed [31:0]y;
      real op1;
      real op2;
       begin
         if(x[31]==1) begin
           x=(~x)+1;
           op1 = -x;
         end
         else begin
           op1=x;
         end
         if(y[31]==1) begin
           y=(~y)+1;
           op2 = -y;
         end
         else begin
           op2=y;
         end
         $display("%f + %fj",op1/65536,op2/65536);
       end
    endtask
//   function signed [31:0]comp(input [31:0]x);
//        begin
//          if(x[31]==1) begin
//            x=(~x)+1;
//            comp = -x;
//          end
//          else begin
//            comp=x;
//          end
//          $display("%d",comp);
//        end
//   endfunction

endmodule









//     $monitor( "pt_out = [%d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %dj, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j, %d + %d*1j]",pt_r_out[15:0],pt_i_out[15:0],,pt_r_out[31:16],pt_i_out[31:16],,pt_r_out[47:32],pt_i_out[47:32],,pt_r_out[63:48],pt_i_out[63:48],,pt_r_out[79:64],pt_i_out[79:64],,pt_r_out[95:80],pt_i_out[95:80],,pt_r_out[111:96],pt_i_out[111:96],,pt_r_out[127:112],pt_i_out[127:112],,pt_r_out[143:128],pt_i_out[143:128],,pt_r_out[159:144],pt_i_out[159:144],,pt_r_out[175:160],pt_i_out[175:160],,pt_r_out[191:176],pt_i_out[191:176],,pt_r_out[207:192],pt_i_out[207:192],,pt_r_out[223:208],pt_i_out[223:208],,pt_r_out[239:224],pt_i_out[239:224],,pt_r_out[255:240],pt_i_out[255:240]);

//    $display(
//      "pt_out_1 = %h + %hj\n",pt_r_out[31:0],pt_i_out[31:0],
//    "pt_out_2 = %h + %hj\n", pt_r_out[63:32], pt_i_out[63:32],
//     "pt_out_3 = %h + %hj\n", pt_r_out[95:64], pt_i_out[95:64],
//     "pt_out_4 = %h + %hj\n", pt_r_out[127:96], pt_i_out[127:96],
//     "pt_out_5 = %h + %hj\n", pt_r_out[159:128], pt_i_out[159:128],
//     "pt_out_6 = %h + %hj\n", pt_r_out[191:160], pt_i_out[191:160],
//     "pt_out_7 = %h + %hj\n", pt_r_out[223:192], pt_i_out[223:192],
//     "pt_out_8 = %h + %hj\n", pt_r_out[255:224], pt_i_out[255:224],
//     "pt_out_9 = %h + %hj\n", pt_r_out[287:256], pt_i_out[287:256],
//     "pt_out_10 = %h + %hj\n", pt_r_out[319:288], pt_i_out[319:288],
//     "pt_out_11 = %h + %hj\n", pt_r_out[351:320], pt_i_out[351:320],
//     "pt_out_12 = %h + %hj\n", pt_r_out[383:352], pt_i_out[383:352],
//     "pt_out_13 = %h + %hj\n", pt_r_out[415:384], pt_i_out[415:384],
//     "pt_out_14 = %h + %hj\n", pt_r_out[447:416], pt_i_out[447:416],
//     "pt_out_15 = %h + %hj\n", pt_r_out[479:448], pt_i_out[479:448],
//     "pt_out_16 = %h + %hj\n", pt_r_out[511:480], pt_i_out[511:480]
// );
