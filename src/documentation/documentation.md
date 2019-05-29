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
all of the **immediate following objects** on **all columns**