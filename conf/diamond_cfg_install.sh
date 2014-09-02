#!/bin/bash
        
sudo rm -rf /etc/diamond/*.conf
sudo rm -rf /etc/diamond/handlers/GraphiteHandler.conf                            
cd /etc/diamond
ipaddr=`sudo ip a |grep "inet"|grep "eth0"|awk '{print $2}'|awk -F '/' '{print $1}'` 
        
cat<<EOF > handlers/GraphiteHandler.conf                
host = 
port = 2003
timeout = 15
batch = 1  
EOF
        
cat<<EEOF > diamond.conf
# Diamond Configuration File                      
[server]
handlers = diamond.handler.graphite.GraphiteHandler,      
user =  
group = 
pid_file = /var/run/diamond.pid                   
collectors_path = /usr/share/diamond/collectors   
collectors_config_path = /etc/diamond/collectors/ 
handlers_config_path = /etc/diamond/handlers/     
collectors_reload_interval = 3600                 
[handlers] 
keys = rotated_file
[[default]]
[collectors]
[[NetworkCollector]]                              
enabled = True
[[TCPCollector]]
enabled = True
[[default]]
hostname = $ipaddr
path_prefix = system
interval=30
splay=1 
method=threading
[loggers]  
keys = root
[formatters]
keys = default
[logger_root]
level = ERROR
handlers = rotated_file
[handler_rotated_file]
class = handlers.RotatingFileHandler
level = ERROR
formatter = default
args = ('/var/log/diamond/diamond.log', 'a', 104857600, 1)
[formatter_default]
format = [%(asctime)s] [%(threadName)s] %(message)s
datefmt =
EEOF
