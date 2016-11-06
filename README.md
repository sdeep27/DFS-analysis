# DFS-analysis
Six useful R functions for deeper analysis of fantasy football. Tailored for DraftKings. <br />
<br />
2016week8.csv is the base csv file of raw fantasy football data from Week 8 downloaded from <a href = "http://rotoguru1.com/cgi-bin/fyday.pl?week=8&year=2016&game=dk&scsv=1" target="_blank">Rotoguru.</a> This is the example input file.  <br />

sundayonly("2016week8.csv", c("jac","ten","was","cin","min","chi"), 8) outputs "2016week8sun.csv" - Since most of the major tournaments use only the main slate of games, it is often useful to remove games not on that main slate for post hoc analysis.  <br />
 <br />
topscorers("2016week8sun.csv") outputs "Top Scorers 2016week8sun.csv" <br/>
<br />
createmaster() will combine all weekly stats files in folder into "Master Stats.csv"  <br />
team_opp_analysis("Master Stats.csv") outputs 64 individual team CSVs that break down opponent output and team output. Useful for finding teams to avoid playing against and running analysis on team weaknesses and strengths. There is example output for the New Orleans Saints <br />
<br />
matchup_holder("2016week8.csv") outputs "matchup 2016week8.csv" useful for game by game analysis. <br />
pos_examine("matchup 2016week8.csv", "QB") outputs "QB Points 2016week8.csv". Can run on any position. Game by Game analysis. Useful for comparing a positions points compared to total game points, team points, etc.  

 
