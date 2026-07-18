# 8086 Security Lock System

A small 16-bit DOS assembly program that demonstrates credential lookup and byte-level password transformation. It stores ten numeric employee IDs and passwords, transforms the password table at startup, and repeatedly prompts for credentials until a matching pair grants access.

This is an educational authentication simulation, not a production security system: all credentials and the reversible transformation are embedded in the executable.

## Functionality

The source implements:

- startup transformation of ten one-byte passwords;
- decimal employee-ID input;
- linear search through a word-sized ID array;
- hidden numeric password input through DOS interrupt `21h`, function `08h`;
- comparison against the transformed password associated with the matched ID;
- distinct messages for unknown IDs, incorrect passwords, and successful access; and
- repeated login attempts after unsuccessful authentication.

The transformation rotates the password byte left once, then conditionally rotates it right twice when bits 7 and 0 are both clear.

## Stack and architecture

- Intel 8086 real-mode assembly
- MASM/TASM-style syntax and small memory model
- DOS interrupt `21h` console and process services
- parallel fixed-size arrays:
  - `EmpIDs`: ten 16-bit IDs
  - `OrigPW`: ten 8-bit numeric passwords
  - `EncPW`: transformed passwords generated at runtime
- stack-based register preservation and temporary arithmetic in the numeric input routines

## Repository structure

```text
.
├── README.md
└── projectOne.asm
```

All program data, input routines, credential validation, and password transformation are contained in `projectOne.asm`.

## Build and run

The program targets 16-bit DOS and therefore does not run directly in 64-bit Windows. Use MASM or TASM inside DOSBox (or another compatible DOS environment).

With TASM:

```text
tasm projectOne.asm
tlink projectOne.obj
projectOne.exe
```

With MASM:

```text
masm projectOne.asm;
link projectOne.obj;
projectOne.exe
```

Exact command names can vary with the installed assembler/linker version.

## Usage

1. Start `projectOne.exe`.
2. Enter a numeric employee ID and press Enter.
3. If the ID exists, enter its numeric password and press Enter. Password digits are not echoed.
4. Invalid credentials return to the ID prompt. Valid credentials print the access-allowed message and terminate.

For a direct source-level example, employee ID `65` is paired with original password `125`. Input values are decimal and non-digit keystrokes are ignored.

## Project report

[Assembly_Project.pdf](https://github.com/user-attachments/files/19913692/Assembly_Project.pdf)

## Future improvements

- Remove embedded credentials and load salted password hashes from protected storage.
- Limit retries and add lockout or delay behavior.
- Detect numeric overflow and reject overlong ID/password input.
- Provide clearer input feedback while retaining password masking.
- Add scripted emulator tests for valid, invalid, and boundary-value inputs.
