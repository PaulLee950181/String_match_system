module SME(
    clk,
    rst_n,
    chardata,
    isstring,
    ispattern,
    valid,
    match,
    match_index
);

input clk;
input rst_n;
input [7:0] chardata;
input isstring;
input ispattern;
output logic match;
output logic [4:0] match_index;
output logic valid;

logic [5:0] stringNUM;
logic [3:0] patNUM_1;
logic [2:0] P_start;
logic [6:0] pat_1 [8:0];
logic [6:0] str [33:0];
logic [2:0] CS, NS;
logic [5:0] i;
logic GET_PATTERN_star, GET_PATTERN_hat;
logic [5:0] check_position;
logic search_stage;
logic enter_SEARCH_STAGE_1;

parameter IDLE = 0;
parameter SET_STRING = 1;
parameter GET_STRING = 2;
parameter GET_PATTERN = 3;
parameter SEARCH_STAGE_1 = 4;
parameter SEARCH_NORMAL = 5;
parameter OUT = 6;
parameter SET_PATTERN = 7;

always_ff @ ( posedge clk or negedge rst_n ) begin
	if( !rst_n )begin
		match <= 0;
		match_index <= 0;
		valid <= 0;
		CS <= IDLE;
		GET_PATTERN_star <= 0;
		GET_PATTERN_hat <= 0;
		patNUM_1 <= 0;
		for( i = 0 ; i < 9 ; i = i + 1 ) begin
			pat_1[i] <= 0;
		end
		check_position <= 0;
		search_stage <= 1;
		P_start <= 0;
		enter_SEARCH_STAGE_1 <= 0;
	end
	else begin
		CS <= NS;
		if( valid ) begin
			valid <= 0;
			match <= 0;
			match_index <= 0;
		end
		case( NS )
			SET_STRING: begin
				stringNUM <= 1;
				str[0] <= chardata;
				for( i = 2 ; i < 34 ; i = i + 1 ) begin
					str[i] <= 0;
				end
				CS <= GET_STRING;
			end
			GET_STRING: begin
				str[stringNUM] <= chardata;
				stringNUM <= stringNUM + 1;				
			end
			SET_PATTERN: begin
				if( chardata == 42 ) begin					
					search_stage <= 0;
					GET_PATTERN_star <= 1;
					patNUM_1 <= 0;
				end
				else if( chardata == 94 ) begin
					GET_PATTERN_hat <= 1;
					pat_1[0] <= 32;
					patNUM_1 <= 1;
				end
				else if( chardata == 36 ) begin
					str[stringNUM] <= 32;
					pat_1[0] <= 32;
					patNUM_1 <= 1;
				end
				else begin
					pat_1[0] <= chardata;
					patNUM_1 <= 1;
				end
				CS <= GET_PATTERN;
			end
			GET_PATTERN: begin				
				if( chardata == 42 ) begin
					GET_PATTERN_star <= 1;
					pat_1[patNUM_1] <= 42;
				end				
				else if( chardata == 94 ) begin
					GET_PATTERN_hat <= 1;
					pat_1[patNUM_1] <= 32;
				end
				else if( chardata == 36 ) begin
					str[stringNUM] <= 32;
					pat_1[patNUM_1] <= 32;
				end
				else begin
					pat_1[patNUM_1] <= chardata;
				end
				patNUM_1 <= patNUM_1 + 1;
			end
			SEARCH_STAGE_1: begin
				if( P_start == 0 ) begin
					enter_SEARCH_STAGE_1 <= 1;
				end
				if( GET_PATTERN_star && patNUM_1 == 0) begin
					CS <= OUT;
					match <= 1;
				end
				else if( ( pat_1[P_start] == str[0] || pat_1[P_start] == 46 ) && check_position == 0 ) begin
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 1;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == 46 && str[check_position] != 0 ) begin					
					if( search_stage ) begin
						match_index <= match_index + 1;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= check_position + 1;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[1] && check_position < 2 ) begin
					if( search_stage ) begin
						match_index <= 1;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 2;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[2] && check_position < 3 ) begin
					if( search_stage ) begin
						match_index <= 2;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 3;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[3] && check_position < 4 ) begin
					if( search_stage ) begin
						match_index <= 3;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 4;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[4] && check_position < 5 ) begin
					if( search_stage ) begin
						match_index <= 4;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 5;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[5] && check_position < 6 ) begin
					if( search_stage ) begin
						match_index <= 5;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 6;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[6] && check_position < 7 ) begin
					if( search_stage ) begin
						match_index <= 6;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 7;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[7] && check_position < 8 ) begin
					if( search_stage ) begin
						match_index <= 7;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 8;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[8] && check_position < 9 ) begin
					if( search_stage ) begin
						match_index <= 8;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 9;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[9] && check_position < 10 ) begin
					if( search_stage ) begin
						match_index <= 9;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 10;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[10] && check_position < 11 ) begin
					if( search_stage ) begin
						match_index <= 10;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 11;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[11] && check_position < 12 ) begin
					if( search_stage ) begin
						match_index <= 11;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 12;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[12] && check_position < 13 ) begin
					if( search_stage ) begin
						match_index <= 12;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 13;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[13] && check_position < 14 ) begin
					if( search_stage ) begin
						match_index <= 13;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 14;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[14] && check_position < 15 ) begin
					if( search_stage ) begin
						match_index <= 14;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 15;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[15] && check_position < 16 ) begin
					if( search_stage ) begin
						match_index <= 15;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 16;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[16] && check_position < 17 ) begin
					if( search_stage ) begin
						match_index <= 16;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 17;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[17] && check_position < 18 ) begin
					if( search_stage ) begin
						match_index <= 17;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 18;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[18] && check_position < 19 ) begin
					if( search_stage ) begin
						match_index <= 18;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 19;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[19] && check_position < 20 ) begin
					if( search_stage ) begin
						match_index <= 19;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 20;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[20] && check_position < 21 ) begin
					if( search_stage ) begin
						match_index <= 20;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 21;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[21] && check_position < 22 ) begin
					if( search_stage ) begin
						match_index <= 21;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 22;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[22] && check_position < 23 ) begin
					if( search_stage ) begin
						match_index <= 22;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 23;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[23] && check_position < 24 ) begin
					if( search_stage ) begin
						match_index <= 23;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 24;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[24] && check_position < 25 ) begin
					if( search_stage ) begin
						match_index <= 24;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 25;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[25] && check_position < 26 ) begin
					if( search_stage ) begin
						match_index <= 25;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 26;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[26] && check_position < 27 ) begin
					if( search_stage ) begin
						match_index <= 26;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 27;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[27] && check_position < 28 ) begin
					if( search_stage ) begin
						match_index <= 27;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 28;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[28] && check_position < 29 ) begin
					if( search_stage ) begin
						match_index <= 28;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 29;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[29] && check_position < 30 ) begin
					if( search_stage ) begin
						match_index <= 29;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 30;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[30] && check_position < 31 ) begin
					if( search_stage ) begin
						match_index <= 30;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						check_position <= 31;
						CS <= SEARCH_NORMAL;
					end
				end
				else if( pat_1[P_start] == str[31] && check_position < 32 ) begin
					if( search_stage ) begin
						match_index <= 31;
					end
					if( pat_1[P_start + 1] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						/*check_position <= 32;
						CS <= SEARCH_NORMAL;*/
						CS <= OUT;
						match <= 0;
					end
				end
				else begin
					CS <= OUT;
					match <= 0;
				end
			end
			SEARCH_NORMAL: begin
				if( pat_1[P_start + 1] == 42 ) begin
					if( pat_1[P_start + 2] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else begin
						CS <= SEARCH_STAGE_1;
						search_stage <= 0;
						P_start <= P_start + 2;
					end
				end
				else if( str[check_position] == 0 ) begin
					CS <= OUT;
					match <= 0;
				end
				else if( pat_1[P_start + 1] == str[check_position] || pat_1[P_start + 1] == 46 ) begin
					if( pat_1[P_start + 2] == 0 ) begin
						CS <= OUT;
						match <= 1;
					end
					else if( pat_1[P_start + 2] == 42 ) begin
						if( pat_1[P_start + 3] == 0 ) begin
							CS <= OUT;
							match <= 1;
						end
						else begin
							CS <= SEARCH_STAGE_1;
							search_stage <= 0;
							P_start <= P_start + 3;
							check_position <= check_position + 1;
						end
					end
					else if( str[check_position + 1] == 0 ) begin
						CS <= OUT;
						match <= 0;
					end
					else begin
						if( pat_1[P_start + 2] == str[check_position + 1] || pat_1[P_start + 2] == 46 ) begin
							if( pat_1[P_start + 3] == 0 ) begin
								CS <= OUT;
								match <= 1;
							end
							else if( pat_1[P_start + 3] == 42 ) begin
								if( pat_1[P_start + 4] == 0 ) begin
									CS <= OUT;
									match <= 1;
								end
								else begin
									CS <= SEARCH_STAGE_1;
									search_stage <= 0;
									P_start <= P_start + 4;
									check_position <= check_position + 2;
								end
							end
							else if( str[check_position + 2] == 0 ) begin
								CS <= OUT;
								match <= 0;
							end
							else begin
								if( pat_1[P_start + 3] == str[check_position + 2] || pat_1[P_start + 3] == 46 ) begin
									if( pat_1[P_start + 4] == 0 ) begin
										CS <= OUT;
										match <= 1;
									end
									else if( pat_1[P_start + 4] == 42 ) begin
										if( pat_1[P_start + 5] == 0 ) begin
											CS <= OUT;
											match <= 1;
										end
										else begin
											CS <= SEARCH_STAGE_1;
											search_stage <= 0;
											P_start <= P_start + 5;
											check_position <= check_position + 3;
										end
									end
									else if( str[check_position + 3] == 0 ) begin
										CS <= OUT;
										match <= 0;
									end									
									else begin
										if( pat_1[P_start + 4] == str[check_position + 3] || pat_1[P_start + 4] == 46 ) begin
											if( pat_1[P_start + 5] == 0 ) begin
												CS <= OUT;
												match <= 1;
											end
											else if( pat_1[P_start + 5] == 42 ) begin
												if( pat_1[P_start + 6] == 0 ) begin
													CS <= OUT;
													match <= 1;
												end
												else begin
													CS <= SEARCH_STAGE_1;
													search_stage <= 0;
													P_start <= P_start + 6;
													check_position <= check_position + 4;
												end
											end
											else if( str[check_position + 4] == 0 ) begin
												CS <= OUT;
												match <= 0;
											end
											else begin
												if( pat_1[P_start + 5] == str[check_position + 4] || pat_1[P_start + 5] == 46 ) begin
													if( pat_1[P_start + 6] == 0 ) begin
														CS <= OUT;
														match <= 1;
													end
													else if( pat_1[P_start + 6] == 42 ) begin
														if( pat_1[P_start + 7] == 0 ) begin
															CS <= OUT;
															match <= 1;
														end
														else begin
															CS <= SEARCH_STAGE_1;
															search_stage <= 0;
															P_start <= P_start + 7;
															check_position <= check_position + 5;
														end
													end
													else if( str[check_position + 5] == 0 ) begin
														CS <= OUT;
														match <= 0;
													end
													else begin
														if( pat_1[P_start + 6] == str[check_position + 5] || pat_1[P_start + 6] == 46 ) begin
															if( pat_1[P_start + 7] == 0 ) begin
																CS <= OUT;
																match <= 1;
															end
															else if( str[check_position + 6] == 0 ) begin
																CS <= OUT;
																match <= 0;
															end
															else begin
																if( pat_1[P_start + 7] == str[check_position + 6] || pat_1[P_start + 7] == 46 ) begin
																	if( pat_1[P_start + 8] == 0 ) begin
																		CS <= OUT;
																		match <= 1;
																	end
																end
																else begin
																	CS <= SEARCH_STAGE_1;
																end																
															end
														end
														else begin
															CS <= SEARCH_STAGE_1;
														end
													end
												end
												else begin
													CS <= SEARCH_STAGE_1;
												end												
											end
										end
										else begin
											CS <= SEARCH_STAGE_1;
										end
									end
								end
								else begin
									CS <= SEARCH_STAGE_1;
								end
							end
						end
						else begin
							CS <= SEARCH_STAGE_1;
						end
					end
				end
				else begin
					CS <= SEARCH_STAGE_1;
				end
			end
			OUT: begin
				valid <= 1;
				if( GET_PATTERN_hat ) begin
					if( match_index != 0 ) begin
						match_index <= match_index + 1;
					end
					else if( str[0] == 32 && pat_1[1] != 32 ) begin
						if( pat_1[1] != 46 ) begin
							match_index <= match_index + 1;
						end
						else if( enter_SEARCH_STAGE_1 ) begin
							match_index <= match_index + 1;
						end
					end
				end
				GET_PATTERN_star <= 0;
				GET_PATTERN_hat <= 0;
				for( i = 0 ; i < 9 ; i = i + 1 ) begin
					pat_1[i] <= 0;
				end
				check_position <= 0;
				search_stage <= 1;
				P_start <= 0;
				enter_SEARCH_STAGE_1 <= 0;
				str[stringNUM] <= 0;
				CS <= IDLE;
			end
		endcase
	end	
end

always_comb begin
	NS = CS;
	case( CS )
		IDLE: begin
			if( isstring ) begin
				NS = SET_STRING;
			end
			else if( ispattern ) begin
				NS = SET_PATTERN;
			end
		end
		GET_STRING: begin
			if( !isstring ) begin
				if( ispattern )
					NS = SET_PATTERN;
				else
					NS = IDLE;
			end
		end
		GET_PATTERN: begin
			if( !ispattern ) begin
				if( GET_PATTERN_hat ) begin
					NS = SEARCH_NORMAL;
				end
				else begin
					NS = SEARCH_STAGE_1;
				end
			end
		end			
	endcase
end


endmodule
