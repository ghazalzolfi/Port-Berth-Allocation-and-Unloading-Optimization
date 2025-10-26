* =============================
* SET DEFINITIONS
* =============================
Set
    i  "Ships (indexed from 1 to 8)"              /1*8/,
    j  "Berths (indexed from 1 to 4)"             /1*4/,
    r  "Cost ranges for piecewise waiting cost"   /1*3/;
Alias (i,k);


* =============================
* PARAMETERS FOR SHIPS
* =============================    
Parameter A(i) "Arrival time of ship i";
A('1') = 4.765526987;
A('2') = 1.004592503;
A('3') = 3.65299865;
A('4') = 6.054178125;
A('5') = 1.86918948;
A('6') = 2.117990219;
A('7') = 4.622951825;
A('8') = 6.601178383;

Parameter Q(i) "Container load (quantity) of ship i";
Q('1') = 6;
Q('2') = 18;
Q('3') = 20;
Q('4') = 5;
Q('5') = 11;
Q('6') = 19;
Q('7') = 20;
Q('8') = 13;

Parameter L(i) "Length of ship i";
L('1') = 114;
L('2') = 126;
L('3') = 115;
L('4') = 102;
L('5') = 102;
L('6') = 131;
L('7') = 119;
L('8') = 138;

Parameter P(i) "Priority of ship i (between 0 and 1)";
P('1') = 0.963796539;
P('2') = 0.773138121;
P('3') = 0.441550822;
P('4') = 0.981939255;
P('5') = 0.190926112;
P('6') = 0.348681095;
P('7') = 0.970486629;
P('8') = 0.445607269;


* =============================
* PARAMETERS FOR BERTHS
* =============================
Parameter D(j) "Base capacity of berth j";
D('1') = 57;
D('2') = 40;
D('3') = 52;
D('4') = 30;

Parameter D_bar(j) "Maximum extra capacity allowed at berth j";
D_bar('1') = 29;
D_bar('2') = 15;
D_bar('3') = 49;
D_bar('4') = 17;

Parameter h(j) "Cost of using extra capacity at berth j";
h('1') = 5.87153989;
h('2') = 5.880447197;
h('3') = 8.864246732;
h('4') = 6.640319654;

Parameter maxl(j) "Maximum allowed ship length at berth j";
maxl('1') = 118;
maxl('2') = 236;
maxl('3') = 120;
maxl('4') = 138;

Parameter delta(j) "Setup time between two ships at berth j";
delta('1') = 6.922094322;
delta('2') = 9.72782535;
delta('3') = 9.564812914;
delta('4') = 5.748308268;


* =============================
* SERVICE TIME MATRIX (i,j)
* =============================
Parameter T(i,j) "Unloading time of ship i at berth j";
T('1', '1') = 9.306945068;
T('1', '2') = 8.320459113;
T('1', '3') = 9.041338719;
T('1', '4') = 8.655545623;
T('2', '1') = 8.499993353;
T('2', '2') = 9.905633818;
T('2', '3') = 9.993113985;
T('2', '4') = 8.089112765;
T('3', '1') = 9.720322075;
T('3', '2') = 9.206381222;
T('3', '3') = 8.763211972;
T('3', '4') = 8.567236436;
T('4', '1') = 9.349929694;
T('4', '2') = 8.913662302;
T('4', '3') = 9.371722971;
T('4', '4') = 9.32369264;
T('5', '1') = 8.265956289;
T('5', '2') = 9.535675628;
T('5', '3') = 9.964826498;
T('5', '4') = 9.938776321;
T('6', '1') = 9.226653641;
T('6', '2') = 8.088521266;
T('6', '3') = 8.008110288;
T('6', '4') = 8.267945054;
T('7', '1') = 9.882004543;
T('7', '2') = 8.605721124;
T('7', '3') = 8.732291203;
T('7', '4') = 9.796392489;
T('8', '1') = 8.62872761;
T('8', '2') = 9.097964368;
T('8', '3') = 8.872061915;
T('8', '4') = 8.129988352;


* =============================
* ADDITIONAL DERIVED PARAMETERS
* =============================
Scalar Wmax_factor /80/;

Parameter Wmax(i) "Max waiting time for ship i";
Wmax(i) = Wmax_factor * (1 - P(i));

Parameter M       "A large constant for constraints"       /10000/;

Parameter mat(i,k) "1 if ship i has higher or equal priority than k";
mat(i,k) = yes$(P(i) >= P(k));


* =============================
* VARIABLES
* =============================
Variable Z "Total cost to minimize";

Binary Variable
    x(i,j)           "1 if ship i is assigned to berth j"
    y(i,k,j)         "1 if ship i is before ship k at berth j"
    g(r,i)           "1 if bri is at max for r"
;

Positive Variable
    S(i)             "Start time of unloading for ship i"
    W(i)             "Waiting time for ship i"
    u(j)             "Extra used capacity at berth j"
    b(r,i)           "Waiting time in interval r for ship i"
    C(i)             "Waiting cost for ship i"
;


* =============================
* EQUATIONS
* =============================
Equations
    obj              "Objective function"
    assign(i)        "Each ship assigned to one berth"
    limitB(j)       "Max 2 ships at berth 1,2,4"
    fixB3            "Exactly 3 ships at berth 3"
    capConst(j)      "Load capacity constraint"
    extCapLimit(j)   "Limit on extra capacity"
    berthLength(i,j) "Ship fits in the berth"
    waitTimeEq(i)    "Start time relation"
    maxWait(i)       "Max waiting time"
    order1(i,k,j)    "Order constraint 1"
    order2(i,k,j)    "Order constraint 2"
    order3(i,k,j)    "Priority constraint"
    orderTime(i,k,j) "Time sequence"
    costEq(i)        "Cost equation"
    waitSum(i)       "Total wait time sum"
    interval1a(i)    "Interval 1 constraints"
    interval1b(i)    "Interval 1 constraints"
    interval2a(i)    "Interval 2 constraints"
    interval2b(i)    "Interval 2 constraints"
    interval3a(i)    "Interval 3 constraints"
    interval3b(i)    "Interval 3 constraints"
;

obj..                                Z =e= (5*sum((i,j), T(i,j)*x(i,j))) + sum(j, u(j)*h(j)) + sum(i, C(i));
assign(i)..                          sum(j, x(i,j)) =e= 1;
limitB(j)$(not sameas(j,'3'))..      sum(i, x(i,j)) =l= 2;
fixB3..                              sum(i, x(i,'3')) =e= 3;
capConst(j)..                        sum(i, x(i,j)*Q(i)) =l= D(j) + u(j);
extCapLimit(j)..                     u(j) =l= D_bar(j);
berthLength(i,j)..                   x(i,j)*L(i) =l= maxl(j);
waitTimeEq(i)..                      A(i) + W(i) =e= S(i);
maxWait(i)..                         W(i) =l= Wmax(i);
order1(i,k,j)$(not sameas(i,k))..    y(i,k,j) + y(k,i,j) =l= x(i,j) + x(k,j);
order2(i,k,j)$(not sameas(i,k))..    x(i,j) + x(k,j) - 1 =l= y(i,k,j) + y(k,i,j);
order3(i,k,j)$(not sameas(i,k))..    mat(i,k) + x(i,j) + x(k,j) - 2 =l= y(i,k,j);
orderTime(i,k,j)$(not sameas(i,k)).. S(i) + T(i,j) + delta(j) =l= S(k) + M*(1 - y(i,k,j));
costEq(i)..                          C(i) =e= 25*b('1',i) + 10*b('2',i) + 5*b('3',i);
waitSum(i)..                         W(i) =e= sum(r, b(r,i));
interval1a(i)..                      b('1',i) =g= 10 * g('1',i);
interval1b(i)..                      b('1',i) =l= 10;
interval2a(i)..                      30*g('2',i) =l= b('2',i);
interval2b(i)..                      b('2',i) =l= 30*g('1',i);
interval3a(i)..                      0 =l= b('3',i);
interval3b(i)..                      b('3',i) =l= 30*g('2',i);


model main /all/;
* Base Case Solution
solve main using MIP minimizing Z;
display x.l, Z.l;




* =====================================================================================
* Sensitivity Analysis: Part1 - delta('2') (setup time at berth 2) from 5 to 10 by 0.5
* =====================================================================================
Set
    scenarios1 /s1*s11/,      
    shipnames(i) /1*8/,         
    berthnames(j) /1*4/;        

Parameter
    delta2_scenario(scenarios1)      "delta(2) value in each scenario",
    z_result1(scenarios1)            "Objective value per scenario",
    ship_to_berth(scenarios1, i)     "Assigned berth number for ship i in each scenario";

* Assign delta('2') values: from 5.0 to 10.0 with step size 0.5
Scalar delta2_start /5.0/, delta2_step /0.5/;
Loop(scenarios1,
    delta2_scenario(scenarios1) = delta2_start + delta2_step * (ord(scenarios1) - 1);
);

* Run model for each scenario and collect results
Loop(scenarios1,
    delta('2') = delta2_scenario(scenarios1);
    Solve main using MIP minimizing Z;
    z_result1(scenarios1) = Z.l;
* Record ship-to-berth assignments
    Loop((i,j)$(x.l(i,j) > 0.5),
        ship_to_berth(scenarios1, i) = ord(j);  
    );
);

* Write results to CSV file
File result1 /SensitivityAnalysis-P1.csv/;
Put result1;
* --- HEADER ROW ---
Put "Scenario,delta2,Z";
Loop(i,
    Put ",Ship", i.tl:0;
);
Put /;
* --- DATA ROWS ---
Loop(scenarios1,
    Put scenarios1.tl:0, ",", delta2_scenario(scenarios1):0:2, ",", z_result1(scenarios1):0:2;
    Loop(i,
        Put ",";
        Loop(j$(ship_to_berth(scenarios1,i) = ord(j)),
            Put "B", j.tl:0;
        );
    );
    Put /;
);
PutClose result1;


* ===================================================================================================
* Sensitivity Analysis: Part2 - T('7','3') (unloading time of ship 7 at berth 3) from 5 to 15 by 0.5
* ===================================================================================================
Set
    scenarios2 /s1*s21/;

Parameter
    t_scenario(scenarios2)           "T(7,3) value in each scenario",
    z_result2(scenarios2)            "Objective value per scenario",
    ship_to_berth2(scenarios2, i)    "Assigned berth number for ship i in each scenario";

* Assign T(7,3) values: from 5.0 to 15.0 with step size 0.5
Scalar t_start /5.0/, t_step /0.5/;
Loop(scenarios2,
    t_scenario(scenarios2) = t_start + t_step * (ord(scenarios2) - 1);
);

* Run model for each scenario and store results
Loop(scenarios2,
    T('7','3') = t_scenario(scenarios2);
    Solve main using MIP minimizing Z;
    z_result2(scenarios2) = Z.l;
* Record ship-to-berth assignments
    Loop((i,j)$(x.l(i,j) > 0.5),
        ship_to_berth2(scenarios2, i) = ord(j);
    );
);

* Write results to CSV file
File result2 /SensitivityAnalysis-P2.csv/;
Put result2;
* --- HEADER ROW ---
Put "Scenario,T(7-3),Z";
Loop(i,
    Put ",Ship", i.tl:0;
);
Put /;
* --- DATA ROWS ---
Loop(scenarios2,
    Put scenarios2.tl:0, ",", t_scenario(scenarios2):0:2, ",", z_result2(scenarios2):0:2;
    Loop(i,
        Put ",";
        Loop(j$(ship_to_berth2(scenarios2,i) = ord(j)),
            Put "B", j.tl:0;
        );
    );
    Put /;
);
PutClose result2;


* =============================================================================
* Sensitivity Analysis: Part3 - D('2') (capacity of berth 2) from 5 to 40 by 1
* =============================================================================
Set
    scenarios3 /s1*s36/;

Parameter
    d2_scenario(scenarios3)          "D(2) value in each scenario",
    z_result3(scenarios3)            "Objective value per scenario",
    ship_to_berth3(scenarios3, i)    "Assigned berth number for ship i in each scenario";

* Assign D(2) values: from 5 to 40 with step size 1
Scalar d2_start /5/, d2_step /1/;
Loop(scenarios3,
    d2_scenario(scenarios3) = d2_start + d2_step * (ord(scenarios3) - 1);
);

* Run model for each scenario and record results
Loop(scenarios3,
    D('2') = d2_scenario(scenarios3);
    Solve main using MIP minimizing Z;
    z_result3(scenarios3) = Z.l;
* Record ship-to-berth assignments
    Loop((i,j)$(x.l(i,j) > 0.5),
        ship_to_berth3(scenarios3, i) = ord(j);
    );
);

* Write results to CSV file
File result3 /SensitivityAnalysis-P3.csv/;
Put result3;
* --- HEADER ROW ---
Put "Scenario,D(2),Z";
Loop(i,
    Put ",Ship", i.tl:0;
);
Put /;
* --- DATA ROWS ---
Loop(scenarios3,
    Put scenarios3.tl:0, ",", d2_scenario(scenarios3):0:0, ",", z_result3(scenarios3):0:2;
    Loop(i,
        Put ",";
        Loop(j$(ship_to_berth3(scenarios3,i) = ord(j)),
            Put "B", j.tl:0;
        );
    );
    Put /;
);
PutClose result3;


* =============================================================================
* Sensitivity Analysis: Part4 - D('3') (capacity of berth 3) from 5 to 40 by 1
* =============================================================================
Set
    scenarios4 /s1*s36/;

Parameter
    d3_scenario(scenarios4)          "D(3) value in each scenario",
    z_result4(scenarios4)            "Objective value per scenario",
    ship_to_berth4(scenarios4, i)    "Assigned berth number for ship i in each scenario";

* Assign D(3) values: from 5 to 40 with step size 1
Scalar d_start /5/, d_step /1/;
Loop(scenarios4,
    d3_scenario(scenarios4) = d_start + d_step * (ord(scenarios4) - 1);
);

* Run model for each scenario and collect results
Loop(scenarios4,
    D('3') = d3_scenario(scenarios4);
    Solve main using MIP minimizing Z;
    z_result4(scenarios4) = Z.l;
* Record ship-to-berth assignments
    Loop((i,j)$(x.l(i,j) > 0.5),
        ship_to_berth4(scenarios4, i) = ord(j);
    );
);

* Write results to CSV file
File result4 /SensitivityAnalysis-P4.csv/;
Put result4;
* --- HEADER ROW ---
Put "Scenario,D(3),Z";
Loop(i,
    Put ",Ship", i.tl:0;
);
Put /;
* --- DATA ROWS ---
Loop(scenarios4,
    Put scenarios4.tl:0, ",", d3_scenario(scenarios4):0:0, ",", z_result4(scenarios4):0:2;
    Loop(i,
        Put ",";
        Loop(j$(ship_to_berth4(scenarios4,i) = ord(j)),
            Put "B", j.tl:0;
        );
    );
    Put /;
);
PutClose result4;


* =================================================================================
* Sensitivity Analysis: Part5 - A('6') (arrival time of ship 6) from 1 to 5 by 0.1
* =================================================================================
Set
    scenarios5 /s1*s41/;

Parameter
    a6_scenario(scenarios5)          "A(6) value in each scenario",
    z_result5(scenarios5)            "Objective value per scenario",
    ship_to_berth5(scenarios5, i)    "Assigned berth number for ship i in each scenario";

* Assign A(6) values: from 1.0 to 5.0 with step size 0.1
Scalar a_start /1.0/, a_step /0.1/;
Loop(scenarios5,
    a6_scenario(scenarios5) = a_start + a_step * (ord(scenarios5) - 1);
);

* Run model for each scenario and store results
Loop(scenarios5,
    A('6') = a6_scenario(scenarios5);
    Solve main using MIP minimizing Z;
    z_result5(scenarios5) = Z.l;
* Record ship-to-berth assignments
    Loop((i,j)$(x.l(i,j) > 0.5),
        ship_to_berth5(scenarios5, i) = ord(j);
    );
);

* Write results to CSV file
File result5 /SensitivityAnalysis-P5.csv/;
Put result5;
* --- HEADER ROW ---
Put "Scenario,A(6),Z";
Loop(i,
    Put ",Ship", i.tl:0;
);
Put /;
* --- DATA ROWS ---
Loop(scenarios5,
    Put scenarios5.tl:0, ",", a6_scenario(scenarios5):0:2, ",", z_result5(scenarios5):0:2;
    Loop(i,
        Put ",";
        Loop(j$(ship_to_berth5(scenarios5,i) = ord(j)),
            Put "B", j.tl:0;
        );
    );
    Put /;
);
PutClose result5;
