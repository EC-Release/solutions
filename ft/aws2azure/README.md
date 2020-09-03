
# AWS to Azure - File Transfer using EC (Enterprise Connect)

# Table of Contents

- [The Original Report](#the-original-report)
  -[Testing Method](#testing-method)
  - [Consolidated Results](#consolidated-results)
  - [Observations](#observations)
  - [Action Items](#action-items)
- [The Follow up Report](#the-follow-up-report)
  - [Spec](#spec)
  - [Test script](#test-script)
  - [Benchmark result](#benchmark-resukt)
- [Reference](#reference)

## The Origin Report
see [reference[1]](#reference)

### Testing Method

### Consolidated Results

| File Size | Time Taken #1 | Time Taken #2 | Time Taken #3 | Time Taken #4 | Time Taken #5 |
|-----|------|------|------|------|-----|
| 1 MB | 0m0.803s | 0m0.770s | 0m0.807s | 0m0.785s | 0m0.813s |
| 10 MB | 0m1.245s | 0m1.226s | 0m1.188s | 0m1.221s | 0m1.196s |
| 100 MB | 0m6.532s | 0m6.202s | 0m6.335s | 0m5.930s | 0m5.903s |
| 1024 MB | 0m53.796s | 0m56.601s | 0m58.240s | 0m57.739s | 0m59.303s |

Consolidated Results

| File Size | Average Time (sec) | Throughput (MB per sec) |
| --------- | ------------------ | ----------------------- |
| 1 MB | 0.80 | |
| 10 MB | 1.22 | |
| 100 MB | 6.18 | |
| 1024 MB | 57.14 | |


### Observations

### Action Items

AWS : t2.large
Azure : Standard D2s v3 (2 vcpus, 8 GiB memory)

Setup

```
dd if=/dev/urandom of=/root/1MB.img bs=1M count=1
dd if=/dev/urandom of=/root/10MB.img bs=1M count=10
dd if=/dev/urandom of=/root/100MB.img bs=1M count=100
dd if=/dev/urandom of=/root/1024MB.img bs=1M count=1024
```
Commands for file copy

Following example pulls file from the other ec2 instance, make sure that prior to running below, generate the image creation fresh to discount file-cache effect.
```
time scp -P 6192 -i ~/.ssh/id_rsa /root/1MB.img zameer@localhost:/tmp
time scp -P 6192 -i ~/.ssh/id_rsa /root/10MB.img zameer@localhost:/tmp
time scp -P 6192 -i ~/.ssh/id_rsa /root/100MB.img zameer@localhost:/tmp
time scp -P 6192 -i ~/.ssh/id_rsa /root/1024MB.img zameer@localhost:/tmp
```
    

## The Follow up Report
The EC official benchmark test for File Transfer use cases.

### Spec

### Test script

### Benchmark result

## Reference
<sup>[1][AWS to Azure - File Transfer using EC (Internal)](https://github.build.ge.com/200020008/digitalconnect-Cloud-Automation/blob/master/cloud-ge-latency/GE%20Cloud%20Consolidated%20Latency%20Report.md) Originated by Zameer Ahmed</sup>
