# Checking Repeatable Read Consistency for MariaDB / Galera Cluster 

The whole Galera Cluster environment is established on Emulab. I'll update the pure MariaDB version ASAP.

```
MariaDB version == 10.4.22
Galera Cluster version == 26.4.9
```

# Example Result
The given data in folder [output/0/](./output/0/) was generated by Galera engineer from a single MariaDB node, with Galera replication disabled, it violates `RR Property`. 

Parameters:
```
key_num = 20
client_num = 10
transactions_per_client = 100
operations_per_transaction = 25
```
# Running Steps

### 1. Run [setup_server_node.sh](./setup_server_node.sh) and [setup_client_node.sh](./setup_client_node.sh) to set up Galera on server and client nodes respectively.

For three server nodes, change the `cluster_name` and `server_ip` in the script. Then run
```
sh setup_server_node.sh <server_node_no>
```
For the client nodes, run
```
sh setup_client_node.sh <server_ip_address>
```
### 2. Run [init.sh](./init.sh) to initialize the Database in Galera Cluster.

Need to change the parameter `key` if you want to customize the key number.
```
python3 init.py <server_ip_address>
```
### 3. Run [galera.py](./galera.py) to generate transaction workloads. 

Please make sure the `server_id` are correct, and the `key_num` is same with settings in `init.py`. Then run
```
python3 galera.py -w <wo_rate> -r <ro_rate> -p <w_percent> -t <trans_num> -o <op_num> -c <client_num> -n <thread_no> -f <folder_num>
```
The collected traces will be stored in folder `output/folder_num/` where the trace for each client will be stored in a separate txt file; The default `folder_num` is 0.

To be noticed, all the read-write transactions generated by this script has been customized, that is, for each transaction, all the read operations will happen before write operations. This part can be modified in function `zipf_generator` and `uniform_generator`.

### 4. Run [group_data.py](./group_data.py) to normalize the collected data into one file result.txt.
```
python3 group_data.py -o <operation_num> -r <running_times>
```
The parameter `running_times` refers to run times `j` in [multi_threads.sh](./multi_threads.sh).

### 5. Run [check_rr.py](./check_rr.py) to check if the execution run violates Repeatable Read consistency.

The format of each operation is: `read/write(variable, value, client_id, transaction_id)`, denote as `r/w(var, val, cid, tid)`
* RR Property:

    For multiple Read operations in the same transaction, `r(var, val_1, cid, tid)` and `r(var, val_2, cid, tid)`, if there is no Write operation to `var` between them, then `val_1 = val_2`.
  
### (Optional) Run [multi_threads.sh](./multi_threads.sh) to automatically generate workloads.

Please change all the parameters regarding `ip_address`.



 
 
