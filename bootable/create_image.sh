#!/usr/bin/env bash
set -e

echo "[GHOST_BOOTABLE] Creo immagine Ghost_OS RAW compatibile..."

# 1. Preparo rootfs
rm -rf rootfs
mkdir -p rootfs

# 2. Copio tutto Ghost_OS dentro rootfs
cp -r ../ghost_os ../core ../ops ../rituals ../missions ../var rootfs/
cp -r ../docs rootfs/
cp -r ../flipper rootfs/
cp ../README.md rootfs/

# 3. Creo archivio rootfs
echo "[GHOST_BOOTABLE] Creo archivio rootfs.tar.gz..."
tar -czf rootfs.tar.gz rootfs/

# 4. Creo immagine RAW da 512MB
echo "[GHOST_BOOTABLE] Creo ghost_os.img RAW..."
dd if=/dev/zero of=ghost_os.img bs=1M count=512

# 5. Inserisco rootfs.tar.gz all'inizio dell'immagine
echo "[GHOST_BOOTABLE] Inserisco rootfs.tar.gz nell'immagine..."
dd if=rootfs.tar.gz of=ghost_os.img conv=notrunc

echo "[GHOST_BOOTABLE] Immagine RAW creata con successo!"
ls -lh ghost_os.img
