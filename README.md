# **Multiplication_Game**
Replication of Multiplication game from https://www.mathsisfun.com/games/multiplication-game.html in MIPS Assembly
 

# Program Behavior:

  The program starts in Main.asm. After prompting the player if they want to start a game,
the program will ask the player to input two integers from 1-9. For the first time this happens, the
player can put any two numbers. But for anytime after, the player must change one of the
numbers and keep one of them the same. The program will not let you input numbers that do
not follow these rules, and will make you re-input if not followed.

  After the player’s turn ends, the computer gets to go. The computer has the same rules
as the player and will keep one number the same and one different. It is random which number
changes and the number it picks to set as the new number is also random. The numbers the
computer played are printed to the console for the player to see.

  After each respective turn, the new values are stored into memory and used to find the
location in the scoreboard to update, so the program knows who has played where (0 for no
one, 1 for the player, and 2 for the computer). The program finds where in the scoreboard to
update by going through each possible input and finding its same location on a second
gameboard that stores the numbers.

  When each turn ends, a segment of instructions checks the scoreboard for the win
condition (4 in a row). By finding the addresses to the current row and column of the last played
space, the program is able to index through the scoreboard and determine if the win conditions
are met. If they are, the game ends and the player is told who won, then the program will end.

  If no one is decided as a winner just yet, the program prints out the grid into the console
with the same numbers indicating who has played in what spaces, and it becomes the player’s
turn again.

 
# Challenges Faced, Solutions, and Techniques:

  One of the most difficult parts of this assignment was learning how to navigate and
create a 2D array without explicitly being given a way to do it. I decided to make a 1D array, but
simply make each row end after 6 integers to give the illusion of a 2D array. This made it
challenging to check if the win condition had been met in a column, but I realized that I could
just index the array by 6 integers at a time to immediately jump down a row and be in the same
column from wherever the program was indexed to at the time. After implementing this method,
all I had to do was track how many consecutive places either the player or computer had scored
on, resetting the count if the streak was broken.

  Another issue I had was with the input validation. Because there are no easy ways to
check if the inputs were in the range 1-9, I had to check if the inputs were <9 and >1 and then
used an and gate to determine if both requirements were met. Similar methods were put in
place to determine if one number had changed and the other hadn’t, but this time using an xor
gate.

  Determining the flow of the program also wasn’t easy. To maximize efficiency, I tried to
load things from memory the least number of times, making it difficult to keep track of what
action the program needed to perform next and what resources it needed. Using conditional
branches and jumps in conjunction with keeping necessary resources in registers made the
gameplay loop not too difficult to keep track of.
