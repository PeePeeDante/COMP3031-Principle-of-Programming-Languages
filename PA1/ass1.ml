(* HSU, Chia hong, chsuae@connect.ust.hk, 20562937*)

fun sumDigits(0) = 0  | sumDigits(x:int) = sumDigits(x div 10) + (x mod 10);

fun hasInt([],n:int) = [] | hasInt(head::lst: int list, n:int) = if head=n then 1::hasInt(lst, n) else 0::hasInt(lst, n);
fun prefixSum([], n:int) = [] | prefixSum(head::lst: int list, accu:int) = (head+accu)::prefixSum(lst, head+accu);
fun frequencyPrefixSum(lst:int list, n:int) = prefixSum(hasInt(lst,n),0);

datatype 'a llist = LList of 'a llist list| Elem of 'a;
fun flatten(Elem(x:'a)) = [x]  | flatten(LList([])) = [] | flatten(LList(head::x: 'a llist list)) = flatten(head)@flatten(LList(x));

fun depth(Elem(x:'a)) = 0 | depth(LList([])) = 1 | depth(LList(head::x: 'a llist list)) = (if (1 + depth(head)) > depth(LList(x)) then (1 + depth(head)) else depth(LList(x)));

fun equal(Elem(x), Elem(y)) = if (x=y) then true else false | equal(LList([]),LList([])) = true | equal(LList([Elem(x)]),LList([Elem(y)])) = if (x=y) then true else false | equal(LList(x),LList([])) = false | equal(LList([]), LList(y)) = false | equal(LList(x),Elem(y)) = false | equal(Elem(x),LList(y)) = false | equal(LList(headx::x),LList(heady::y)) = if equal(headx,heady)=true then equal(LList(x),LList(y)) else false;
