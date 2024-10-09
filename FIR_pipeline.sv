module FIR_pipeline #(  
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
                              24'h001D04};
   logic signed [23:0] Areg_out; 
   logic signed [48:0] Mreg_in [0:N_taps-1];
   logic signed [48:0] Mreg_out [0:N_taps-1];
   logic signed [48:0] Preg_in [0:N_taps-1];
   logic signed [48:0] Preg_out [0:N_taps-1];
   

  /* initial begin
      $readmemh("00_src/sine_coeff_hex.txt", coeff); // read the coefficient's data
   end*/   

   
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         Areg_out <=24'd0; // reset signal
         for (int i = 0; i < N_taps; i = i + 1) begin
            Mreg_out[i] <= 48'd0;
            Preg_out[i] <= 48'd0;
         end
      end else begin
         Areg_out <= data_in; // new input
         for (int i = 0; i < N_taps; i = i + 1) begin
            Mreg_out[i] <= Mreg_in[i];
            Preg_out[i] <= Preg_in[i];
         end
      end
   end

   // Caculate Preg and Mreg
   always_comb begin
      for (int i = 0; i < N_taps; i = i + 1) begin
	 Mreg_in[i] = Areg_out*coeff[i];
      end
      for (int j = 0; j < N_taps-1; j = j + 1) begin
	 Preg_in[j] = Mreg_out[j] +Preg_out[j+1];
      end
         Preg_in[N_taps-1] = Mreg_out[N_taps-1];
   end
     
   // Output scaling (adjusting to output width)
   assign data_out = Preg_in[0] >>> 24 ;


endmodule
