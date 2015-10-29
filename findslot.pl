%% Facts
constraints(alice_tt,[a,n,a,n,n,a,a,a,a,a,a,n,n,n]).
constraints(bob_tt,[a,a,n,n,n,a,n,n,a,a,a,n,a,a]).
student_timetable(s12676,[n,n,n,n,n,n,n,n,n,n,n,n,n,n]).
student_timetable(s12466,[n,a,n,n,a,a,n,a,n,a,n,n,a,a]).

%% Generate a timeslot without a for a time confilct.
generate_all_n(R,L,R):-length(R,Len),Len=:=L, !.
generate_all_n(Acc,L,R):-length(Acc,Len), Len<L, generate_all_n([n|Acc], L, R).

%% Count the number of a in a particular timeslot.
count(_, [], 0) :- !.
count(X, [X|T], N) :- count(X, T, N2), N is N2 + 1.     
count(X, [Y|T], N) :- X\=Y, count(X, T, N).

%% Replace nth element in a list with a given element.
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

%% Find if there is a overlap between two given student timeslot.
find_student_overlap([],[]):-fail,!.
find_student_overlap([H1|T1],[H2|T2]):-is_equal(H1,H2,a), !; find_student_overlap(T1,T2).

%% Check if a given timeslot is good for all students.
if_fit_student([],_):-true,!.
if_fit_student([H|T],S):-student_timetable(H,H1), find_student_overlap(H1,S), if_fit_student(T,S).

%% Modify one a to n and check if it is still good for all students, else not modify.
modify(S,T,Ini,F):-(if_fit_student(S,T)->replace(T, Ini, n, F); replace(T, Ini, a, F)).

%% For a Tutors overlap timeslot, make the number of a as less as possible.
loop_entry(T,_S,Ini,Floor,F):-Ini=Floor, F=T, !.
loop_entry(T,S,Ini,Floor,F):-replace(T,Ini,n,Tt), modify(S,Tt,Ini,Ttt), NewIni is Ini-1, loop_entry(Ttt,S,NewIni,Floor,F).

%% Reverse a list.
reverse([],Z,Z).
reverse([H|T],Z,Acc):-reverse(T,Z,[H|Acc]).

%% Check if all given variables are equal.
is_equal(Var,Var,Var).

%% Find the overlap timeslot of two tutors.
find_2ts_overlap([],[],R,R).
find_2ts_overlap([H1|T1],[H2|T2],Acc,R):-is_equal(H1,H2,a)->find_2ts_overlap(T1,T2,[a|Acc],R); find_2ts_overlap(T1,T2,[n|Acc],R).

find_overlap(R,[],R).
find_overlap(X,Y,Z):-find_2ts_overlap(X,Y,[],R), reverse(R,Z,[]).

get_adjtt_overlap(H,Y,R):-constraints(H,H1), find_overlap(H1,Y,R).

%% Find a overlap timeslot for all tutors in the knowledge base.
find_tt_overlap([],R,R).
find_tt_overlap([H|T],Acc,R):-get_adjtt_overlap(H,Acc,Ac), find_tt_overlap(T,Ac,R).


find_time_slots(T,S,Num,Tuto):-find_tt_overlap(T,[],Tt), if_fit_student(S,Tt)->length(Tt, Ini), loop_entry(Tt,S,Ini,-1,Tuto), count(a,Tuto,Num); 
	Num is 0, find_tt_overlap(T,[],Tt), length(Tt,Ini), generate_all_n([], Ini,Tuto).
