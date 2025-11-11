# Core dumps

This guide will help you retrive JunOS core-dump files from a network device as non-root user (e.g. claude).

1. First, do a `show system core-dumps` to see where the dumps are located.  It should produce something like this:

```
claude@pe4> show system core-dumps
-rw-------  1 root  root   1084563456 Oct 9  14:48 /var/crash/core-rpd.225.pe4.1760021290
/var/tmp/*core*: No such file or directory
/var/tmp/pics/*core*: No such file or directory
/var/crash/kernel.*: No such file or directory
/var/jails/rest-api/tmp/*core*: No such file or directory
/tftpboot/corefiles/*core*: No such file or directory
total files: 2
```

2. Check if any core dump file is found (e.g. `/var/crash/core-rpd.225.pe4.1760021290`)
3. Create a `tmp/` folder inside the `${WORKSPACE}`.

```bash
$ mkdir -p ~/workspace/uc3-ospf/tmp/
```

4. Using the Linux MCP server, copy via SCP the core dump file to the recently created folder (e.g. `${WORKSPACE}/tmp/`) using the `root` user and the SSH key (e.g. `/home/claude/.ssh/id_rsa_claude`).

```bash
$ cd ~/workspace/uc3-ospf/tmp/
$ scp -O -i /home/claude/.ssh/id_rsa_claude root@clab-uc3-ospf-pe4:/var/crash/core-rpd.225.pe4.1760021290 .
core-rpd.225.pe4.1760021290                                                     100% 1034MB 165.4MB/s   00:06
```

5. Analyze the core dump file by:
    - Checking the file type and basic properties (`size`, `format`, etc.)
    - Using the `file` command to identify the core dump characteristics
    - Using the `strings` command to extract readable text from the core dump

6. Extract critical crash information including:
    - The exact process that crashed (process name and PID)
    - The JunOS version and build information
    - The timestamp when the crash occurred
    - The error message or crash reason
    - Any abort mechanisms that were triggered

7. Search for network protocol information in the core dump, specifically:
    - OSPF protocol references
    - BGP protocol data
    - Any routing table or database information
    - System integration details (GRPC, kernel interfaces, IPC)

8. Perform root cause analysis by:
    - Identifying the primary error that caused the crash
    - Determining potential underlying causes
    - Assessing the impact on network operations

9. Correlate the findings with the broader Use Case #3 scenario about network health assessment following core dumps

10. Present the results in a structured format showing:
    - File details table
    - Critical crash information
    - Timeline reconstruction
    - Network context found in the dump
    - Root cause analysis
    - Validation of the use case scenario

Make sure to use appropriate Linux commands like `ls`, `file`, `strings`, and `grep` to thoroughly examine the core dump file. Focus on extracting actionable information that would be useful for network troubleshooting and post-incident analysis.
