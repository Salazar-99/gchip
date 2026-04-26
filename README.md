# gchip

SystemVerilog RISC-V CPU bring-up: RTL, testbenches, and simulation tooling.

## Layout

| Path | Purpose |
|------|---------|
| `rtl/` | SystemVerilog RTL (alu, regfile, decode, core_top, …) |
| `tb/` | Testbenches (SystemVerilog or cocotb) |
| `tests/` | RISC-V asm/C programs and generated `.elf` / `.hex` |
| `sim/` | Makefiles and run scripts for Verilator/cocotb |
| `waves/` | VCD/FST waveform dumps |
| `scripts/` | Build helpers, binary conversion, etc. |

## Dev container

Open this folder in Cursor / VS Code and run **Reopen in Container**.

Inside the container, verify tools:

```bash
verilator --version
riscv64-unknown-elf-gcc --version
python3 -c "import cocotb"
```

## Make targets

| Command | Description |
|---------|-------------|
| `make sim` | Build with Verilator and run the testbench, producing `waves/dump.vcd` |
| `make wave` | Print instructions for opening `waves/dump.vcd` (override path with `WAVE_FILE=...`) |
| `make test` | Run tests (placeholder until cocotb / ISA tests are wired) |
| `make clean` | Remove build artifacts and waveform dumps |

## Minimal tool stack

Recommended baseline: **Verilator**, **RISC-V GNU toolchain**, **Python + cocotb**, **Make**, **Git**.

Optional **Spike** is installed in the image when available from apt; otherwise build from source if you need a golden ISA reference.

## Development

### Typical loop

1. Edit RTL in `rtl/` or testbenches in `tb/`.
2. `make sim` — Verilator builds the testbench, runs it, and writes `waves/dump.vcd`.
3. Inspect the waves (see below).
4. Iterate.

The default top is `adder_tb`. Override on the command line, e.g.:

```bash
make -C sim sim TOP=alu_tb SOURCES="rtl/alu.sv tb/alu_tb.sv"
```

### Viewing waveforms with Surfer

[Surfer](https://surfer-project.org) is the recommended VCD/FST viewer for this project. There are three ways to use it; pick whichever fits your workflow.

**1. Inside Cursor / VS Code (default, zero setup)**

The devcontainer auto-installs the [`surfer-project.surfer`](https://marketplace.visualstudio.com/items?itemName=surfer-project.surfer) extension. After `make sim`, just click `waves/dump.vcd` in the file explorer and it opens in an editor tab. Works headlessly — no X11, no host install.

**2. Native Surfer on your host**

For large dumps the native build is noticeably snappier than the WASM extension.

- macOS: `brew install --cask surfer` (unsigned — if Gatekeeper blocks it, run `sudo xattr -dr com.apple.quarantine /Applications/Surfer.app` once).
- Linux / Windows: download a release from <https://gitlab.com/surfer-project/surfer/-/releases>, or `cargo install --locked surfer`.

Then, since the repo is bind-mounted into the container, just open the file from your host:

```bash
open -a surfer waves/dump.vcd     # macOS
surfer waves/dump.vcd             # Linux / Windows
```

`make wave` prints these commands as a reminder.

**3. The web build**

<https://app.surfer-project.org> can load a local file via drag-and-drop if you don't want to install anything at all.

### Adding RTL or testbenches

- New design files go in `rtl/` and are picked up by extending `SOURCES` in `sim/Makefile`.
- New testbenches go in `tb/`. Set `TOP=<module_name>` so Verilator knows what to elaborate.
- Keep modules lint-clean under `verilator -Wall`; the build treats warnings as errors.
