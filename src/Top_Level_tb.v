`timescale 1ns/1ns

module Top_Level_tb();
    reg clk=1'b0;
    reg [2:0] no_Cores = 3'b100; //change this between 1-4 for to select no of cores to use 

    //initially all the cores are disabled for wait until DRAM gets filled with input data
    reg enable_0 = 0;
    wire End_core0;
    wire [5:0] PC0_out;

    reg enable_1 = 0;
    wire End_core1;
    wire [5:0] PC1_out;

    reg enable_2 = 0;
    wire End_core2;
    wire [5:0] PC2_out;

    reg enable_3 = 0;
    wire End_core3;
    wire [5:0] PC3_out;

    //control DRAM from outside
    reg [31:0] dataIn_file;
    reg [11:0] addr_file = 12'hfff; //increment by 1 will instantiate to 0
	reg we_file = 1'b1;
	wire signed [31:0]  dataOut_file;

    //stages in the process
    integer state;
    integer mem_write = 0;
    integer processing = 1;
    integer mem_read = 2;

    integer data_input_file;
    integer data_output_file;
    reg [31:0] captured_data;

    //to track the clock usage
    integer clock_count = 0;

    //clock module
    initial begin
        repeat (10000) //provide well over what is needed
        #10 clk = ~clk;
        $stop; //process should finish well before this. This shouldn't be triggered!
	end

    //instantiate file handlers and start DRAM write stage
    initial begin
        data_input_file = $fopen("../../../src/input.txt", "r");
       data_output_file = $fopen("../../../src/output.txt", "w");

        if (data_input_file == 0) begin
            $display("data_file handle was NULL");
            $stop;
        end

        state = mem_write;
    end

     Top_Level_Module Top_Module(
	    .clk(clk),
        .no_Cores(no_Cores),

        .End_core0(End_core0),
        .PC0_out(PC0_out),
		.enable_0(enable_0),

        .End_core1(End_core1),
        .PC1_out(PC1_out),
		.enable_1(enable_1),

        .End_core2(End_core2),
        .PC2_out(PC2_out),
 		.enable_2(enable_2),

        .End_core3(End_core3),
        .PC3_out(PC3_out),
		.enable_3(enable_3),

        .dataIn_file(dataIn_file),
		.dataOut_file(dataOut_file),
		.addr_file(addr_file),
		.we_file(we_file) 
    );



    always @(posedge clk) begin

        //DRAM write stage
        if (state == mem_write) begin
            we_file <= 1'b1;
            $fscanf(data_input_file, "%d\n", captured_data);

            if (!$feof(data_input_file)) begin
                dataIn_file <= captured_data;
                addr_file <= addr_file + 1'b1;
                // $display("writing %d", dataIn_file, "to %d", addr_file, "address");
            end
            
            else begin
                //write the last input data to DRAM and move to next state
                dataIn_file <= captured_data;
                addr_file <= addr_file + 1'b1;
                $fclose(data_input_file);
                state = processing;
            end   
        end

        //processing end state and move to next state
        else if (state == processing && End_core0 && End_core1 && End_core2 && End_core3) begin //remove disabled core flags
        // else if (state == processing && End_core0) begin 
            //address where output data is stored in DRAM
            addr_file <=  12'b100000;
            $display("process finished in %d", clock_count, " clock counts");
            state = mem_read;
            end

        //processing stage
        else if (state == processing) begin
            clock_count = clock_count+1;
            //disable cores depending on no_cores needed
            enable_0 <= 1;
            enable_1 <= 1;
            enable_2 <= 1;
            enable_3 <= 1; //0;

            we_file <= 1'b0;
        end
        
        //DRAM read stage 
        else if (state == mem_read && addr_file < 11'b110000) begin  //should run until the end of output data (except matrix size information which is stored at the end addresses)
     
            $fdisplay(data_output_file, dataOut_file);
            addr_file <= addr_file + 1'b1;
        end
        else begin 
        $fclose(data_output_file);
        $stop;
        end
    end

endmodule

