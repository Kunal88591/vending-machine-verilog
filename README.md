# Vending Machine Controller

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Verilog](https://img.shields.io/badge/HDL-Verilog-blue.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Icarus Verilog](https://img.shields.io/badge/Simulator-Icarus%20Verilog-green.svg)](http://iverilog.icarus.com/)
[![GTKWave](https://img.shields.io/badge/Waveform-GTKWave-orange.svg)](http://gtkwave.sourceforge.net/)

A comprehensive Vending Machine Controller implemented using both **Moore** and **Mealy** Finite State Machines (FSM) in Verilog. This project demonstrates the design, simulation, and verification of FSM-based digital systems.

## 📋 Project Overview

This vending machine controller:
- **Item Price**: 7₹ (Rupees)
- **Accepted Coins**: 1₹, 2₹, and 5₹
- **Features**:
  - Automatic change calculation and return
  - Item dispensing when sufficient payment is received
  - Supports multiple payment combinations
  - Reset functionality for canceling transactions

### Moore vs Mealy FSM

| Feature | Moore FSM | Mealy FSM |
|---------|-----------|-----------|
| **Output Dependency** | Depends only on current state | Depends on current state AND input |
| **Response Time** | One clock cycle delay | Immediate (same cycle) |
| **State Count** | More states (S0-S10) | Fewer states (S0-S6) |
| **Design Complexity** | Simpler output logic | More complex output logic |

## 🏗️ Project Structure

```
vending-machine-verilog/
├── src/
│   ├── vending_machine_mealy.v    # Mealy FSM implementation
│   └── vending_machine_moore.v    # Moore FSM implementation
├── tb/
│   ├── tb_vending_machine_mealy.v # Mealy testbench
│   └── tb_vending_machine_moore.v # Moore testbench
├── scripts/
│   ├── run_simulation.sh          # Main simulation script
│   ├── view_mealy_wave.sh         # View Mealy waveforms
│   ├── view_moore_wave.sh         # View Moore waveforms
│   ├── mealy_wave.gtkw            # GTKWave config for Mealy
│   └── moore_wave.gtkw            # GTKWave config for Moore
├── build/                         # Generated build artifacts (auto-created)
├── docs/                          # Design documentation
├── Makefile                       # Build automation
└── README.md
```

## 🚀 Getting Started

### Prerequisites

Install the required tools:

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

**macOS:**
```bash
brew install icarus-verilog gtkwave
```

**Verify Installation:**
```bash
iverilog -v
gtkwave --version
```

### Quick Start

1. **Clone the repository:**
```bash
git clone https://github.com/kunal885911/vending-machine-verilog.git
cd vending-machine-verilog
```

2. **Run all simulations:**
```bash
make test
```

3. **View waveforms:**
```bash
make wave-mealy    # View Mealy FSM waveforms
make wave-moore    # View Moore FSM waveforms
```

## 🔧 Usage

### Using Makefile (Recommended)

The project includes a comprehensive Makefile for easy compilation and simulation:

```bash
# Show all available commands
make help

# Compile and run Mealy FSM
make mealy

# Compile and run Moore FSM
make moore

# Run both simulations
make test

# Compile only (without running)
make compile-mealy
make compile-moore

# View waveforms
make wave-mealy
make wave-moore

# Clean build artifacts
make clean
```

### Using Shell Scripts

```bash
# Run all simulations
./scripts/run_simulation.sh

# View waveforms
./scripts/view_mealy_wave.sh
./scripts/view_moore_wave.sh
```

### Manual Compilation

```bash
# Create build directory
mkdir -p build

# Compile Mealy FSM
iverilog -g2012 -Wall -o build/mealy_sim src/vending_machine_mealy.v tb/tb_vending_machine_mealy.v

# Run Mealy simulation
vvp build/mealy_sim

# View Mealy waveform
gtkwave build/tb_vending_machine_mealy.vcd
```

## 📊 Test Cases

Both testbenches include comprehensive test scenarios:

1. **Exact Payment**: 2₹ + 5₹ = 7₹
2. **Overpayment**: 5₹ + 5₹ = 10₹ (Change: 3₹)
3. **Multiple Small Coins**: Seven 1₹ coins
4. **Mixed Coins**: 1₹ + 1₹ + 2₹ + 2₹ + 1₹ = 7₹
5. **Overpayment Scenario**: 2₹ + 2₹ + 5₹ = 9₹ (Change: 2₹)
6. **Reset During Transaction**: Tests reset functionality
7. **No Coin Input**: Idle state verification

## 🎯 Module Interface

### Input Signals
- `clk`: System clock
- `reset`: Asynchronous reset (active high)
- `coin[2:0]`: Coin input encoding
  - `3'b001` = 1₹
  - `3'b010` = 2₹
  - `3'b101` = 5₹
  - `3'b000` = No coin

### Output Signals
- `dispense`: Item dispense signal (active high)
- `change[2:0]`: Change amount (0-3₹)
- `total[3:0]`: Total amount collected (0-10₹)

## 🎨 Waveform Analysis

After running simulations, VCD files are generated in the `build/` directory:
- `tb_vending_machine_mealy.vcd`
- `tb_vending_machine_moore.vcd`

View them with GTKWave to observe:
- State transitions
- Coin insertions
- Dispense signals
- Change calculation
- Total accumulation

## 📚 Design Details

### State Encoding

**Mealy FSM States:**
- IDLE (0): No money collected
- S1-S6 (1-6): States representing 1₹ to 6₹ collected

**Moore FSM States:**
- IDLE (0): No money collected
- S1-S6 (1-6): States representing 1₹ to 6₹ collected
- S7-S10 (7-10): Dispense states with appropriate change

### Key Features

✅ **Robust Design**: Handles all valid coin combinations  
✅ **Change Management**: Automatically calculates and returns change  
✅ **Reset Safety**: Can cancel transaction at any time  
✅ **Comprehensive Testing**: Multiple test scenarios included  
✅ **Well-Documented**: Clear code comments and documentation  
✅ **Waveform Support**: Pre-configured GTKWave views  

## 🛠️ Development

### Adding New Test Cases

Edit the testbench files in `tb/` directory and add your test scenarios:

```verilog
// Example: Custom test case
$display("Custom Test: Insert coins...");
coin = 3'b001; #10;  // Insert 1₹
coin = 3'b101; #10;  // Insert 5₹
coin = 3'b001; #10;  // Insert 1₹
```

### Modifying FSM Behavior

Edit the source files in `src/` directory:
- `vending_machine_mealy.v`: Mealy FSM implementation
- `vending_machine_moore.v`: Moore FSM implementation

## 📖 Documentation

Additional documentation available in the `docs/` directory:
- State diagrams
- Timing diagrams
- Design specifications
- Implementation notes

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the MIT License.

## 👤 Author

**kunal885911**
- GitHub: [@kunal885911](https://github.com/kunal885911)
- GitHub: [@kunal885911](https://github.com/kunal88591)

## 🙏 Acknowledgments

- Digital Design and Computer Architecture principles
- Verilog HDL best practices
- Finite State Machine theory

---

**⭐ If you find this project helpful, please consider giving it a star!**
