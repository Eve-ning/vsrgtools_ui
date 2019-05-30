# VSRG Simulating

Creates various analyses on VSRG Charts.

# Structure

The chart is **parsed** from various formats to a `data.table`

The `data.table` is then used for various **analyses**.

## Parsers

`f.chart.parse` is the main wrapper function for all parsing formats

## Analysis Tools

`f.chart.sim`

Simulates chart via a **Spike** and **Decay** function

`f.diff.broadcast`

Finds differences between vertically-neighbouring objects

##  ![Documentation](src/documentation/documentation.md)