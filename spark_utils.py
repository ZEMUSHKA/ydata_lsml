#!/usr/bin/env python
# -*- coding: utf-8 -*-
import subprocess
import json
import re


def get_dns_name():
    return json.loads(subprocess.check_output(
        "aws ec2 describe-instances --instance-ids $(ec2-metadata -i | cut -d' ' -f2) --query 'Reservations[].Instances[].PublicDnsName'",
        shell=True
    ))[0]


def get_app_id():
    return re.search(".*(application[_0-9]+).*", str(subprocess.check_output('yarn application -list', shell=True))).groups()[0]


def print_ui_links():
    dns_name = get_dns_name()
    app_id = get_app_id()
    print("NameNode: http://{}:50070".format(dns_name))
    print("YARN: http://{}:8088".format(dns_name))
    print("Spark UI: http://{}:20888/proxy/{}".format(dns_name, app_id))
