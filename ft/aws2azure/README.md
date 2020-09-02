
# AWS to Azure - File Transfer using EC (Enterprise Connect)

# Table of Contents

- [The Original Report](#the-original-report)
  - [Testing Method](#testing-method)
  - [Consolidated Results](#consolidated-results)
  - [Observations](#observations)
  - [Action Items](#action-items)
- [The Follow up Report](#the-follow-up-report)
  - [Spec](#spec)
  - [Test script](#test-script)
  - [Benchmark result](#benchmark-result)
- [Reference](#reference)

## The Origin Report
see [reference[1]](#reference)

### Testing Method

### Consolidated Results

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">File Size</th>
<th scope="col" class="org-left">Time Taken #1</th>
<th scope="col" class="org-left">Time Taken #2</th>
<th scope="col" class="org-left">Time Taken #3</th>
<th scope="col" class="org-left">Time Taken #4</th>
<th scope="col" class="org-left">Time Taken #5</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">1 MB</td>
<td class="org-left">0m0.803s</td>
<td class="org-left">0m0.770s</td>
<td class="org-left">0m0.807s</td>
<td class="org-left">0m0.785s</td>
<td class="org-left">0m0.813</td>
</tr>


<tr>
<td class="org-left">10 MB</td>
<td class="org-left">0m1.245s</td>
<td class="org-left">0m1.226s</td>
<td class="org-left">0m1.188s</td>
<td class="org-left">0m1.221s</td>
<td class="org-left">0m1.196s</td>
</tr>


<tr>
<td class="org-left">100 MB</td>
<td class="org-left">0m6.532s</td>
<td class="org-left">0m6.202s</td>
<td class="org-left">0m6.335s</td>
<td class="org-left">0m5.930s</td>
<td class="org-left">0m5.903s</td>
</tr>


<tr>
<td class="org-left">1024 MB</td>
<td class="org-left">0m53.796s</td>
<td class="org-left">0m56.601s</td>
<td class="org-left">0m58.240s</td>
<td class="org-left">0m57.739s</td>
<td class="org-left">0m59.303</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>

<span class="underline">Consolidated Results</span>

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-right" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">File Size</th>
<th scope="col" class="org-right">Average Time (sec)</th>
<th scope="col" class="org-left">Throughput (MB per sec)</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">1 MB</td>
<td class="org-right">0.80</td>
<td class="org-left">&#xa0;</td>
</tr>


<tr>
<td class="org-left">10 MB</td>
<td class="org-right">1.22</td>
<td class="org-left">&#xa0;</td>
</tr>


<tr>
<td class="org-left">100 MB</td>
<td class="org-right">6.18</td>
<td class="org-left">&#xa0;</td>
</tr>


<tr>
<td class="org-left">1024 MB</td>
<td class="org-right">57.14</td>
<td class="org-left">&#xa0;</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-right">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>

### Observations

### Action Items

AWS : t2.large
Azure : Standard D2s v3 (2 vcpus, 8 GiB memory)

<span class="underline">Setup</span>

    dd if=/dev/urandom of=/root/1MB.img bs=1M count=1
    dd if=/dev/urandom of=/root/10MB.img bs=1M count=10
    dd if=/dev/urandom of=/root/100MB.img bs=1M count=100
    dd if=/dev/urandom of=/root/1024MB.img bs=1M count=1024

<span class="underline">Commands for file copy</span>

Following example pulls file from the other ec2 instance, make sure that prior to running below, generate the image creation fresh to discount file-cache effect.

    time scp -P 6192 -i ~/.ssh/id_rsa /root/1MB.img zameer@localhost:/tmp
    time scp -P 6192 -i ~/.ssh/id_rsa /root/10MB.img zameer@localhost:/tmp
    time scp -P 6192 -i ~/.ssh/id_rsa /root/100MB.img zameer@localhost:/tmp
    time scp -P 6192 -i ~/.ssh/id_rsa /root/1024MB.img zameer@localhost:/tmp

## The Follow up Report
The EC official benchmark test for File Transfer use cases between aws-azure.

### Spec

### Test script

### Benchmark result

## Reference
<sup>[1][AWS to Azure - File Transfer using EC (Internal)](https://github.build.ge.com/200020008/digitalconnect-Cloud-Automation/blob/master/cloud-ge-latency/GE%20Cloud%20Consolidated%20Latency%20Report.md) Originated by Zameer Ahmed</sup>
