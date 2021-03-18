library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is

    generic (
        width : positive := 32);
    port (
        clk : in std_logic;
        rst : in std_logic;

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end datapath;

architecture STR of datapath is

    -- Stage 0
    signal b_0_0_out_0_real, b_0_0_out_0_img, b_0_0_out_1_real, b_0_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_0_0_db_out_0_real, b_0_0_db_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_0_0_db_out_1_real, b_0_0_db_out_1_img                              : std_logic_vector(width - 1 downto 0);

    signal b_0_1_out_0_real, b_0_1_out_0_img, b_0_1_out_1_real, b_0_1_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_0_1_db_out_0_real, b_0_1_db_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_0_1_tm_out_1_real, b_0_1_tm_out_1_img                              : std_logic_vector(width - 1 downto 0);

    -- Stage 1
    signal b_1_0_out_0_real, b_1_0_out_0_img, b_1_0_out_1_real, b_1_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_1_0_db_out_0_real, b_1_0_db_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_0_cm_out_1_real, b_1_0_cm_out_1_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_0_ds_out_0_real, b_1_0_ds_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_0_ds_out_1_real, b_1_0_ds_out_1_img                              : std_logic_vector(width - 1 downto 0);

    signal b_1_1_out_0_real, b_1_1_out_0_img, b_1_1_out_1_real, b_1_1_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_1_1_cm_out_0_real, b_1_1_cm_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_1_cm_out_1_real, b_1_1_cm_out_1_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_1_ds_out_0_real, b_1_1_ds_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_1_ds_out_1_real, b_1_1_ds_out_1_img                              : std_logic_vector(width - 1 downto 0);

    -- Stage 2
    signal b_2_0_out_0_real, b_2_0_out_0_img, b_2_0_out_1_real, b_2_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_2_0_ds_out_0_real, b_2_0_ds_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_0_ds_out_1_real, b_2_0_ds_out_1_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_0_db_out_0_real, b_2_0_db_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_0_db_out_1_real, b_2_0_db_out_1_img                              : std_logic_vector(width - 1 downto 0);

    signal b_2_1_out_0_real, b_2_1_out_0_img, b_2_1_out_1_real, b_2_1_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_2_1_ds_out_0_real, b_2_1_ds_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_1_ds_out_1_real, b_2_1_ds_out_1_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_1_tm_out_1_real, b_2_1_tm_out_1_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_1_db_out_0_real, b_2_1_db_out_0_img                              : std_logic_vector(width - 1 downto 0);

    -- Stage 3
    signal b_3_0_out_0_real, b_3_0_out_0_img, b_3_0_out_1_real, b_3_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_3_1_out_0_real, b_3_1_out_0_img, b_3_1_out_1_real, b_3_1_out_1_img : std_logic_vector(width - 1 downto 0);

begin

    -- butterfly naming convention b_x_y
    -- where x is the stage
    -- and y is the number

    ------------------------------------------------------------------------------------------------------------
    ---------------------------------------------  STAGE 0  ----------------------------------------------------
    ------------------------------------------------------------------------------------------------------------
    b_0_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => r0_input,
            input_0_img  => i0_input,
            input_1_real => r1_input,
            input_1_img  => i1_input,

            output_0_real => b_0_0_out_0_real,
            output_0_img  => b_0_0_out_0_img,
            output_1_real => b_0_0_out_1_real,
            output_1_img  => b_0_0_out_1_img);

    b_0_1 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => r2_input,
            input_0_img  => i2_input,
            input_1_real => r3_input,
            input_1_img  => i3_input,

            output_0_real => b_0_1_out_0_real,
            output_0_img  => b_0_1_out_0_img,
            output_1_real => b_0_1_out_1_real,
            output_1_img  => b_0_1_out_1_img);

    tm_0 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_0_1_out_1_real,
            dataa_imag => b_0_1_out_1_img,
            datab_real => (others => '0'),
            datab_imag => std_logic_vector(to_signed(-1, width)),

            result_real(width - 1 downto 0) => b_0_1_tm_out_1_real,
            result_imag(width - 1 downto 0) => b_0_1_tm_out_1_img);

    db_0 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_0_0_out_0_real,
            input_img   => b_0_0_out_0_img,
            output_real => b_0_0_db_out_0_real,
            output_img  => b_0_0_db_out_0_img);

    db_1 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_0_0_out_1_real,
            input_img   => b_0_0_out_1_img,
            output_real => b_0_0_db_out_1_real,
            output_img  => b_0_0_db_out_1_img);

    db_2 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_0_1_out_0_real,
            input_img   => b_0_1_out_0_img,
            output_real => b_0_1_db_out_0_real,
            output_img  => b_0_1_db_out_0_img);

    ------------------------------------------------------------------------------------------------------------
    ---------------------------------------------  STAGE 1  ----------------------------------------------------
    ------------------------------------------------------------------------------------------------------------
    b_1_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => b_0_0_db_out_0_real,
            input_0_img  => b_0_0_db_out_0_img,
            input_1_real => b_0_1_db_out_0_real,
            input_1_img  => b_0_1_db_out_0_img,

            output_0_real => b_1_0_out_0_real,
            output_0_img  => b_1_0_out_0_img,
            output_1_real => b_1_0_out_1_real,
            output_1_img  => b_1_0_out_1_img);

    b_1_1 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => b_0_0_db_out_1_real,
            input_0_img  => b_0_0_db_out_1_img,
            input_1_real => b_0_1_tm_out_1_real,
            input_1_img  => b_0_1_tm_out_1_img,

            output_0_real => b_1_1_out_0_real,
            output_0_img  => b_1_1_out_0_img,
            output_1_real => b_1_1_out_1_real,
            output_1_img  => b_1_1_out_1_img);

    cm_0 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_1_0_out_1_real,
            dataa_imag => b_1_0_out_1_img,
            datab_real => (others => '0'),
            datab_imag => (others => '0'),

            result_real(width - 1 downto 0) => b_1_0_cm_out_1_real,
            result_imag(width - 1 downto 0) => b_1_0_cm_out_1_img);

    cm_1 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_1_1_out_0_real,
            dataa_imag => b_1_1_out_0_img,
            datab_real => (others => '0'),
            datab_imag => (others => '0'),

            result_real(width - 1 downto 0) => b_1_1_cm_out_0_real,
            result_imag(width - 1 downto 0) => b_1_1_cm_out_0_img);

    cm_2 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_1_1_out_1_real,
            dataa_imag => b_1_1_out_1_img,
            datab_real => (others => '0'),
            datab_imag => (others => '0'),

            result_real(width - 1 downto 0) => b_1_1_cm_out_1_real,
            result_imag(width - 1 downto 0) => b_1_1_cm_out_1_img);

    db_3 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_1_0_out_0_real,
            input_img   => b_1_0_out_0_img,
            output_real => b_1_0_db_out_0_real,
            output_img  => b_1_0_db_out_0_img);

    ds_0 : entity work.data_shuffler
        generic map(
            delay_length => 2,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => '0', -- FIXME, need to add proper select signal (from controller)

            input_0_real => b_1_0_db_out_0_real,
            input_0_img  => b_1_0_db_out_0_img,
            input_1_real => b_1_1_cm_out_0_real,
            input_1_img  => b_1_1_cm_out_0_img,

            output_0_real => b_1_0_ds_out_0_real,
            output_0_img  => b_1_0_ds_out_0_img,
            output_1_real => b_1_0_ds_out_1_real,
            output_1_img  => b_1_0_ds_out_1_img);

    ds_1 : entity work.data_shuffler
        generic map(
            delay_length => 2,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => '0', -- FIXME, need to add proper select signal (from controller)

            input_0_real => b_1_0_cm_out_1_real,
            input_0_img  => b_1_0_cm_out_1_img,
            input_1_real => b_1_1_cm_out_1_real,
            input_1_img  => b_1_1_cm_out_1_img,

            output_0_real => b_1_1_ds_out_0_real,
            output_0_img  => b_1_1_ds_out_0_img,
            output_1_real => b_1_1_ds_out_1_real,
            output_1_img  => b_1_1_ds_out_1_img);

    ------------------------------------------------------------------------------------------------------------
    ---------------------------------------------  STAGE 2  ----------------------------------------------------
    ------------------------------------------------------------------------------------------------------------
    b_2_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => b_1_0_ds_out_0_real,
            input_0_img  => b_1_0_ds_out_0_img,
            input_1_real => b_1_0_ds_out_1_real,
            input_1_img  => b_1_0_ds_out_1_img,

            output_0_real => b_2_0_out_0_real,
            output_0_img  => b_2_0_out_0_img,
            output_1_real => b_2_0_out_1_real,
            output_1_img  => b_2_0_out_1_img);

    b_2_1 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => b_1_1_ds_out_0_real,
            input_0_img  => b_1_1_ds_out_0_img,
            input_1_real => b_1_1_ds_out_1_real,
            input_1_img  => b_1_1_ds_out_1_img,

            output_0_real => b_2_1_out_0_real,
            output_0_img  => b_2_1_out_0_img,
            output_1_real => b_2_1_out_1_real,
            output_1_img  => b_2_1_out_1_img);

    ds_2 : entity work.data_shuffler
        generic map(
            delay_length => 1,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => '0', -- FIXME, need to add proper select signal (from controller)

            input_0_real => b_2_0_out_0_real,
            input_0_img  => b_2_0_out_0_img,
            input_1_real => b_2_0_out_1_real,
            input_1_img  => b_2_0_out_1_img,

            output_0_real => b_2_0_ds_out_0_real,
            output_0_img  => b_2_0_ds_out_0_img,
            output_1_real => b_2_0_ds_out_1_real,
            output_1_img  => b_2_0_ds_out_1_img);

    ds_3 : entity work.data_shuffler
        generic map(
            delay_length => 1,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => '0', -- FIXME, need to add proper select signal (from controller)

            input_0_real => b_2_1_out_0_real,
            input_0_img  => b_2_1_out_0_img,
            input_1_real => b_2_1_out_1_real,
            input_1_img  => b_2_1_out_1_img,

            output_0_real => b_2_1_ds_out_0_real,
            output_0_img  => b_2_1_ds_out_0_img,
            output_1_real => b_2_1_ds_out_1_real,
            output_1_img  => b_2_1_ds_out_1_img);

    tm_1 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_2_1_ds_out_1_real,
            dataa_imag => b_2_1_ds_out_1_img,
            datab_real => (others => '0'),
            datab_imag => std_logic_vector(to_signed(-1, width)),

            result_real(width - 1 downto 0) => b_2_1_tm_out_1_real,
            result_imag(width - 1 downto 0) => b_2_1_tm_out_1_img);

    db_4 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_2_0_ds_out_0_real,
            input_img   => b_2_0_ds_out_0_img,
            output_real => b_2_0_db_out_0_real,
            output_img  => b_2_0_db_out_0_img);

    db_5 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_2_0_ds_out_1_real,
            input_img   => b_2_0_ds_out_1_img,
            output_real => b_2_0_db_out_1_real,
            output_img  => b_2_0_db_out_1_img);

    db_6 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_2_1_ds_out_0_real,
            input_img   => b_2_1_ds_out_0_img,
            output_real => b_2_1_db_out_0_real,
            output_img  => b_2_1_db_out_0_img);

    ------------------------------------------------------------------------------------------------------------
    ---------------------------------------------  STAGE 3  ----------------------------------------------------
    ------------------------------------------------------------------------------------------------------------
    b_3_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => b_2_0_db_out_0_real,
            input_0_img  => b_2_0_db_out_0_img,
            input_1_real => b_2_0_db_out_1_real,
            input_1_img  => b_2_0_db_out_1_img,

            output_0_real => r0_output,
            output_0_img  => i0_output,
            output_1_real => r1_output,
            output_1_img  => i1_output);

    b_3_1 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => b_2_1_db_out_0_real,
            input_0_img  => b_2_1_db_out_0_img,
            input_1_real => b_2_1_tm_out_1_real,
            input_1_img  => b_2_1_tm_out_1_img,

            output_0_real => r2_output,
            output_0_img  => i2_output,
            output_1_real => r3_output,
            output_1_img  => i3_output);

end STR;