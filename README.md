# Tlatia

A password-based utility to encrypt and decrypt files (like `ansible-vault`)

## Requirements

- Swift 5.0

## Install

```sh
$ ./install.sh
```

This will build the executable and copy it under your `/usr/local/bin`
directory for easy access.

## Usage

```sh
$ tlatia OPERATION INPUT OUTPUT
```

- *OPERATION*: `encrypt` | `decrypt`
- *INPUT*: Input file to encrypt or decrypt
- *OUTPUT*: Output file where to write the result

This will take a `utf8` encrypted file and ask for a password and then proceed
to encrypt/decrypt your file. If you are encrypting it will ask a confirmation
before proceeding.
