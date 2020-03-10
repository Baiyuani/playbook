#!/bin/bash
etcdctl mk /atomic.io/network/config '{"Network": "10.254.0.0/16", "Backend": {"Type": "vxlan"}}'
