library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity even_stage is

    generic (
        width       : positive := 16;
        delayLength : positive := 2;
        multLength  : positive := 4);
    port (
        clk : in std_logic;
        rst : in std_logic;

        tg0_select, tg1_select, tg2_select : in std_logic_vector(1 downto 0);

        ds_0_select, ds_1_select, ds_2_select, ds_3_select : in std_logic;

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end even_stage;

architecture STR of even_stage is

    signal b_1_0_out_0_real, b_1_0_out_0_img, b_1_0_out_1_real, b_1_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_1_0_db_out_0_real, b_1_0_db_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_0_cm_out_1_real_2x, b_1_0_cm_out_1_img_2x                        : std_logic_vector((width * 2) - 1 downto 0);
    alias b_1_0_cm_out_1_real is b_1_0_cm_out_1_real_2x((width * 2) - 2 downto width - 1);
    alias b_1_0_cm_out_1_img is b_1_0_cm_out_1_img_2x((width * 2) - 2 downto width - 1);

    signal b_1_0_ds_out_0_real, b_1_0_ds_out_0_img : std_logic_vector(width - 1 downto 0);
    signal b_1_0_ds_out_1_real, b_1_0_ds_out_1_img : std_logic_vector(width - 1 downto 0);
    signal tg0_real, tg0_imag                      : std_logic_vector(DATA_RANGE);

    signal b_1_1_out_0_real, b_1_1_out_0_img, b_1_1_out_1_real, b_1_1_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_1_1_cm_out_0_real_2x, b_1_1_cm_out_0_img_2x                        : std_logic_vector((width * 2) - 1 downto 0);
    alias b_1_1_cm_out_0_real is b_1_1_cm_out_0_real_2x((width * 2) - 2 downto width - 1);
    alias b_1_1_cm_out_0_img is b_1_1_cm_out_0_img_2x((width * 2) - 2 downto width - 1);

    signal b_1_1_cm_out_1_real_2x, b_1_1_cm_out_1_img_2x : std_logic_vector((width * 2) - 1 downto 0);
    alias b_1_1_cm_out_1_real is b_1_1_cm_out_1_real_2x((width * 2) - 2 downto width - 1);
    alias b_1_1_cm_out_1_img is b_1_1_cm_out_1_img_2x((width * 2) - 2 downto width - 1);

    signal tg1_real, tg1_imag : std_logic_vector(DATA_RANGE);
    signal tg2_real, tg2_imag : std_logic_vector(DATA_RANGE);
begin

    b_1_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            input_0_real => r0_input,
            input_0_img  => i0_input,
            input_1_real => r1_input,
            input_1_img  => i1_input,

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

            input_0_real => r2_input,
            input_0_img  => i2_input,
            input_1_real => r3_input,
            input_1_img  => i3_input,

            output_0_real => b_1_1_out_0_real,
            output_0_img  => b_1_1_out_0_img,
            output_1_real => b_1_1_out_1_real,
            output_1_img  => b_1_1_out_1_img);

    tg_0 : entity work.twiddle_gen
        generic map(
            width => width,
            tw0_r => REAL_0,
            tw0_i => IMAG_0,
            tw1_r => REAL_2,
            tw1_i => IMAG_2,
            tw2_r => REAL_4,
            tw2_i => IMAG_4,
            tw3_r => REAL_6,
            tw3_i => IMAG_6)
        port map(
            -- this selects which of the generic inputted twiddle factors to output
            theta_index_select => tg0_select,

            twiddle_real => tg0_real,
            twiddle_img  => tg0_imag);

    cm_0 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_1_0_out_1_real,
            dataa_imag => b_1_0_out_1_img,
            datab_real => tg0_real,
            datab_imag => tg0_imag,

            result_real => b_1_0_cm_out_1_real_2x,
            result_imag => b_1_0_cm_out_1_img_2x);

    tg_1 : entity work.twiddle_gen
        generic map(
            width => width,
            tw0_r => REAL_0,
            tw0_i => IMAG_0,
            tw1_r => REAL_1,
            tw1_i => IMAG_1,
            tw2_r => REAL_2,
            tw2_i => IMAG_2,
            tw3_r => REAL_3,
            tw3_i => IMAG_3)
        port map(
            -- this selects which of the generic inputted twiddle factors to output
            theta_index_select => tg1_select,

            twiddle_real => tg1_real,
            twiddle_img  => tg1_imag);

    cm_1 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_1_1_out_0_real,
            dataa_imag => b_1_1_out_0_img,
            datab_real => tg1_real,
            datab_imag => tg1_imag,

            result_real => b_1_1_cm_out_0_real_2x,
            result_imag => b_1_1_cm_out_0_img_2x);

    tg_2 : entity work.twiddle_gen
        generic map(
            width => width,
            tw0_r => REAL_0,
            tw0_i => IMAG_0,
            tw1_r => REAL_3,
            tw1_i => IMAG_3,
            tw2_r => REAL_6,
            tw2_i => IMAG_6,
            tw3_r => REAL_9,
            tw3_i => IMAG_9)
        port map(
            -- this selects which of the generic inputted twiddle factors to output
            theta_index_select => tg2_select,

            twiddle_real => tg2_real,
            twiddle_img  => tg2_imag);

    cm_2 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_1_1_out_1_real,
            dataa_imag => b_1_1_out_1_img,
            datab_real => tg2_real,
            datab_imag => tg2_imag,

            result_real => b_1_1_cm_out_1_real_2x,
            result_imag => b_1_1_cm_out_1_img_2x);

    db_3 : entity work.pipe_reg
        generic map(
            length => multLength,
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
            delay_length => delayLength,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => ds_0_select,

            input_0_real => b_1_0_db_out_0_real,
            input_0_img  => b_1_0_db_out_0_img,
            input_1_real => b_1_1_cm_out_0_real,
            input_1_img  => b_1_1_cm_out_0_img,

            output_0_real => r0_output,
            output_0_img  => i0_output,
            output_1_real => r1_output,
            output_1_img  => i1_output);

    ds_1 : entity work.data_shuffler
        generic map(
            delay_length => delayLength,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => ds_1_select,

            input_0_real => b_1_0_cm_out_1_real,
            input_0_img  => b_1_0_cm_out_1_img,
            input_1_real => b_1_1_cm_out_1_real,
            input_1_img  => b_1_1_cm_out_1_img,

            output_0_real => r2_output,
            output_0_img  => i2_output,
            output_1_real => r3_output,
            output_1_img  => i3_output);

end STR;