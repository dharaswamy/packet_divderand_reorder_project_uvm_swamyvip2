// Code your design here

module transmit_dut( input addr,
                     input wr_data,
                    input wr,
                    input rd,
                    output reg tx_en,
                    output reg [7:0] tx_data,
                    input clk,
                    input rst_n);

  
  reg [7:0] status,cmd;
  reg [7:0] data[10]={8'hde,8'had,8'h05,8'h10,8'h20,8'h30,8'h40,8'h50,8'hbe,8'hef};
  
  always @(posedge clk) begin
    if(addr == 0 && wr==1'b1 )
      cmd <=wr_data;
    end
    
    
   
  
  always @(posedge clk) begin
    
    if(cmd[0] == 1'b1) begin
      cmd[0] <=1'b0;
      foreach(data[i]) begin
        @(posedge clk);
        
        tx_en <= 1'b1;
        tx_data <= data[i];
       
        
      end
       @(posedge clk);
      tx_en <=1'b0;
     
    end
    
    end
  
endmodule:transmit_dut