class pkt_dvdr_tx_base_test extends uvm_test;
  //factory registration.
  `uvm_component_utils(pkt_dvdr_tx_base_test)
  
  //tx environment class handle declaration.
  pkt_dvdr_tx_environment tx_env;
  
  //factory class 
  uvm_factory factory;
  uvm_coreservice_t cs=uvm_coreservice_t::get();
  
  //default constructor.
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction:new
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    //creating the environment.
    tx_env = pkt_dvdr_tx_environment::type_id::create("tx_env",this);
  endfunction:build_phase
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    this.print();
    factory = cs.get_factory();
    factory.print();
  endfunction:end_of_elaboration_phase
  
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
   uvm_top.print_topology;
  endfunction:start_of_simulation_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    
    phase.drop_objection(this);
    phase.phase_done.set_drain_time(this,3000);
  endtask:run_phase
  
  
endclass:pkt_dvdr_tx_base_test