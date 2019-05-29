---
title: "documentation"
author: "eve-ning"
date: "5/10/2019"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(message = FALSE)
knitr::opts_chunk$set(warning = FALSE)
library(knitr)
library(magrittr)
```

# Introduction
Breaks down VSRG charts so that data analysis can be performed on it.

# Interface
Currently there are a few steps that are supported

## Chart Parser
This loads in a VSRG Chart format.

Formats supported:
- `.osu`

## Chart Simulator
There are two parts to the simulation. **Tracking** and **Mapping**

### Tracking
This tracks the chart with a **Decay** and **Spike** function.

This simulator will create separate **stress trackers** for each
key, during the simulation, if the tracker encounters an **object**,
it will trigger the **Spike** function. Otherwise, the tracker will
use the **Decay** function.

#### Functions
##### Spike
The function must follow the format of `spike(stress, args)`. Where
stress and args are the input, and output being the modified stress
value.

`args` can list a variable amount of arguments in a list. This will
be dependent on the mapping given by the user.

##### Decay
The function must follow the format of `decay(stress, duration)`.
Where stress and duration are the input, and output being the
modified stress value.

`duration` unit is milliseconds(ms).

#### Decay Updating
Decay will only commit to the tracker when encountering a note, so
functions that have side-effects when triggered multiple times will
not be affected.

#### Type-Specific Spike
The program recognises different types of objects encountered. The 
user can manually specify what arguments should certain objects be
related to.

The recognized type names are
- Note: `note`  
- Long Note Head: `lnoteh`
- Long Note Tail: `lnotel`

### Mapping
This is a user specified table on parameters **Tracking** will be
using.

The format that is required, `arg1` and `arg2` are optional.
|types |`<arg1>`|`<arg2>`|...|
|------|--------|--------|---|
|note  |`x`     |`a`     |...|
|lnoteh|`y`     |`b`     |...|
|lnotel|`z`     |`c`     |...|

Base R Code: `data.frame(types = c("note", "lnoteh", "lnotel"))`

#### Example
Consider that:

**Spike Function**:
```
spike <- function(stress, args) {
    return((stress + args$adds) * args$mults)
}
```
*Note how the arguments are accessed by a list.*

**Decay Function**:
```
decay <- function(stress, duration) {
    return(stress / (2 ** (duration)))
}
```

**Mapping Table**
|types |`adds`|`mults`|
|------|------|-------|
|note  |`15.0`|`1.1`  |
|lnoteh|`15.0`|`1.1`  |
|lnotel|`5.0` |`1.05` |

## Chart Difference Broadcaster
This finds the difference in offset between an **object** and
all of the **immediate following objects** on **all columns**.

### Example
In other words, in this example `[1][1234][4]`, where the notes
are spaced `100ms` apart.

There should be 8 differences calculated by the broadcaster.

*x->y represents from column x to y*
- 1st Offset: `1->1`, `1->2`, `1->3`, `1->4`
- 2nd Offset: `1->4`, `2->4`, `3->4`, `4->4`

This would give the output similar to this

|offsets|keys.froms|keys.tos|diffs|
|-|-|-|-|
|100|1|1|100|
|100|1|2|100|
|100|1|3|100|
|100|1|4|100|
|200|1|4|100|
|200|2|4|100|
|200|3|4|100|
|200|4|4|100|

### Ignoring Types
By default, the broadcaster will ignore `lnotel` during
calculation. Users can specify other types via the 
`ignore.types` argument.

## Move Mapping Creation
To expand upon the broadcasted data, a helper function for a
**Move Map** creation is used.

A **Move** means from **one object to another**.

The user can assign a **Move Value** to each **Move**.

### Assignment
Unlike a straightforward **inner join** operation, this creation
utilizes a secondary table in order to **realistically** 
represent finger movements.

There are 2 maps required in this operation:
- Move Mapping
- Move Keyset

#### Move Mapping
Move Keyset converts **column** *(numerics)* to **moves** (characters).

The **default** template maps looks like this.

**Mapping**

||P1|R1|M1|I1|T1|
|-|-|-|-|-|-|
|P1|**7.0**|`5.0`|`3.0`|`2.7`|`2.7`|
|R1|`6.0`|`6.0`|`2.5`|`2.0`|`2.0`|
|M1|`3.5`|`3.0`|`5.0`|`1.0`|`1.3`|
|I1|`2.7`|`1.2`|`1.2`|`5.0`|`2.4`|
|T1|`2.7`|`1.7`|`1.5`|`1.9`|`5.0`|

Looking at the *top-left* value, `7.0`, this mapping means that any 
pattern that uses **Pinky** to **Pinky**, the **Move Value** is `7.0`

The number after each initial indicates that this happens on the same
hand.

As you may expect, the initials are the finger names.

- **P**inky
- **R**ing
- **M**iddle
- **I**ndex
- **T**humb

**Mapping Opposite**

||P2|R2|M2|I2|T2|
|-|-|-|-|-|-| 
|P1|`1.9`|`1.8`|`1.7`|`1.6`|`1.5`|
|R1|`1.8`|`1.7`|`1.6`|`1.5`|`1.4`|
|M1|`1.7`|`1.6`|`1.5`|`1.4`|`1.3`|
|I1|`1.6`|`1.5`|`1.4`|`1.3`|`1.2`|
|T1|`1.5`|`1.4`|`1.3`|`1.2`|`1.1`|

This is for patterns that occur between hands.


## Chart Alpha
**alpha** is an template variable, it is dependent on how it
is calculated.

This is a basic calculation wrapper. It takes a **Move Mapping**
generated **move.value** parameter and the **diff** to calculate
**alpha**

