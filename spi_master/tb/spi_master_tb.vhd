library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity spi_master_tb is

	--generic (
	--	g_num_slaves_tb : positive := 1,
	--	g_mode_tb : unsigned (3 downto 0)
	--);
	--port (
	--	i_spiclk_tb : std_logic,
	--	i_rstn_tb : std_logic,

	--	-- SPI Interface
	--	o_spiclk_tb : std_logic,
	--	i_miso_tb : std_logic,
	--	o_mosi_tb : std_logic,
	--	o_ss_tb : std_logic (g_num_slaves - 1 downto 0),

	--	-- Data to send to slave
	--	i_mosi_data_tb : std_logic_vector (7 downto 0),
	--	i_mosi_datavalid_tb : std_logic,
	--	i_mosi_ss_tb : std_logic_vector (g_num_slaves - 1 downto 0),

	--	-- Data recieved from slave
	--	o_miso_data_tb : std_logic_vector (7 downto 0),
	--	o_miso_datavalid_tb : std_logic
	--);

end entity spi_master_tb;

architecture behavioral of spi_master_tb is

	component spi_master is
		
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
	
	end component;

	
	g_num_slaves_tb : positive := 3;
	g_mode_tb : unsigned (3 downto 0);
	i_spiclk_tb : std_logic;
	i_rstn_tb : std_logic;
	-- SPI Interface
	o_spiclk_tb : std_logic;
	i_miso_tb : std_logic;
	o_mosi_tb : std_logic;
	o_ss_tb : std_logic (g_num_slaves - 1 downto 0);
	-- Data to send to slave
	i_mosi_data_tb : std_logic_vector (7 downto 0);
	i_mosi_datavalid_tb : std_logic;
	i_mosi_ss_tb : std_logic_vector (g_num_slaves - 1 downto 0);
	-- Data recieved from slave
	o_miso_data_tb : std_logic_vector (7 downto 0);
	o_miso_datavalid_tb : std_logic;

begin

	dut : spi_master
	generic map (
		g_num_slaves => g_num_slaves_tb,
		g_mode => g_mode_tb
	);
	port map (
		i_spiclk => i_spiclk_tb,
		i_rstn => i_rstn_tb,
		o_spiclk => o_spiclk_tb,
		i_miso => i_miso_tb,
		o_mosi => o_mosi_tb,
		o_ss => o_ss_tb,
		i_mosi_data => i_mosi_data_tb,
		i_mosi_datavalid => i_mosi_datavalid_tb,
		i_mosi_ss => i_mosi_ss_tb,
		o_miso_data => o_miso_data_tb,
		o_miso_datavalid => o_miso_datavalid
	);

	clk : process
	begin
		i_spiclk_tb <= not clk wait 5 ps;
	end process;

	tb : process
	begin
		wait 10 ps;
		i_rstn_tb <= 0;
		wait 10 ps;
		i_rstn_tb <= 1;
		wait 5 ps;

		i_mosi_data_tb <= "0010011";
		i_mosi_ss_tb <= "001";
		wait 5 ps;
		i_mosi_datavalid_tb <= '0';
		wait 100 ps;

		
		i_mosi_data_tb <= "11001100";
		i_mosi_ss_tb <= "001";
		wait 5 ps;
		i_mosi_datavalid_tb <= '0';
		wait 100 ps;

	end process;

end architecture behavioral;
	
