- [address](#Taddress)
- [organisation](#Torganisation)
- [person](#Tperson)
- [position](#Tposition)

## address {#Taddress}

|{: .def}||
|-|-|
|Kenmerken|[city](#T), [house number](#T), [street name](#T)|
|Relatie met|[lives at](#TlivingPlace)|

## organisation {#Torganisation}

|{: .def}||
|-|-|
|Kenmerken|[organisation's name](#T)|
|Relatie met|[Assignment in relatie met organisation](#Tdepartment), [employment](#Temployment), [head of](#TheadOf)|

## person {#Tperson}

|{: .def}||
|-|-|
|Kenmerken|[person's name](#T)|
|Rollen|[employment](#Temployment), [head of](#TheadOf), [lives at](#TlivingPlace)|
|Relatie met|[Assignment in relatie met person](#Tassignee)|

## position {#Tposition}

|{: .def}||
|-|-|
|Kenmerken|[position id](#T)|
|Relatie met|[Assignment in relatie met position](#Tposition)|

### Assignment {#Tassignment}

|{: .def}||
|-|-|
|Toelichting|[Assignee]() is assigned [Position](#Tposition) in [Department]()|
|Rollen|[Assignment in relatie met organisation](#Tdepartment), [Assignment in relatie met person](#Tassignee), [Assignment in relatie met position](#Tposition)|

### Assignment in relatie met organisation {#Tdepartment}

|{: .def}||
|-|-|
|Rol van|0..* [Assignment](#Tassignment)|
|Met|1..1 [organisation](#Torganisation)|

### Assignment in relatie met person {#Tassignee}

|{: .def}||
|-|-|
|Rol van|0..* [Assignment](#Tassignment)|
|Met|1..1 [person](#Tperson)|

### Assignment in relatie met position {#Tposition}

|{: .def}||
|-|-|
|Rol van|0..* [Assignment](#Tassignment)|
|Met|1..1 [position](#Tposition)|

### employment {#Temployment}

|{: .def}||
|-|-|
|Toelichting|[Person](#Tperson) works for [Organisation](#Torganisation);<br/>[Person](#Tperson) has employer [Organisation](#Torganisation)|
|Rol van|1..* [person](#Tperson)|
|Met|0..* [organisation](#Torganisation)|
|Constraints|Head must be employee of organisation|

### head of {#TheadOf}

|{: .def}||
|-|-|
|Toelichting|[Person](#Tperson) is head of [Organisation](#Torganisation)|
|Rol van|1..* [person](#Tperson)|
|Met|0..1 [organisation](#Torganisation)|
|Constraints|Head must be employee of organisation|

### lives at {#TlivingPlace}

|{: .def}||
|-|-|
|Toelichting|[Person](#Tperson) lives at [Address](#Taddress)|
|Rol van|0..1 [person](#Tperson)|
|Met|0..* [address](#Taddress)|

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

### position id {#Tposid}

|{: .def}||
|-|-|

### street name {#TstreetName}

|{: .def}||
|-|-|

