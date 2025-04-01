# YubiKey Resident SSH Key Generator

This repository provides a **Docker-based tool** for generating **resident SSH keys** using a **YubiKey**. Resident keys allow secure SSH authentication without needing to store the private key on disk.

## What is a Resident SSH Key?

A **resident SSH key** is a key pair stored directly on a **FIDO2-compatible YubiKey**. Unlike traditional SSH keys, the **private key never leaves the YubiKey**, and only a reference to the key is needed on the host machine. This makes it more secure and convenient, especially when switching devices, as you can restore the key reference at any time.

## Features

- Generates **resident SSH keys** that are stored directly on the YubiKey.
- **Automatic key regeneration** (restore keys anytime using `ssh-keygen -K`).
- Uses **Docker** to provide an isolated and repeatable environment.
- Supports **optional UID tagging** for managing multiple resident keys.

## Prerequisites

- A **YubiKey 5 Series** or compatible **FIDO2 security key**.
- **Docker** and **Docker Compose** installed on your system.
- OpenSSH 8.2+ (for FIDO2 SSH key support).

## Setup

Clone this repository and navigate into the project directory:

```sh
git clone https://github.com/your-username/yubikey-resident.git
cd yubikey-resident
```

## Usage

To generate a **new resident SSH key**, run:

```sh
docker compose run --rm keygen
```

This will:

1. Prompt for an **optional key comment**.
2. Display **existing resident keys** stored on the YubiKey.
3. Prompt for an **optional UID** (to manage multiple keys).
4. Generate a **new SSH key** stored directly on your YubiKey.
5. Optionally drop you into a **bash shell** for further management.

### How Reference Files Are Stored

When generating a new resident SSH key, the reference files are automatically saved into the **`ssh_keys/`** folder (mapped to `/root/.ssh` in the container). These files include:

- **`id_ed25519_sk`** – A reference file pointing to the private key stored on the YubiKey. If a UID was provided, the filename will be formatted as `id_ed25519_sk_<UID>`.
- **`id_ed25519_sk.pub`** – The public key file used for SSH authentication.

Since the actual **private key never leaves the YubiKey**, these reference files are simply used to interact with the key stored on the device. If deleted, they can always be regenerated using:

```sh
ssh-keygen -K
```

### Restoring SSH Keys

If you lose the reference files (`id_ed25519_sk` and `id_ed25519_sk.pub`), you can **restore them** using:

```sh
ssh-keygen -K
```

This will retrieve all resident keys from your YubiKey.

### Listing Stored Keys

To check what resident keys are stored on your YubiKey, run:

```sh
ykman fido credentials list
```

This will show all stored keys, including any **UIDs** you assigned during key generation.

### Using SSH with Your YubiKey

Once the key is generated and restored, you can use it for SSH authentication:

```sh
ssh -i ~/.ssh/id_ed25519_sk user@server.com
```

If a UID was used, the correct filename should be specified, e.g.:
```sh
ssh -i ~/.ssh/id_ed25519_sk_<UID> user@server.com
```

## Security Considerations

✅ **Private keys never leave the YubiKey** (unlike standard SSH keys).\
✅ **No need to store sensitive key files.**\
✅ **Even if your local reference file is deleted, you can restore it anytime.**

❌ **You must have access to the same YubiKey and remember your PIN to recover your resident key.**

## Repository Structure

```
├── Dockerfile         # Sets up the container with OpenSSH and YubiKey Manager
├── docker-compose.yml # Defines the Docker service for key generation
├── keygen.sh          # The main script to generate resident keys
└── README.md          # This documentation
```

## Contributing

Feel free to open an issue or submit a pull request if you’d like to improve this project!

## License

MIT License

