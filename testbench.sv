
// Eda link : https://edaplayground.com/x/PbpW 

// ( swamy ) please copy the code but don't change/modify the code here.



//======================================================================================================================

// project name:packet_divider_and reorder logic 
// Description : this project have 3 agents ,1.register agent,2.transmit_agent,3.recieve_agent.
// but this second vip2(transmit_agent) for the sending the payload to outside in this project.
// IN this environment have scoreboard ,just for the samples sending from monitor to the scoreboard.


//======================================================================================================================



`include "uvm_macros.svh"
import uvm_pkg::*;
`include "pkt_dvdr_transmit_intf.sv"
`include "pkt_dvdr_tx_seq_item.sv"
`include "pkt_dvdr_tx_base_sequence.sv"
`include "pkt_dvdr_tx_sequencer.sv"
`include "pkt_dvdr_tx_driver.sv"
`include "pkt_dvdr_tx_monitor.sv"
`include "pkt_dvdr_tx_config_agent.sv"
`include "pkt_dvdr_tx_agent.sv"
`include "pkt_dvdr_tx_environment.sv"
`include "pkt_dvdr_tx_base_test.sv"

module tb_top_packet_divider_transmit;
 
bit clk;
bit rst_n;
int freq;
real h_time_p;
  

  
//clock generation with specified freq(in spec is mentioned operating frequency between the "10 to 20 mhz " 
task  clk_gen(input int freq,output real h_time_p);  
real time_p;
real freq_mhz;
freq_mhz=(1000_000)*(freq);//or freq_mhz=((10**6)*(freq));given freq hz into freq in mhz conversion.
time_p =(1.0/freq_mhz)*(1000_000_000);//or time_p=(1.0/freq_mhz)*(10**9);//time_p comes in nane seconds.
h_time_p=(time_p/2);
`uvm_info("clock_gen",$sformatf(" freq_mhz=%0g time_p=%0g  h_time_p=%0g ",freq_mhz,time_p,h_time_p),UVM_NONE); 
endtask:clk_gen

initial begin
freq=$urandom_range(10,20);
`uvm_info("clk_gen_freq",$sformatf("value of freq=%0d ",freq),UVM_NONE);
clk_gen(freq,h_time_p);
   
end
  
initial begin
forever #h_time_p clk=~clk;
end
  
 initial begin
$dumpfile("dump.vcd");
 $dumpvars;
 end
 
//packet divider transmit interface handle declaration.
  pkt_dvdr_transmit_intf tx_vintf(clk,rst_n);

  //module instantiation
  transmit_dut tx_dut(tx_vintf.addr,tx_vintf.wr_data,tx_vintf.wr,tx_vintf.rd,tx_vintf.tx_en,tx_vintf.tx_data,tx_vintf.clk,tx_vintf.rst_n);
  
initial begin
//setting the packet_dvdr_trnsmit_intf handle to the below level components. 
  uvm_config_db#(virtual pkt_dvdr_transmit_intf)::set(null,"*","tx_vintf",tx_vintf);
 end
  
  initial begin
     run_test("pkt_dvdr_tx_base_test");
  end
  
initial begin
#200;
@(posedge tx_vintf.clk);
tx_vintf.addr = 0;
tx_vintf.wr_data=1;
tx_vintf.wr=1'b1;
@(posedge tx_vintf.clk);
  tx_vintf.wr=1'b0;
//@(posedge tx_vintf.clk);
//tx_vintf.addr = 0;
//tx_vintf.wr_data=0;
//tx_vintf.wr=1'b1;
#1000;
@(posedge tx_vintf.clk);
tx_vintf.addr = 0;
tx_vintf.wr_data=1;
tx_vintf.wr=1'b1;
//@(posedge tx_vintf.clk);
@(posedge tx_vintf.clk);
//tx_vintf.addr = 0;
//tx_vintf.wr_data=0;
tx_vintf.wr=1'b0;  
end

  

  
endmodule:tb_top_packet_divider_transmit
