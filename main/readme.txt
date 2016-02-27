*** AUTHORS *** 
JAMES TAM

*** REFERENCED LIBRARIES / DATA *** 
- nba data: please contact me. I have included a few movement data to demonstrate. Because I have not included most of the data due to sheer file size, some games listed in the menu may not be responsive as its event folder is not present, so please click different games until one lists csvs.
- processing.org examples
- GUIDO library example list box menu (heavily modified to match design and functionality of project)
- svg file for the court dl'ed from http://savvastjortjoglou.com/nba-play-by-play-movements.html

*** SYSTEM DESCRIPTION / INSTRUCTIONS *** 
This infovis contains:

	a court view- Shows a populated basketball court(ball, 10 players). Click on toggle to view the path each player and ball takes throughout event. This is a very simplistic view that does not detract the user.

	side menu- Interact with menu to view different teams, players on a specific team, all players, and most importantly to select a specific game and event. The menu is scrollable, but mouse wheel scroll is kind of slow.

	game info- Home Team vs Visitor Team, who is currently in play according to event. Jersey nubmer and color let's you know which player is which on the court view.

	scrollbar- drag to control view. can scroll backwards and forwards. Currently the slider is mapped to the default loaded event. I've made many measures to make sure the ticks would reset and be a length according to the event's length, but without success. So in a different event, the slider may be dragged for longer than the event's length. Some events crash for an unknown reason.

The default loaded event has a problem where the ball "moves faster" than the players. This means that the ball is in the future relative to the players. This results in a floating ball in which players aren't interacting with. When I choose different events, the problem does not persist.