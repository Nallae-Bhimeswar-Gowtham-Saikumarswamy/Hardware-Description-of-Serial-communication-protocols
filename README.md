# UART and SPI Communication Modules

## Overview
This project provides Verilog implementations for two essential communication protocols: UART (Universal Asynchronous Receiver/Transmitter) and SPI (Serial Peripheral Interface). Both modules are designed to facilitate data communication between devices, each with its own set of features and operational characteristics.

## UART Module

### Description
The UART module is designed to enable asynchronous serial communication. It supports data transmission and reception with configurable baud rates. This module is particularly useful for applications that require reliable, serial data communication without needing a clock signal to synchronize data transfer.

### Features
- **Baud Rate Generation**: Generates the appropriate baud rate signal based on a system clock and a configurable baud rate parameter.
- **Data Transmission**: Handles serial data transmission with start, data, and stop bits. It includes logic for sending data one bit at a time.
- **Data Reception**: Receives serial data by sampling at the baud rate and reconstructing it into parallel form.
- **Status Indicators**: Provides status signals to indicate the completion of data transmission and reception.

### Operation
The UART module operates by dividing the system clock to produce a baud rate clock. This clock is used to time the transmission and reception of data. The module employs state machines to handle different stages of data transmission and reception, including start bit detection, data bit transmission, and stop bit handling.

## SPI Module

### Description
The SPI module implements the Serial Peripheral Interface protocol, which allows for synchronous serial communication between a master and one or more slave devices. It provides a reliable means of data transfer using dedicated clock and control signals.

### Features
- **Clock Generation**: Produces the SPI clock (`sclk`) required for synchronizing the data transfer.
- **Data Transmission**: Transmits 12-bit data serially via the `mosi` (Master Out Slave In) line, with control signals to manage the chip select (`cs`).
- **Control Signals**: Manages the `cs` (Chip Select) line to activate and deactivate slave devices during communication.
- **Status Indicators**: Includes a `done` signal to indicate the completion of the data transmission process.

### Operation
The SPI module utilizes a clock divider to generate the SPI clock signal from the system clock. A state machine controls the sequence of operations, including activating the chip select, transmitting data bit by bit, and deactivating the chip select once the transmission is complete.

## Testbenches
Each module comes with a corresponding testbench designed to validate its functionality. The testbenches simulate various scenarios to ensure correct operation of both UART and SPI communication protocols. They apply different input values, monitor output signals, and check for proper signal timing and data accuracy.

## How to Use
1. **Compile the Verilog Code**: Use a Verilog simulator (e.g., ModelSim, Vivado) to compile and simulate the UART and SPI modules.
2. **Run the Testbenches**: Execute the testbenches for each module to verify their functionality and ensure correct operation.
3. **Review the Results**: Check the simulation outputs to confirm that the UART and SPI modules perform as expected.
