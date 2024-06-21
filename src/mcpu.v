//
// Minimal 8 Bit CPU
//
// 01􀀀02/2001 Tim Boescke
// 10 /2001 changed to synch. reset
// 10 /2004 Verilog version , unveried !
//
// t .boescke@tuhh.de
//
module mcpu(datain,dataout,adress,oe,we,rst,clk);
  input [7:0] datain;
  output [7:0] dataout;
  output [5:0] adress;
  output oe;
  output we;
  input rst ;
  input clk ;

reg [8:0] accumulator; // accumulator(8) is carry !
reg [5:0] adreg;
reg [5:0] pc;
reg [2:0] states;

  always @(posedge clk or negedge rst)
    if (~rst ) begin
      adreg <= 0;
      states <= 0;
      accumulator <= 0;
    end
    else begin
      // PC / Address path
      if (~|states ) begin
        pc <= adreg + 1;
        adreg <= datain[5:0];
      end
      else adreg <= pc;
      // ALU / Data Path
      case(states)
        3'b010 : accumulator <= {1'b0, accumulator[7:0]} + {1'b0, datain}; // add
        3'b011 : accumulator[7:0] <= ~(accumulator[7:0]|datain); // nor
        3'b101 : accumulator[8] <= 1'b0; // branch not taken, clear carry
      endcase // default : instruction fetch , jcc taken
      // State machine
      if (|states ) states <= 0;
      else begin
        if ( &datain[7:6] && accumulator[8] ) states <= 3'b101;
        else states <= {1'b0, ~datain[7:6]};
      end
  end
// output
assign adress = adreg;
assign dataout = states!=3'b001 ? accumulator[7:0] : 8'bZZZZZZZZ;
assign oe = clk | ~rst | ( states==3'b001) ;
assign we = clk | ~rst | ( states!=3'b001) ;

endmodule
