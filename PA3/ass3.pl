/* HSU, Chia hong; chsuae@connect.ust.hk; 20562937 */

/* Q1 */

/* code */

sum_lst(0,[]).
sum_lst(Sum,[Head|Lst]) :- sum_lst(Rest,Lst), Sum is Rest+Head.

sum_of_Xs(Sum) :- xs(X), sum_lst(Sum,X).
sum_of_Ys(Sum) :- ys(Y), sum_lst(Sum,Y).

mean_of_Xs(Mean) :- sum_of_Xs(Sum), xs(X), length(X,L), Mean is Sum/L.
mean_of_Ys(Mean) :- sum_of_Ys(Sum), ys(Y), length(Y,L), Mean is Sum/L.

diff_lst([],_,[]).
diff_lst([Head|Lst], Diff, [Diff_H|Diff_lst]) :- diff_lst(Lst, Diff, Diff_lst), Diff_H is Head-Diff.

meandiff_lst_X(L) :- xs(X), mean_of_Xs(Mean), diff_lst(X,Mean,L).
meandiff_lst_Y(L) :- ys(Y), mean_of_Ys(Mean), diff_lst(Y,Mean,L).

mul_lst([],[],[]).
mul_lst([Hcand|Mcand_lst], [Hplier|Mplier_lst], [HProd|Prod_lst]) :- mul_lst(Mcand_lst,Mplier_lst,Prod_lst), HProd is Hcand*Hplier.

s_xy(Sum_XYs) :- meandiff_lst_X(LX), meandiff_lst_Y(LY), mul_lst(LX,LY,Prod), sum_lst(Sum_XYs, Prod).

s_xx(Sum_XXs) :- meandiff_lst_X(LX), mul_lst(LX,LX,Prod), sum_lst(Sum_XXs, Prod).

estimate_a(A) :- s_xx(SXX), s_xy(SXY), A is SXY/SXX.
estimate_b(B) :- estimate_a(A), mean_of_Ys(MY), mean_of_Xs(MX), B is MY - A*MX.

linear_regression(A, B) :- estimate_a(A), estimate_b(B).

/* Q2 */

/* Notes:
1. count all neighbor vertices w.r.t. each vertex, i.e.,
edge('A','B').
edge('A','C').
edge('G','A').
all_neibrs(X,Y).
    X='A'
    Y='B';
    X='A'
    Y='C';
    X='G'
    Y='A';
    X='B'
    Y='A';
    X='C'
    Y='A';
    X='A'
    Y='G';
all_neibrs('A',Nb).
    Nb='B';
    Nb='C';
    Nb='G'.
2. degree('A',D) :- list_neibrs('A',Bag), length(Bag,D),
    -> Bag = list of neighbors of 'A'
    -> D calculates the length of list
3. result(X)
    -> go through all vertex
    -> find those having degree=2
    -> find those whose neighbors are dense
    -> all_neibrs is called, have to deal with duplicates, possible alternative is to create all_vertices(X) that finds all distinct vertices in the graph
4. list_neibrs(V,Bag) :- findall(Nb,all_neibrs(V,Nb),Bag).
    -> Bag stores list of distince neighbors
    -> findall/3: https://www.swi-prolog.org/pldoc/man?predicate=findall/3
*/

/* code */
all_neibrs(V,Nb) :- edge(V,Nb).
all_neibrs(V,Nb) :- edge(Nb,V).

list_neibrs(V,Bag) :- findall(Nb,all_neibrs(V,Nb),Bag).

degree(V,D) :- list_neibrs(V,Bag), length(Bag,D).

check_dense([]).
check_dense([Head|List]) :- degree(Head,D), D>2, check_dense(List).

neibrs_dense(V) :- list_neibrs(V,List), check_dense(List).

result(X) :- all_neibrs(X,_), degree(X,D), D is 2, neibrs_dense(X).

remove_dup(Dup_lst, Result) :- sort(Dup_lst, Result).

result_in_lst(X,Result) :- findall(X,result(X),Dup_lst), remove_dup(Dup_lst,Result).

interesting(X) :- result_in_lst(_,Result), member(X,Result).

/* Q3 */

/* code */

is_hydrogen(Type,Is) :- Type=hydrogen, Is = 1.
is_hydrogen(Type,Is) :- not(Type=hydrogen), Is = 0.

count_h([],0).
count_h([Head|Lst],Count) :- atom_elements(Head,Type,_), is_hydrogen(Type,Is),count_h(Lst,Rest),Count is Rest+Is.

find_ch3(X) :- atom_elements(X,carbon,L), count_h(L,Count), Count = 3.
ch3(Bag) :- findall(X,find_ch3(X),Bag).

/* Q4 */

/* Notes:
1. do dfs on all carbon atoms.
2. sort/2 to (a)sort list and (b)sort bag to eliminate duplicate lists.
*/

/* code */

copy_list([],[]).
copy_list([H|In_tail],[H|Out_tail]) :- copy_list(In_tail,Out_tail).

find_tail_element([Z],Z).
find_tail_element([_|Tail],Z) :- find_tail_element(Tail,Z).

dfs(Curr,Visited,Found) :- member(Curr,Visited), !, find_tail_element(Visited,Last), Last=Curr, length(Visited,L), L=6, copy_list(Visited, Found).
dfs(Curr,Visited,Found) :- atom_elements(Curr,carbon,Neibr_lst), member(Next,Neibr_lst), dfs(Next,[Curr|Visited], Found).

cycle(Start,Found) :- dfs(Start,[],Found).

find_all_cycle(Found) :- atom_elements(Carbons, carbon, _), cycle(Carbons, Cycles), sort(Cycles,Found).

find_all_cycle_in_bag(Bag) :- findall(X,find_all_cycle(X),Bag).
c6ring(X) :- find_all_cycle_in_bag(Bag), sort(Bag,X).

/* Q5 */

/* Notes:
1. find cycles of Cs, benzene structures
2. check each result in the benzene list whether it has NO2 on non-adjacent carbons
3. msort/2 does not delete duplicates.
*/

/* code */

check_atom_types([],Type_lst) :- msort(Type_lst, Sort_type_lst), copy_list(Sort_type_lst,[carbon, oxygen, oxygen]).
check_atom_types([Head|Atom_lst],Type_lst) :- atom_elements(Head, Type, _), check_atom_types(Atom_lst,[Type|Type_lst]).

check_no2(N_lst) :- check_atom_types(N_lst,[]).

check_n(C_lst) :- member(N,C_lst), atom_elements(N,nitrogen,N_lst), check_no2(N_lst).

case1([],Output,Return):-copy_list(Output,Return).
case1([Head1, Head2|Lst],Output,Return) :- atom_elements(Head1,_,C_lst), check_n(C_lst),
    member(N,C_lst),
    atom_elements(N,nitrogen,N_lst),
    msort([N|N_lst], Sorted_cno2),
    case1(Lst,[Head2, Sorted_cno2 | Output],Return).

case2([],Output,Return):-copy_list(Output,Return).
case2([Head1, Head2|Lst],Output,Return) :- atom_elements(Head2,_,C_lst), check_n(C_lst),
    member(N,C_lst),
    atom_elements(N,nitrogen,N_lst),
    msort([N|N_lst], Sorted_cno2),
    case2(Lst,[Sorted_cno2, Head1 | Output],Return).

benzene_is_tnt(Benzene,Output,Return) :- case1(Benzene,Output,Return).
benzene_is_tnt(Benzene,Output,Return) :- case2(Benzene,Output,Return).

tnt_benzene(Return) :- atom_elements(X,carbon,_), cycle(X,Benzene), benzene_is_tnt(Benzene,[],Return).

sort_return(Sorted) :- tnt_benzene(Return), sort(Return, Sorted).

tnt(X) :- findall(Sorted,sort_return(Sorted),Bag), sort(Bag,X).
