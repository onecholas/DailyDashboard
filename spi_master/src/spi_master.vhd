library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
	
	generic (
		g_num_slaves : positive := 1;
		g_mode : unsigned (3 downto 0);
	);
	port (
		i_spiclk : in std_logic;
		i_rstn : in std_logic;

		-- SPI Interface
		o_spiclk : out std_logic;
		i_miso : in std_logic;
		o_mosi : out std_logic;
		o_ss : out std_logic_vector (g_num_slaves - 1 downto 0);

		-- Data to send to slave
		i_mosi_data : in std_logic_vector (7 downto 0);
		i_mosi_datavalid : std_logic;
		i_mosi_ss : std_logic_vector (g_num_slaves - 1 downto 0);

		-- Data recieved from slave
		o_miso_data : std_logic_vector (7 downto 0);
		o_miso_datavalid : std_logic;
	);

end entity spi_master;

architecture behvaioral of spi_master is

	type state is (idle, transceive, ready);
	signal q_state, n_state : state;
	
	-- SPI Interface 
	signal n_mosi, q_mosi : std_logic;
	signal n_ss_int, n_ss_ext, q_ss_int, q_ss_ext : std_logic_vector (g_num_slaves - 1 downto 0);
	
	-- SPI internal signals
	signal n_miso_datavalid, q_miso_datavalid : std_logic;
	signal n_mosi_data, n_miso_data, q_mosi_data, q_miso_data : std_logic_vector (7 downto 0);	
	signal n_count, q_count : std_logic_vector (2 downto 0);

begin

	sync: process (i_spiclk) is begin

		if (i_arstn = '0') then
			-- Idle state	
			q_state <= idle;
			q_mosi <= '0';
			q_ss_int <= (others => '1');
			q_ss_ext <= (others => '1');
			q_miso_datavalid <= '0';
			q_mosi_data <= (others => '0');
			q_miso_data <= (others => '0');
			q_count <= (others => '1');
		elsif (falling_edge(i_spiclk)) then
			-- Next state
			q_state <= n_state;	
			q_mosi <= n_mosi;
			q_ss_int <= n_ss_int;
			q_ss_ext <= n_ss_ext;
			q_miso_datavalid <= n_miso_datavalid;
			q_mosi_data <= n_mosi_data;
			q_miso_data <= n_miso_data;
			q_count <= n_count;
		end if;
	end process;

	async: process () is begin
		if (state = idle) then
			if (i_mosi_datavaild = '1') then
				n_state <= transceive;
			else
				n_state <= idle;
			end if;
			n_mosi <= '0';
			n_ss_int <= i_mosi_ss;
			n_ss_ext <= (others => '1');
			n_miso_datavalid <= '0';
			n_mosi_data <= i_mosi_data;
			n_miso_data <= (others => '0');
			n_count <= (others => '1');
		elsif (state = transceive) then
			if (q_count = '0') then
				n_state <= ready;
			else
				n_state <= transceive;
			end if;	
			n_mosi <= q_mosi_data(7);
			n_ss_int <= q_ss_int;
			n_ss_ext <= q_ss_int;
			n_miso_datavalid <= '0';
			n_mosi_data <= q_mosi_data(6 downto 0) & '0';
			n_miso_data <= q_miso_data (6 downto 0) & i_miso;
			n_count <= std_logic_vector(unsigned(q_count) - to_unsigned(1, q_count'length));
		elsif (state = ready) then
			n_state <= idle;
			n_mosi <= (others => '0');
			n_ss_int <= (others => '1');
			n_ss_ext <= (others => '1');
			n_miso_datavalid <= '1';
			n_mosi_data <= (others => '0');
			n_miso_data <= q_miso_data;
			n_count <= q_count;
		end if;

	end process;

end architecture behavioral;
