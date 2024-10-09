module FIR #(  
parameter N_taps = 33 // number of taps
)(
   input  clk,
   input  reset_n,
   input  [23:0] data_in,
   output [23:0] data_out
);

   logic signed [23:0] coeff [0:N_taps-1]={24'h001D04, 24'h00380B, 24'h006917, 24'h00B079, 
                              24'h0111AD, 24'h018ED7, 24'h022829, 24'h02DB83, 
                              24'h03A43E, 24'h047B31, 24'h05570A, 24'h062CDF, 
                              24'h06F107, 24'h079802, 24'h081792, 24'h08679A, 
                              24'h0882DC, 24'h08679A, 24'h081792, 24'h079802, 
                              24'h06F107, 24'h062CDF, 24'h05570A, 24'h047B31, 
                              24'h03A43E, 24'h02DB83, 24'h022829, 24'h018ED7, 
                              24'h0111AD, 24'h00B079, 24'h006917, 24'h00380B, 
                              24'h001D04}; // Define the coefficient 
   logic signed [23:0] delay [0:N_taps-1]; // Delay line for input data
   logic signed [48:0] macc [0:N_taps-1];  // Multiply-accumulate registers
   

  /* initial begin
      $readmemh("00_src/sine_coeff_hex.txt", coeff); // read the coefficient's data
   end */  

   // Shift register for delay line (data input)
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         for (int i = 0; i < N_taps; i = i + 1) begin
            delay[i] <= 24'd0; // reset all delay elements
         end
      end else begin
         delay[0] <= data_in; // new input
         for (int i = 1; i < N_taps; i = i + 1) begin
            delay[i] <= delay[i-1]; // shift data down the delay line
         end
      end
   end

   // Multiply-accumulate logic
   always_comb begin
      macc[0] = delay[0] * coeff[0]; // first macc
      for (int i = 1; i < N_taps; i = i + 1) begin
         macc[i] = delay[i] * coeff[i] + macc[i-1]; // accumulate
      end
   end

   // Output scaling (adjusting to output width)
   assign data_out = macc[N_taps-1] >>> 24 ;


endmodule
