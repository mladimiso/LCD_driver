----------------------------------------------------------------------------------
-- File : .vhd
-- Author : Milos Kovacevic <milos.kovacevic@rt-rk.com>
-- Created : 14:06h
--
---------------------------------------------------------------------------
--
-- $RCSfile: $
-- $Revision: $
-- $Author: $
-- $Date: $
-- $Source: $
--
-- Description: <description>
--
---------------------------------------------------------------------------
-- The following is Company Confidential Information.
-- Copyright (c) 2006
-- All rights reserved. This program is protectedas an
-- unpublished work under the Copyright Act of 1976 and the ComputerSoftware
-- Act of 1980. This program is also considered a trade secret. It is not to
-- be disclosed or used by parties who have not received written authorization
-- from Company, Inc.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity timer32 is 
port (
	clk : in STD_LOGIC;
	inRst : in STD_LOGIC;
	iStartTimer : in STD_LOGIC;
	iStopValue : in STD_LOGIC_VECTOR(31 downto 0);
	oTimerOut : out STD_LOGIC
);
end timer32;

architecture RTL of timer32 is

	-- input
	signal sStopValue : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

	-- output
	signal sTimerOut : STD_LOGIC := '0';

	-- internal
	signal sCounter : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal sStartDelay : STD_LOGIC := '0';
	signal sStartTimer : STD_LOGIC := '0';
	
begin

	oTimerOut <= sTimerOut;
	sStopValue <= iStopValue when sCounter = x"0000_0000" else
						sStopValue;
	sStartTimer <= iStartTimer and not(sStartDelay);
	
	process (clk, inRst)
	begin
		
		if (inRst = '0') then
			sStartDelay <= '0';
		elsif (clk'event and clk = '1') then
			sStartDelay <= iStartTimer;
		end if;
		
	end process;
	
	process (clk, inRst)
	begin
	
		if (inRst = '0') then 
			sTimerOut <= '0';
			sCounter <= (others => '0');
		elsif (clk'event and clk = '1') then
			if(sStartTimer = '1')then
				sCounter <= STD_LOGIC_VECTOR(TO_UNSIGNED(1,32));
			elsif (sCounter /= x"0000_0000" ) then
				if (sCounter < sStopValue) then
					sCounter <= STD_LOGIC_VECTOR(UNSIGNED(sCounter) + 1);
					sTimerOut <= '0';
				else
					sCounter <= (others => '0');
					sTimerOut <= '1';
				end if;
			else
				sTimerOut <= '0';
			end if;
		
		end if;
		
	end process;

end RTL;
