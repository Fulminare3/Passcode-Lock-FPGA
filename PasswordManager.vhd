--7 Digit passcode lock
--Coded by Wesley Heikes with help from Tristian Caja

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PassCodeLock is
    Port ( clk : in STD_LOGIC;
           DecodedInput : in STD_LOGIC_VECTOR (3 downto 0);
           StoreMode : in BOOLEAN;
           ResetButton : in STD_LOGIC;
		   LedDisplay: out STD_LOGIC_VECTOR (15 downto 0)
		   );
end PasscodeLock;

architecture Behavioral of PassCodeLock is
    type Code_Array is array(0 to 6) of std_logic_vector(3 downto 0);
    
    --Arrays and flag varable for passcode lock
    signal stored : Code_Array;
    signal newCode: Code_Array;
    signal flag : integer range 0 to 3 :=0;
	
	-- State Machine states
	type state_type is (S0, S1, S2, S3, S4, S5, S6, S7);
	signal state, next_state : state_type;

begin
	
	process(clk)
	begin
		if clk'event and clk = '1' then -- if positive edge triggered
			if (ResetButton = '1') then --reset
				LedDisplay <= "0000000000000000";
				state <= S0;
				flag <= 0;
			else
			--Statemachine to check the passcode-----------------------------------------------------------------
		if(flag = 1 or flag = 3) then
			     state <= S0; --set default state
				case (state) is
					when S0 =>
					--LED configuration for state 0
                            if (flag= 3) then
                                LedDisplay <= "1000000000000000";
                            elsif (DecodedInput = "1111") then  --new
                                LedDisplay <= "0000000100000000"; --new
                            else
                                LedDisplay <= "0000000000000000";
                            end if;
                            --Passcode to button comparison
                            if DecodedInput = stored(0) then --0
                                state <= S1;
                            end if;
					when S1 =>
					--LED configuration for S1
					if (flag= 3) then
					LedDisplay <= "1000000000000001";
					else
					LedDisplay <= "0000000000000001";
					end if;
					   --Passcode to button comparison
						if DecodedInput = stored(1) then --1
							state <= S2;
					    --Keeps S1 active until different button is pressed
						elsif DecodedInput = stored(0) then --0
							state <= S1;
					    --Reset if wrong button is pressed
						else
							state <= S0;
						end if;
					when S2 =>
					--LED configuration for S2
					if (flag= 3) then
					LedDisplay <= "1000000000000011";
					else
					LedDisplay <= "0000000000000011";
					end if;
					    --Passcode to button comparison
						if DecodedInput = stored(2) then --2
							state <= S3;
					    --Keeps S2 active until different button is pressed
						elsif DecodedInput = stored(1) then --1
							state <= S2;
						--Reset if wrong button is pressed
						else
							state <= S0;
						end if;
				   when S3 =>
				   --LED Configuration S3
				   if (flag= 3) then
					LedDisplay <= "1000000000000111";
					else
					LedDisplay <= "0000000000000111";
					end if;
					   --Passcode to button comparision
						if DecodedInput = stored(3) then --3
							state <= S4;
					   --Keeps S3 active until different button is pressed
						elsif DecodedInput = stored(2) then --2
							state <= S3;
					    --Reset if wrong button is pressed
						else
							state <= S0;
						end if;
			      when S4 =>
                  --LED configuration for State 4
			        if (flag= 3) then
					LedDisplay <= "1000000000001111";
					else
					LedDisplay <= "0000000000001111";
					end if;
					   --Passcode to button comparison
						if DecodedInput = stored(4) then --4
							state <= S5;
						--Keeps S4 active until different button is pressed
						elsif DecodedInput = stored(3) then --3
							state <= S4;
						--Reset if wrong button is pressed
						else
							state <= S0;
						end if;
				 when S5 =>
					  --LED configuration for states 5
					  if flag= 3 then
					  LedDisplay <= "1000000000011111";
					  else
					  LedDisplay <= "0000000000011111";
					end if;
					   --Passcode to button comparison
						if DecodedInput = stored(5) then --5
							state <= S6; 
						--Keeps S5 active until different button is pressed
						elsif DecodedInput = stored(4) then --4
							state <= S5;
						--Reset if wrong button is pressed
						else
							state <= S0;
						end if;
				when S6 =>
				      --LED configuration for states 6
					  if flag= 3 then
					  LedDisplay <= "1000000000111111";
					  else
					  LedDisplay <= "0000000000111111";
					  end if;
					    --Passcode to button comparison
						if DecodedInput = stored(6) then --6
							state <= S7;
						--Keeps S6 active until different button is pressed
						elsif DecodedInput = stored(5) then --5
							state <= S6;
						--Reset if wrong button is pressed
						else
							state <= S0;
					    end if;
			   when S7 =>
			             --LED configuration for S7
			             LedDisplay <= "1111111111111111";
			             if DecodedInput = "1111" then --if pound button (#) is pressed
			               flag <= 1;
			             elsif DecodedInput =  "1110" then --if astrisk button (*) is pressed
			               --Meta State Machine Transisions        
			               if (flag = 1 or flag = 3) then
			               flag <= 2;
			               end if;
			             --Keeps S7 active until different button is pressed  
			             elsif DecodedInput = stored(6) then
			               state <= S7;
			             --Reset if wrong button is pressed
			             else
			               state <= S0;
			               --Meta State Machine Transision
			               if (flag =3) then
			               flag <= 2;
			               end if;
			               
			             end if;
					when others => --In case of problem reset
						state <= S0;	  
				end case;
				
	   elsif (flag = 0 or flag = 2) then
	    --Statemachine to store a new passcode --------------------------------------------------------------------------------
			    state <= S0; --set default state
				case (state) is
					when S0 =>
					if (DecodedInput /= "1110") then --if current button is not the astrisk (*) 
					LedDisplay <= "0000000000000000"; --LED configuration
					     --Storing button values in both arrays when button is not equal to previous button
					     newcode(0) <= DecodedInput; 
					     stored(0) <= DecodedInput;  
					     state <= S1;
						end if;
					when S1 =>
					--LED configuration for S1
					if (flag = 2) then
					LedDisplay <= "1000000000000001";
					else
					LedDisplay <= "0000000000000001";
					end if;
					    --Storing button values in both arrays when button is not equal to previous button
						if DecodedInput /= newcode(0) then --1
						 newcode(1) <= DecodedInput;
					     stored(1) <= DecodedInput;
						 state <= S2;
						else
							state <= S1;
						end if;
					when S2 =>
					--LED configuration for S2
					if (flag = 2) then
					LedDisplay <= "1000000000000011";
					else
					LedDisplay <= "0000000000000011";
					end if;
					    --Storing button values in both arrays when button is not equal to previous button
						if DecodedInput /= newcode(1) then --2
						  newcode(2) <= DecodedInput;
					      stored(2) <= DecodedInput;
						  state <= S3;
						else
							state <= S2;
						end if;
				   when S3 =>
				   --LED configuration for S3
				   if (flag = 2) then
					LedDisplay <= "1000000000000111";
					else
					LedDisplay <= "0000000000000111";
					end if;
					    --Storing button values in both arrays when button is not equal to previous button
						if DecodedInput /= newcode(2) then
						 newcode(3) <= DecodedInput;
					     stored(3) <= DecodedInput;
						 state <= S4;
						else
							state <= S3;
						end if;
			      when S4 =>
			      --LED configuration for S4
			      if (flag = 2) then
					LedDisplay <= "1000000000001111";
					else
					LedDisplay <= "0000000000001111";
					end if;
					    --Storing button values in both arrays when button is not equal to previous button
						if DecodedInput /= newcode(3) then --4
						 newcode(4) <= DecodedInput;
					     stored(4) <= DecodedInput;
					     state <= S5;
						else
							state <= S4;
						end if;
				 when S5 =>
				 --LED configureation for S5
				 if (flag = 2) then
					LedDisplay <= "1000000000011111";
					else
					LedDisplay <= "0000000000011111";
					end if;
					    --Storing button values in both arrays when button is not equal to previous button
						if DecodedInput /= newcode(4) then --5
						 newcode(5) <= DecodedInput;
					     stored(5) <= DecodedInput;
					     state <= S6; 
						else
							state <= S5;
						end if;
				when S6 =>
				--LED configuration for S6
				if (flag = 2) then
					LedDisplay <= "1000000000111111";
					else
					LedDisplay <= "0000000000111111";
					end if;
					    --Storing button values in both arrays when button is not equal to previous button
						if DecodedInput /= newcode(5) then --6
						 newcode(6) <= DecodedInput;
					     stored(6) <= DecodedInput;
					     state <= S7;
						else
							state <= S6;
					    end if;
			   when S7 =>
			             --LED configuration for S7
			               LedDisplay <= "1111111111111111";
			               --if button value does not equal the previous button
			             if DecodedInput  /= newcode(6) then
			               if DecodedInput = "1111" then --if the pound (#) button is pressed
			             
			              --Meta State Machine Transistions
			               if (flag = 0) then
			               flag <= 1;
			               end if;
			               
			               if (flag = 2) then
			               flag <= 3; 
			               end if;
			               
			             elsif DecodedInput =  "1110" then -- if the astrisk (*) button is pressed
			             --Meta State Machine Transisions
			                 if (flag = 0 or flag = 2) then
			                 state <= S0;
			                 end if;
			             else -- if passcode is longer than 7 digits
			                 state<= S0;
			                 end if;
			             else -- Keeps this S7 active until different button is pressed
			               state <= S7;
			             end if;
					when others => --In case of problem reset
						state <= S0;	  
				end case;
			   
                end if;
			end if;
		end if;
	end process;
	

end Behavioral;
