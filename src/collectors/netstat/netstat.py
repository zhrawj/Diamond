# coding=utf-8

import diamond.collector
import commands


class NetstatCollector(diamond.collector.Collector):

    def get_default_config(self):
        config = super(NetstatCollector, self).get_default_config()
        config.update({
            'path':             'netstat',
        })
        return config

    def collect(self):
        metrics = {}
        a,b = commands.getstatusoutput("ss  -atr|awk '{++S[$1]} END {for(a in S) print a,S[a]}'")
        for x in b.split('\n'):
            metrics.update({ x.split(' ')[0]: x.split(' ')[1] })
              
        for metric_name in metrics.keys():
            if metric_name == "State":
                continue
            else:
                self.publish_gauge(metric_name.lower(), metrics[metric_name], 0)
