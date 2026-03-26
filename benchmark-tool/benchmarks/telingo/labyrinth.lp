#program always.
neg_goal :- goal(X,Y), not reach(X,Y).

#program dynamic.
{ occurs(some_action) }.
rrpush   :- 'neg_goal, not ccpush, occurs(some_action).
ccpush   :- 'neg_goal, not rrpush, occurs(some_action).

orpush(X) :- _row(X), _row(XX), rpush(XX), X != XX.
ocpush(Y) :- _col(Y), _col(YY), cpush(YY), Y != YY.

rpush(X)  :- _row(X), rrpush, not orpush(X).
cpush(Y)  :- _col(Y), ccpush, not ocpush(Y).

push(X,e) :- rpush(X), not push(X,w).
push(X,w) :- rpush(X), not push(X,e).
push(Y,n) :- cpush(Y), not push(Y,s).
push(Y,s) :- cpush(Y), not push(Y,n).

shift(XX,YY,X,Y) :- _neighbor(e,XX,YY,X,Y), push(XX,e).
shift(XX,YY,X,Y) :- _neighbor(w,XX,YY,X,Y), push(XX,w).
shift(XX,YY,X,Y) :- _neighbor(n,XX,YY,X,Y), push(YY,n).
shift(XX,YY,X,Y) :- _neighbor(s,XX,YY,X,Y), push(YY,s).
shift( X, Y,X,Y) :- _field(X,Y), not push(X,e), not push(X,w), not push(Y,n), not push(Y,s).

conn(X,Y,D) :- 'conn(XX,YY,D), _dir(D), shift(XX,YY,X,Y).

goal(X,Y) :- 'goal(XX,YY), shift(XX,YY,X,Y).

reach(X,Y) :- 'reach(XX,YY), shift(XX,YY,X,Y).
reach(X,Y) :- reach(XX,YY), _dneighbor(D,XX,YY,X,Y), conn(XX,YY,D), conn(X,Y,E), _inverse(D,E).

#program final.
:- neg_goal.
