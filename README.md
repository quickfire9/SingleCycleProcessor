# 🧠 ARMv8/LEGv8 Single-Cycle CPU in Verilog

This repository implements a single-cycle MIPS CPU in Verilog, featuring core components such as the ALU, instruction and data memory, control logic, and register files. It includes testbenches and an example assembly program to simulate and verify the design using GTKWave.

## 🚀 Features

- ALU with arithmetic and logic operations
- Single-cycle datapath and control logic
- Instruction and data memory
- Register file with write-back support
- Sign extension for immediate values
- PC and NextPC logic
- VCD waveform generation for debugging
- Sample MIPS assembly program for debugging and testing (`movz_test.s`); this is implemented in InstructionMemory.v
- Testbenches for critical modules

---

## 📁 File Overview

| File                   | Description                                      |
|------------------------|--------------------------------------------------|
| `ALU.v`                | Arithmetic Logic Unit                            |
| `ALUTest.v`            | ALU testbench                                    |
| `DataMemory.v`         | Data memory module                               |
| `InstructionMemory.v`  | Instruction memory module                        |
| `NextPClogic.v`        | Logic for determining next PC                    |
| `NextPC_tb.v`          | Testbench for PC logic                           |
| `RegisterFile.v`       | Register file module                             |
| `RegisterFileTest.v`   | Register file testbench                          |
| `SignExtender.v`       | Sign extension unit                              |
| `SignExtender_tb.v`    | Sign extender testbench                          |
| `SingleCycleControl.v` | Main control logic for single-cycle CPU          |
| `movz_test.s`          | MIPS assembly program for simulation             |
| `fullcpu`              | Top-level integration or compiled binary         |

---

## 💻 Requirements

- [Icarus Verilog](https://steveicarus.github.io/iverilog/)
- [GTKWave](http://gtkwave.sourceforge.net/) (custom formula for macOS Sonoma)

---

## 🍎 macOS Setup (Sonoma-compatible)

### ✅ Install Icarus Verilog

```bash
brew install icarus-verilog
```

### ✅ Install GTKWave (macOS Sonoma Workaround)

GTKWave requires a custom Homebrew formula to run properly on macOS Sonoma.

1. Save the following formula as `gtkwave.rb` in your working directory:

```ruby
# gtkwave.rb
class Gtkwave < Formula
  desc "GTKWave"
  homepage "https://gtkwave.sourceforge.net"
  license "GPL-2.0-or-later"
  head "https://github.com/randomplum/gtkwave.git", branch: "macos_sonoma"

  depends_on "desktop-file-utils" => :build
  depends_on "shared-mime-info" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
end
```

2. Run the following command to install:

```bash
brew install --build-from-source --HEAD ./gtkwave.rb
```

> Reference: [GTKWave GitHub Issue #250](https://github.com/gtkwave/gtkwave/issues/250)

### ⚠️ Known Issue on Apple Silicon

On Apple Silicon laptops, GTKWave may only render waveforms correctly on **external monitors**. On the built-in screen, only a quarter of the waveform display may render. This is a known GTK rendering bug. Additional fixes are showin in the issue above to get GTKWave working closer to expected.

---

## 🧪 How to Simulate

1. Compile a testbench:
```bash
iverilog -o alu_test ALU.v ALUTest.v
```

2. Run the simulation:
```bash
vvp alu_test
```
OR
```bash
./alu_test
```

3. View the waveform output: (if specified in the testbench)
```bash
gtkwave dump.vcd
```

Adjust file names as needed for other modules/testbenches.

---

## Executing ARM Instructions

To write your own instructions, edit InstructionMemory.v by adding 63'h[instruction byte] Data = 32h'[encoded instrction]


---
## 🔗 Resources

- [GTKWave GitHub Issue #250](https://github.com/gtkwave/gtkwave/issues/250)
- [GTKWave Home](http://gtkwave.sourceforge.net/)
- [Icarus Verilog](https://steveicarus.github.io/iverilog/)

---

## 🧑‍💻 Author

Developed as part of a digital systems project focused on CPU architecture and hardware simulation. Contributions and feedback welcome!
