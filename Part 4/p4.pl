assumptions(A)	:- findall(X,myAsm(X),A).
null_supports(N):- findall(X,myRule(X,[]),N).
rules(R)		:- findall((X,Y),myRule(X,Y),R).

add_assumptions([],A,A) :- !.
add_assumptions([H|T],A,All1) :-
    append(A,[(H,[H])],A1),
    add_assumptions(T,A1,All1).

add_nullsupports([],A,A) :- !.
add_nullsupports([H|T],A,All2) :-
    append(A,[(H,[])],A1),
    add_nullsupports(T,A1,All2).

notnullset(_,[],A,A) :- !.
notnullset(NS,[H|T],N,F) :-
	member(H,NS), !,
    notnullset(NS,T,N,F).
notnullset(NS,[H|T],N,F) :-
    append(N,[H],N1),
    notnullset(NS,T,N1,F).

add_other(2,[],A,A) :- !.
add_other(2,[(_,[])|T],A,AF) :- !,
    add_other(2,T,A,AF).
add_other(2,[(R,S)|T],A,AF) :-
    null_supports(NS),
    notnullset(NS,S,[],F),
    append(A,[(R,F)],A1),
    add_other(2,T,A1,AF).

add_other(1,A,AF) :-
    rules(R),
    add_other(2,R,A,AF).

all_arguments(All) :-
    assumptions(A),
    add_assumptions(A,[],All1),
    null_supports(N),
	add_nullsupports(N,All1,All2),
    add_other(1,All2,All).

%get_set(_,[],S,S) :- !.
%get_set(C,[(C,A)|T],S,SF) :- !,	%list of supports
%    append(S,[(C,A)],S1),
%    get_set(C,T,S1,SF).
%get_set(A,[(C,A)|T],S,SF) :- !, %list of claims
%    append(S,[(C,A)],S1),
%    get_set(A,T,S1,SF).
%get_set(C,[_|T],S,SF) :-
%    get_set(C,T,S,SF).

%get_all(C,Set) :-
%    all_arguments(All),
%    get_set(C,All,[],Set).

argument((C,X)) :-
    all_arguments(All),
    member((C,X),All).

%Test_1
myAsm(a).
myAsm(b).
contrary(a,p).
myRule(p,[b]).
myRule(p,[]).

%Test_2
%myAsm(a).
%myAsm(b).
%myAsm(c).
%contrary(a,r).
%contrary(b,s).
%contrary(c,t).
%myRule(p,[q,a]).
%myRule(q,[]).
%myRule(r,[b,c]).