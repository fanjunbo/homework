%% This program has passed the automatic online judgement of this courses with a 
%%	total amount of 10 testing cases.

%% Generate a timeslot without a for a time confilct.
generate_all_n(R,L,R):-length(R,Len),Len=:=L, !.
generate_all_n(Acc,L,R):-length(Acc,Len), Len<L, generate_all_n([n|Acc],L,R).

%% Count the number of a in a particular timeslot.
count(_,[],0) :- !.
count(X,[X|T],N) :- count(X, T, N2), N is N2 + 1.     
count(X,[Y|T],N) :- X\=Y, count(X,T,N).

%% Reverse a list.
reverse([],Z,Z).
reverse([H|T],Z,Acc):-reverse(T,Z,[H|Acc]).

%% Find if there is a overlap between two given student timeslot.
find_student_overlap([],[]):-fail,!.
find_student_overlap([H1|T1],[H2|T2]):-are_three_equal(H1,H2,a), !; find_student_overlap(T1,T2).

%% Check if a given timeslot is good for all students.
if_fit_student([],_):-true,!.
if_fit_student([H|T],S):-student_timetable(H,H1), find_student_overlap(H1,S), if_fit_student(T,S).

%% For a Tutors overlap timeslot, make the number of a as less as possible.
are_two_equal(Var, Var).
full_all_with_n(R,L,R):-length(R,L1),L1=:=L,!.
full_all_with_n(S,L,R):-length(S,L1), L1<L, full_all_with_n([n|S],L,R).

%% Generate all subset of a overlap tutor timeslot.
get_all_tt_timeslot_subset(_,Src,Tar,L,F,R2):-Src=:=Tar, full_all_with_n(F,L,R1), reverse(R1,R2),!.
get_all_tt_timeslot_subset([H|T],Src,Tar,L,R,Sub):-are_two_equal(H,a), get_all_tt_timeslot_subset(T,Src+1,Tar,L,[a|R],Sub).
get_all_tt_timeslot_subset([_|T],Src,Tar,L,R,Sub):-get_all_tt_timeslot_subset(T,Src,Tar,L,[n|R],Sub).

%% Generating all possible subset from least to most number of a and test one by one.
loop_entry(Tt,S,Num,Tuto):-length(Tt,Len), get_all_tt_timeslot_subset(Tt,0,Num,Len,[],Tuto), if_fit_student(S,Tuto),!;loop_entry(Tt,S,Num+1,Tuto).


%% Check if all given variables are equal.
are_three_equal(Var,Var,Var).

%% Find the overlap timeslot of two tutors.
find_2ts_overlap([],[],R,R).
find_2ts_overlap([H1|T1],[H2|T2],Acc,R):-are_three_equal(H1,H2,a)->find_2ts_overlap(T1,T2,[a|Acc],R); find_2ts_overlap(T1,T2,[n|Acc],R).

find_overlap(R,[],R).
find_overlap(X,Y,Z):-find_2ts_overlap(X,Y,[],R), reverse(R,Z,[]).

% Find the overlap timeslot for two adjacent tutor.
get_adjtt_overlap(H,Y,R):-constraints(H,H1), find_overlap(H1,Y,R).

%% Find a overlap timeslot for all tutors in the knowledge base.
find_tt_overlap([],R,R).
find_tt_overlap([H|T],Acc,R):-get_adjtt_overlap(H,Acc,Ac), find_tt_overlap(T,Ac,R).

find_time_slots(T,S,Num,Tuto):-find_tt_overlap(T,[],Tt), if_fit_student(S,Tt)->loop_entry(Tt,S,1,Tuto), count(a,Tuto,Num); 
	Num is 0, find_tt_overlap(T,[],Tt), length(Tt,Ini), generate_all_n([], Ini,Tuto).
