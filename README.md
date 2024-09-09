# dd-trace-7580
A reproduction of DataDog/dd-trace-java#7580

### Setup
You should be able to run `./setup.sh` to build the images with the datadog agent we're using.
The only difference between `dd-trace-7580:with-dd` and `dd-trace-7580:without-dd` is the presence of the datadog agent.

### Run
You can run with `./run.sh witth-dd` or `./run.sh without-dd` to display how many classes were shared using the archive.

### Results
Without datadog agent:
```bash 
./run.sh without-dd
Started CdsDatadogReproApplication in 0.617 seconds (process running for 0.808)
Total classes loaded: 6442
Shared classes loaded: 6058
Percentage of shared classes: 94.00%
```
With datadog agent:
```bash
Started CdsDatadogReproApplication in 1.129 seconds (process running for 2.079)
Total classes loaded: 9902
Shared classes loaded: 2143
Percentage of shared classes: 21.00%
```