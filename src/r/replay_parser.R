f.replay.parse <- function(map, replay.path){
  #' Parses the replay generated through the Python API downloader.
  #' 
  #' @description Using proximity matching, data of the replay is
  #' joined with the map, so we can tell what notes are the replay
  #' related to.
  #' 
  #' @param map A **data.frame** that needs to have types, offsets,
  #' and keys
  #' @param replay.path **Path** of the replay generated.
  #' 
  #' @return Returns a joined **data.frame** with replay.offsets
  #' on the following column.
  
  require(dplyr)
  require(feather)
  
  f.similarity.match <- function(map, replay){
    #' Does a similarity match between map and replay
    "Map should only come in keys, we will need to 
    transform it into actions, which will help in
    pairing"
    map$actions <- map$keys
    map$actions[map$types == 'lnotel'] <- -map$actions[map$types == 'lnotel']
    map$replay.offsets <- NA
    actions.unq <- unique(map$actions)
    
    map.ac.split <- split(map, f=map$actions)
    replay.ac.split <- split(replay, f=replay$actions)
    
    map.ac.list <- c()
    for (i in actions.unq) {
      map.ac <- map.ac.split[[as.character(i)]]
      replay.ac <- replay.ac.split[[as.character(i)]]
      
      for (row in 1:nrow(map.ac)) {
        # From all offsets of the replay df, we will deduct a looped
        # map df offset
        # We will get the minimum (which is the closest match)
        # Then we throw it into df.joined
        replay.match <- replay.ac[which.min(abs(replay.ac$offsets -
                                                map.ac$offsets[row]))[1],]

        map.ac[row, 'replay.offsets'] <- replay.match$offsets
      }
      map.ac.list <- append(map.ac.list, list(map.ac))
    }
    return(bind_rows(map.ac.list))
  }
  
  replay <- read_feather(replay.path)
  map <- f.similarity.match(map, replay)
  return(map)
}
