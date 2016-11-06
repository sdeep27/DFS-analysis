library(dplyr)
library(stringr)

sundayonly <- function(vector_of_nonsunday_teams, csvfilename, week_no){
  theweeksgames <- read.csv(csvfilename, stringsAsFactors = F)
  badteams <- vector_of_nonsunday_teams
  badrows <- which(theweeksgames$Team %in% badteams)
  sundayonly <- theweeksgames[-badrows,]
  write.csv(sundayonly, paste("2016week",week_no,"sun.csv",sep=""), row.names = F)
}

#Examiner Function - Filters out Great performances for each week for us to see
topscorers <- function(csvfilename){
  #point hurdles
  rbhurdle <- 19
  wrhurdle <- 24
  tehurdle <- 17
  qbhurdle <- 24
  dhurdle <- 13
  weekscores <- read.csv(csvfilename, stringsAsFactors = F)
  rbhold <- filter(weekscores, Pos == "RB", DK.points >= rbhurdle)
  wrhold <- filter(weekscores, Pos == "WR", DK.points >= wrhurdle)
  tehold <- filter(weekscores, Pos == "TE", DK.points >= tehurdle)
  qbhold <- filter(weekscores, Pos == "QB", DK.points >= qbhurdle)
  dhold <- filter(weekscores, Pos == "Def", DK.points >= dhurdle)
  topscores <- rbind(rbhold,wrhold,tehold,qbhold,dhold)
  newfilename <- paste("Top Scorers", csvfilename)
  write.csv(topscores, newfilename, row.names = F)
}


#navigate to directory where weekly stats stored to combine into one master file; useful for next function
createmaster <- function(){
  nfldataframe <- do.call(rbind,lapply(dir(),read.csv))
  write.csv(nfldataframe, "Master Stats.csv")
}

#creates ind. csv for each teams fantasy scorers and also their opponent scores
team_opp_analysis <- function(masterstatscsv){
  current <- read.csv(masterstatscsv, stringsAsFactors = F)
  teams <- unique(current$Team)
  opponents <- unique(current$Oppt)
  i<-1
  while(i<=length(teams)){
    nowteam <-teams[i]
    team_df <- filter(current, Team==nowteam)
    team_df <- arrange(team_df, Week, -DK.points)
    write.csv(team_df, paste(nowteam,"Fantasy Output.csv"), row.names=F)
    i<-i+1
  }
  n<-1
  while(n<=length(opponents)){
    nowopp <-opponents[n]
    opp_df <- filter(current, Oppt==nowopp)
    opp_df <- arrange(opp_df, Week, -DK.points)
    write.csv(opp_df, paste(nowopp,"Opponent Output.csv"), row.names=F)
    n<-n+1
  }
}


#create matchup column, to better analyze cross team performanace 
matchup_holder <- function(csvfile){
  holdme <- read.csv(csvfile, stringsAsFactors = F)
  i<-1
  matchup<-c("","")
  while(i<=nrow(holdme)){
    rawmatchup <- c(holdme$Team[i],holdme$Oppt[i])
    rawmatchup <- sort(rawmatchup)
    rawmatchup <- paste(rawmatchup[1],"-",rawmatchup[2],sep="")
    matchup[i]<-rawmatchup
    i<-i+1
  }
  holdme$matchup <- matchup
  write.csv(holdme, paste("matchup", csvfile), row.names=F)
}

#examine each game of the week, and see total fantasy output per team compared to output at position; use matchup file for csvfile
pos_examine <- function(csvfile, Pos_title){
  weekfile <- read.csv(csvfile, stringsAsFactors = F)
  gamevector <- unique(weekfile$matchup)
  pos_vs_pts <- data.frame()
  for (i in gamevector){
    gamepts <- filter(weekfile, matchup == i)
    twoteams <- sort(unique(gamepts$Team))
    
    team1pts <- filter(gamepts, Team == twoteams[1])
    pos1pts <- filter(team1pts, Pos == Pos_title)
    team1totalpts <- sum(team1pts$DK.points)
    team1pospts <- sum(pos1pts$DK.points)
    
    team2pts <- filter(gamepts, Team == twoteams[2])
    pos2pts <- filter(team2pts, Pos == Pos_title)
    team2totalpts <- sum(team2pts$DK.points)
    team2pospts <- sum(pos2pts$DK.points)
    
    totalpts <- team1totalpts + team2totalpts
    totalpospts <- team1pospts + team2pospts
    
    ptdif <- team1totalpts - team2totalpts
    posptdif <- team1pospts - team2pospts
    
    pos_vs_pts <- rbind(pos_vs_pts, c(team1totalpts,team2totalpts,team1pospts,team2pospts, totalpts, totalpospts, ptdif, posptdif))
  }
  row.names(pos_vs_pts) <- gamevector
  names(pos_vs_pts) <- c("team_a_pts", "team_b_pts", paste(Pos_title,"_a_pts",sep=""), paste(Pos_title, "_b_pts",sep=""), "totalpts", paste("total_", Pos_title, "_pts",sep=""), "a_minus_b", paste(Pos_title, "a_minus_b", sep=""))
  write.csv(pos_vs_pts, paste(Pos_title, "Points", substring(csvfile, 9, nchar(csvfile))), row.names=T)
}




