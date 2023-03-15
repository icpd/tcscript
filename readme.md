Implementing a bad network using "tc-netem" and "tc-filter"

## Usage

```bash
$ ./tc.sh
tc.sh [-h] [-i INTERFACE] [-a TARGET_IP] [-p TARGET_PORT] [-d DELAY] [-l LOSS] [-r] [-s]
       -h                  show help
       -i INTERFACE        interface (device), default eth0
       -a TARGET_IP        target ip, default 192.168.0.1
       -p TARGET_PORT      target port，default 5762
       -d DELAY            network delay，second:s millisecond:ms microsecond:us or unitless digit，default 300ms
       -l LOSS             loss packets rate，default 5%
       -r                  remove all rule
       -s                  show all rule
```

## Other

1. Change packet loss rate to 65%.  
`sudo tc qdisc change dev eth0 parent 1:1 handle 10: netem loss 65%`
