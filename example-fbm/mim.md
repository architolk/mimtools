- [address](#-address)
- [organisation](#-organisation)
- [person](#-person)

## address {#-address}

|{: .def}||
|-|-|
|Kenmerken|[city](#-), [house number](#-), [street name](#-)|
|Relatie met|[lives at](#-living-lace)|

## organisation {#-organisation}

|{: .def}||
|-|-|
|Kenmerken|[organisation's name](#-)|
|Relatie met|[employment](#-employment)|

## person {#-person}

|{: .def}||
|-|-|
|Kenmerken|[person's name](#-)|
|Rollen|[employment](#-employment), [lives at](#-living-lace)|

### lives at {#-living-lace}

|{: .def}||
|-|-|
|Rol van|0..1 [person](#-person)|
|Met|0..* [address](#-address)|

### employment {#-employment}

|{: .def}||
|-|-|
|Rol van|1..* [person](#-person)|
|Met|0..* [organisation](#-organisation)|

## Waardetypering en referentielijsten

### city {#-city}

|{: .def}||
|-|-|

### house number {#-house-umber}

|{: .def}||
|-|-|

### organisation's name {#-oname}

|{: .def}||
|-|-|

### person's name {#-pname}

|{: .def}||
|-|-|

### street name {#-street-ame}

|{: .def}||
|-|-|

