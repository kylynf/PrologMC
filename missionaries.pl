% start([3,3,near]).
% goal([0,0,far]).

change(near,far).
change(far,near).

% boat must be in valid location
% valid number of missionaries and cannibals on each shore
% no more than three and no fewer than zero
valid([Missionaries,Cannibals,near]) :-
    Missionaries=<3,
    Cannibals=<3,
    Missionaries>=0,
    Cannibals>=0.

valid([Missionaries,Cannibals,far]) :-
    Missionaries=<3,
    Cannibals=<3,
    Missionaries>=0,
    Cannibals>=0.

% oneEq(X,X,_).
% oneEq(X,_,X).

% no missionaries are in danger of being eaten
safe([Missionaries,Cannibals,_]) :-
    % oneEq(3,3,_),oneEq(2,2,_),oneEq(1,1,_),oneEq(0,0,_),oneEq(0,1,_),oneEq(0,2,_),oneEq(0,3,_),oneEq(3,0,_),oneEq(3,1,_),oneEq(3,2,_).
    % (Missionaries=<Cannibals ; Cannibals=0),
    (Missionaries>=Cannibals ; Missionaries=0),
    FarMis is 3 - Missionaries, FarCan is 3 - Cannibals,
    (FarMis >= FarCan; FarMis=0).

% onemissionary
move([M1,C1,B1],onemissionary,[M2,C2,B2]) :-
    change(B1, B2),
    C1 = C2,
    (B1=near -> DM is M1-1 ; DM is M1+1),
    M2 = DM.

%twomissionaries
move([Missionaries1,Cannibals1,Boat1],twomissionaries,[Missionaries2,Cannibals2,Boat2]) :-
    change(Boat1,Boat2),
    Cannibals1 = Cannibals2,
    (Boat1=near -> DummyMissionary is Missionaries1-2 ; DummyMissionary is Missionaries1+2),
    Missionaries2 = DummyMissionary.

%onecannibal
move([Missionaries1,Cannibals1,Boat1],onecannibal,[Missionaries2,Cannibals2,Boat2]) :-
    % boat1==near,boat2==far,Cannibals2 is Cannibals1 - 1;
    % boat1==far,boat2==near,Cannibals2 is Cannibals1 + 1.
    change(Boat1,Boat2),
    Missionaries1 = Missionaries2,
    (Boat1=near -> DummyCannibal is Cannibals1-1 ; DummyCannibal is Cannibals1+1),
    Cannibals2 = DummyCannibal.

%twocannibal
move([Missionaries1,Cannibals1,Boat1],twocannibals,[Missionaries2,Cannibals2,Boat2]) :-
    change(Boat1, Boat2),
    Missionaries1 = Missionaries2,
    (Boat1=near -> DummyCannibal is Cannibals1-2 ; DummyCannibal is Cannibals1+2),
    Cannibals2 = DummyCannibal.

% oneofeach
move([Missionaries1,Cannibals1,Boat1],oneofeach,[Missionaries2,Cannibals2,Boat2]) :-
    change(Boat1,Boat2),
    (Boat1=near -> DummyCannibal is Cannibals1-1, DummyMissionary is Missionaries1-1 ; DummyCannibal is Cannibals1+1, DummyMissionary is Missionaries1+1),
    Cannibals2 = DummyCannibal,
    Missionaries2 = DummyMissionary.

solution([0,0,far],[]).
solution(State,[Move|Rest]) :-
    move(State,Move,NextState),
    valid(NextState),
    safe(NextState),
    solution(NextState,Rest).