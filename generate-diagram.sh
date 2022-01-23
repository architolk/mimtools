#!/bin/bash
cd metamodel
curl -X PUT -T mim.ttl http://localhost:8080/data2model/container/model
curl -X PUT -T mim-shapes.ttl http://localhost:8080/data2model/container/addmodel
