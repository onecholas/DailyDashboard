library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
	generic (
		g_num_slaves : positive := 1,
		g_mode : unsigned (3 downto 0)
	);
	port (
		-- Inputs
		i_spiclk : std_logic,
		i_rstn : std_logic,

		-- SPI Interface
		o_spiclk : std_logic,
		i_miso : std_logic,
		o_mosi : std_logic,
		o_ss : std_logic (g_num_slaves - 1 downto 0),

		-- Data to send to slave
		i_mosi_data : std_logic_vector (7 downto 0),
		i_mosi_datavalid : std_logic,
		i_mosi_ss : std_logic_vector (g_num_slaves - 1 downto 0),

		-- Data recieved from slave
		o_miso_data : std_logic_vector (7 downto 0),
		o_miso_datavalid : std_logic
	);

end entity spi_master;

architecture behavioral of spi_master is

	-- SPI Interface Signals
	signal q_mosi, n_mosi : std_logic;
	signal q_ss, n_ss : std_logic_vector(g_num_slaves downto 0);	
	signal q_mosi_datavalid, q_miso_datavalid, n_mosi_datavalid, n_miso_datavalid : std_logic;
	
	-- SPI Registers
	signal q_mosi_data, q_miso_data, n_mosi_data, n_miso_data : std_logic_vector (7 downto 0);
	
	-- State Signals
	signal q_state, n_state : state;
	type state is (idle, active);
	signal q_count, n_count : std_logic_vector (2 downto 0);

begin

	
	state_sync : process (i_spiclk)
	begin

		if (i_rstn = '0') then
			q_state <= idle;
			q_mosi_data <= (others => '0');
			q_count <= (others => '1');
			q_ss <= (others => '1');
		elsif (falling_edge(i_spiclk)) then
			q_state <= n_state;
			q_mosi_data <= n_mosi_data;
			q_count <= n_count;
			q_ss <= n_ss;
		end if;		

	end process;
 
	state_async : process (q_state)
	begin

		if (q_state = idle) then
			if (i_mosi_datavalid = '1') then -- Go to active state
				n_state <= active;
				n_mosi_data <= i_mosi_data; -- Write data to register for MOSI
				n_count <= (others => '1'); -- Keep count at 7
				n_ss <= i_mosi_ss;	    -- 
			else -- Stay in idle state
				n_state <= idle;
				n_mosi_data <= (others => '0');
				n_count <= (others => '1');
				n_ss <= (others => '1');
			
			end if;
		
		else -- q_state = active
			if (unsigned(q_count) = to_unsigned(0, 3)) then -- Go to idle state
				n_state <= idle;
				n_mosi_data <= q_mosi_data;
				n_count <= std_logic_vector(unsigned(q_count) + to_unsigned(1, 3));
				n_ss <= q_ss;
			else -- Stay in active state
				n_state <= active;
				n_mosi_data <= q_mosi_data;
				n_count <= std_logic_vector(unsigned(q_count) + to_unsigned(1, 3));
				n_ss <= (others => '1');
			end if;
		end if;

	end process;

	

	-- Output assignment
	o_spiclk <= i_spiclk;

end architecture behavioral;


