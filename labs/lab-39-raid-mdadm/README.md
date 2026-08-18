# Lab 39 — Storage Resilience with Software RAID (mdadm)

The learner builds a RAID 1 mirror from loop devices, writes data, fails a disk, and confirms the data survives — the resilience leg of the CIA triad.

Run on https://killercoda.com/playgrounds/scenario/ubuntu

**Objective:** Build redundant storage and survive a disk failure

**You'll build:** A RAID 1 array that keeps serving data after one member is failed and removed.

**Tools:** mdadm, losetup, mkfs.ext4

---

## Step 1 — Install mdadm and create two virtual disks

```bash
apt install -y mdadm && for d in 1 2; do dd if=/dev/zero of=/disk$d.img bs=1M count=200; done
```


## Step 2 — Attach them as loop devices

```bash
lo1=$(losetup -f --show /disk1.img); lo2=$(losetup -f --show /disk2.img)
```


## Step 3 — Create a RAID 1 mirror

```bash
mdadm --create /dev/md0 --level=1 --raid-devices=2 $lo1 $lo2
```


## Step 4 — Format and write a file

```bash
mkfs.ext4 /dev/md0 && mkdir -p /mnt/r && mount /dev/md0 /mnt/r && echo IMPORTANT > /mnt/r/data.txt
```


## Step 5 — Fail and remove one disk

```bash
mdadm /dev/md0 --fail $lo1 --remove $lo1
```


## Step 6 — Confirm data survives on the degraded array

```bash
cat /mnt/r/data.txt && mdadm --detail /dev/md0 | grep State
```


---

## Verify

The array reports a degraded state after the disk failure yet still returns the original file contents.
