# Scholar FPGA LED Blinker

A first hardware design on the **Scholar** board — a compact, USB-powered FPGA
trainer built around a Xilinx Spartan-3A (XC3S200A-VQG100), designed and
manufactured by Addlek Systems, Bengaluru.

This project takes the board's onboard 12 MHz oscillator, divides it down
inside the FPGA fabric with a free-running binary counter, and drives one bit
of that counter out to a header pin to blink an external LED — exercising the
full FPGA toolchain (RTL → synthesis → place-and-route → bitstream → load)
in the simplest possible design.

Full write-up (Introduction / Circuit and Working / Software / Construction
and Testing), submitted to *Electronics For You*: see
`docs/EFY_Scholar_Blinker_Article.docx` in this repo, or the version attached
in the accompanying chat.

## Repository contents

```
rtl/led_blinker.v            Verilog source — 24-bit free-running counter
constraints/led_blinker.ucf  Pin constraints (User Constraints File, ISE)
bitstream/blinker.bit        Compiled bitstream for XC3S200A-VQG100 (3s200avq100)
docs/                        Article, block diagram, and build photos
```

## Hardware

| Ref | Part                          | Function                                   |
|-----|-------------------------------|---------------------------------------------|
| U1  | Xilinx XC3S200A-VQG100        | FPGA — hosts the clock-divider logic        |
| U2  | Microchip PIC18LF14K50-SSOP   | USB interface and FPGA configuration control|
| U3  | Winbond W25X20BV              | 2-Mbit SPI flash, stores the bitstream      |
| Y1  | 12 MHz oscillator (ABM8G)     | Sole clock reference, feeds FPGA pin 43     |
| R10 | 330 Ω resistor                | Current-limits the external red LED         |
| —   | Red LED (external, breadboard)| Visual output for the blinker               |

## How it works

- `clk_in` (FPGA pin 43) is wired directly to the board's only clock source,
  a 12 MHz oscillator (Y1), via a global clock input.
- A 24-bit counter free-runs on every rising edge of `clk_in`.
- Bit 23 is wired straight to `led_out` (FPGA pin 44, the IO_CLK header pin).
  It toggles roughly every 0.7 s (2^23 ÷ 12,000,000 ≈ 0.70 s), so the LED
  cycles fully on/off a little under once a second.
- A 330 Ω resistor in series with a red LED across the header pin and an
  adjacent ground pin converts the divided clock into a visible blink.

## Toolchain

Built with **Xilinx ISE WebPACK** (free, supports the Spartan-3A family),
targeting `3s200avq100`. The compiled bitstream (`blinker.bit`) is loaded
onto the board with Addlek's **Accelar** utility over USB — no JTAG pod or
external programmer required. Accelar's Load Program screen selects the
board type (Scholar), the USB port, and the target `.bit` file; clicking
Load writes it into the onboard SPI flash, after which the microcontroller
resets and reconfigures the FPGA from flash automatically.

## Author

Ramakumar Mayil Dilli Babu
