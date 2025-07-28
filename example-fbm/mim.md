- [address](#Taddress)
- [organisation](#Torganisation)
- [person](#Tperson)

## address {#Taddress}

|{: .def}||
|-|-|
|Kenmerken|[city](#T), [house number](#T), [street name](#T)|
|Relatie met|[lives at](#TlivingPlace)|

## organisation {#Torganisation}

|{: .def}||
|-|-|
|Kenmerken|[organisation's name](#T)|
|Relatie met|[employment](#Temployment)|

## person {#Tperson}

|{: .def}||
|-|-|
|Kenmerken|[person's name](#T)|
|Rollen|[employment](#Temployment), [lives at](#TlivingPlace)|

### lives at {#TlivingPlace}

|{: .def}||
|-|-|
|Rol van|0..1 [person](#Tperson)|
|Met|0..* [address](#Taddress)|

### employment {#Temployment}

|{: .def}||
|-|-|
|Rol van|1..* [person](#Tperson)|
|Met|0..* [organisation](#Torganisation)|

## Waardetypering en referentielijsten

### city {#Tcity}

|{: .def}||
|-|-|

### house number {#ThouseNumber}

|{: .def}||
|-|-|

### organisation's name {#Toname}

|{: .def}||
|-|-|

### person's name {#Tpname}

|{: .def}||
|-|-|

### street name {#TstreetName}

|{: .def}||
|-|-|

