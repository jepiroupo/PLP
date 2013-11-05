% Autor:
% Data: 05/11/2013

/*

Prolog code developped for use in the lecture

'Programmierparadigmen (PGP)'
Sommer 2007

program taken from M.L.Scott: 'Programming Language Pragmatics', 2000

Ch. 11.3

adapted to SWI prolog; All rights reserved, copyright 2006, 2007 D. R?sner

*/

:- dynamic o/1.
:- dynamic x/1.

/* the various combinations of a successful horizontal, vertical
or diagonal line */

ordered_line(1,2,3).
ordered_line(4,5,6).
ordered_line(7,8,9).
ordered_line(1,4,7).
ordered_line(2,5,8).
ordered_line(3,6,9).
ordered_line(1,5,9).
ordered_line(3,5,7).

/*
we use the line predicate to complete lines (cf. below),
so the elements of an ordered_line may be completed in any order,
i.e. as permutations of (A,B,C)
*/

line(A,B,C) :- ordered_line(A,B,C).
line(A,B,C) :- ordered_line(A,C,B).
line(A,B,C) :- ordered_line(B,A,C).
line(A,B,C) :- ordered_line(B,C,A).
line(A,B,C) :- ordered_line(C,A,B).
line(A,B,C) :- ordered_line(C,B,A).

/* a move to choose, i.e. field to occupy, should be good
  according to some strategy and the field should be empty  */

move(A) :- good(A), empty(A).

/* a field is empty if it is not occupied by either party */

full(A) :- x(A).
full(A) :- o(A).

empty(A) :- not(full(A)).

%%% strategy

good(A) :- win(A).
good(A) :- block_win(A).
good(A) :- split(A).
good(A) :- block_split(A).
good(A) :- build(A).

%%% default case of picking the center, the corners and the sides
%%% in that order

good(5).
good(1). good(3). good(7). good(9).
good(2). good(4). good(6). good(8).

%%% we win by completing a line

win(A) :- x(B), x(C), line(A,B,C).

%%% we block the opponent to win by completing his possible line

block_win(A) :- o(B), o(C), line(A,B,C).

%%% a split creates a situation where opponent can not block a win in the next move

split(A) :- x(B), x(C), different(B,C), line(A,B,D), line(A,C,E), empty(D), empty(E).

same(A,A).
different(A,B) :- not(same(A,B)).

%%% block opponent from creating a split

block_split(A) :- o(B), o(C), different(B,C), line(A,B,D), line(A,C,E), empty(D), empty(E).

%%% simply pick a square that builds towards a line

build(A) :- x(B), line(A,B,C), empty(C).

%%%****************************************************************
%%% predicates to interactively run the game

%%% when is game definitely over?
all_full :- full(1),full(2),full(3),full(4),full(5),full(6),full(7),full(8),full(9).

%%% options for earlier success

done :- ordered_line(A,B,C), x(A), x(B), x(C), write('I won.'),nl.

done :- ordered_line(A,B,C), o(A), o(B), o(C), write('You won.'),nl.

done :- all_full, write('Draw.'), nl.

%%% interaction

getmove :- repeat, write('Please enter a move: '),read(X), between(1,9,X), empty(X), assert(o(X)).

%%% the computer's moves

makemove :- move(X),!, assert(x(X)).
makemove :- all_full.

%%% printing the board

printsquare(N) :- o(N), write(' o ').
printsquare(N) :- x(N), write(' x ').
printsquare(N) :- empty(N), write('   ').

printboard :- printsquare(1),printsquare(2),printsquare(3),nl,
              printsquare(4),printsquare(5),printsquare(6),nl,
              printsquare(7),printsquare(8),printsquare(9),nl.

%%% clearing the board

clear :- x(A), retract(x(A)), fail.
clear :- o(A), retract(o(A)), fail.

%%% main goal that drives everything:

play :- not(clear), repeat, getmove, makemove, printboard, done.