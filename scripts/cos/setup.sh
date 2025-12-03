#!/bin/bash
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

# This script modifies the kernel command line in the GRUB configuration
# to add the 'spec_rstack_overflow=off' parameter.

EFI_DIR=$(mktemp -d)
# Mount the EFI System Partition. This is where grub.cfg is located.
# We are mounting /dev/sda12, which corresponds to partition A, the one GKE typically boots from.
mount /dev/disk/by-partlabel/EFI-SYSTEM "${EFI_DIR}"

# Add the kernel argument to all 'linux' lines in the grub config.
# This ensures it's applied to all boot entries.
# The `sed` command finds lines starting with 'linux' and appends the argument.
sed -i -e '/^\s*linux/ s/$/ spec_rstack_overflow=off/' "${EFI_DIR}/efi/boot/grub.cfg"

# Unmount the partition
umount "${EFI_DIR}"
rmdir "${EFI_DIR}"

echo "Kernel command line updated successfully."
