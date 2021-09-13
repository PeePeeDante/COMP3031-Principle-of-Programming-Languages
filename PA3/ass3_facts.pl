/* Q1 */
xs([1, 2, 3, 4, 5.06, 6]).
ys([1, 3, 2, 6, 7.23, 7]).

/* Q2 */
edge('A', 'C').
edge('A', 'B').
edge('A', 'G').
edge('C', 'D').
edge('D', 'E').
edge('E', 'F').
edge('F', 'H').
edge('F', 'G').

/* Q3, Q4
atom_elements(h1,hydrogen,[c1]).
atom_elements(h2,hydrogen,[c2]).
atom_elements(h4,hydrogen,[c4]).
atom_elements(h5,hydrogen,[c5]).
atom_elements(h6,hydrogen,[c6]).
atom_elements(h7,hydrogen,[c7]).
atom_elements(h8,hydrogen,[c7]).
atom_elements(h9,hydrogen,[c7]).
atom_elements(c1,carbon,[c2,c6,h1]).
atom_elements(c2,carbon,[c1,c3,h2]).
atom_elements(c3,carbon,[c2,c7,c4]).
atom_elements(c4,carbon,[c3,c5,h4]).
atom_elements(c5,carbon,[c4,c6,h5]).
atom_elements(c6,carbon,[c1,c5,h6]).
atom_elements(c7,carbon,[c3,h7,h8,h9]).*/

/* Q5
atom_elements(h1,hydrogen,[c1]).
atom_elements(n1,nitrogen,[o1, o2, c2]).
atom_elements(o1,oxygen,[n1]).
atom_elements(o2,oxygen,[n1]).
atom_elements(n2,nitrogen,[o3, o4, c4]).
atom_elements(o3,oxygen,[n2]).
atom_elements(o4,oxygen,[n2]).
atom_elements(h5,hydrogen,[c5]).
atom_elements(n3,nitrogen,[o5, o6, c6]).
atom_elements(o5,oxygen,[n3]).
atom_elements(o6,oxygen,[n3]).
atom_elements(h7,hydrogen,[c7]).
atom_elements(h8,hydrogen,[c7]).
atom_elements(h9,hydrogen,[c7]).
atom_elements(c1,carbon,[c2,c6,h1]).
atom_elements(c2,carbon,[c1,c3,n1]).
atom_elements(c3,carbon,[c2,c7,c4]).
atom_elements(c4,carbon,[c3,c5,n2]).
atom_elements(c5,carbon,[c4,c6,h5]).
atom_elements(c6,carbon,[c1,c5,n3]).
atom_elements(c7,carbon,[c3,h7,h8,h9]).*/

/* Self Test Case */
atom_elements(h1,hydrogen,[c1]).
atom_elements(n1,nitrogen,[o1, o2, c2]).
atom_elements(o1,oxygen,[n1]).
atom_elements(o2,oxygen,[n1]).
atom_elements(n2,nitrogen,[o3, o4, c4]).
atom_elements(o3,oxygen,[n2]).
atom_elements(o4,oxygen,[n2]).
atom_elements(h5,hydrogen,[c5]).
atom_elements(n3,nitrogen,[o5, o6, c6]).
atom_elements(o5,oxygen,[n3]).
atom_elements(o6,oxygen,[n3]).
atom_elements(c1,carbon,[c2,c6,h1]).
atom_elements(c2,carbon,[c1,c3,n1]).
atom_elements(c3,carbon,[c2,c7,c4]).
atom_elements(c4,carbon,[c3,c5,n2]).
atom_elements(c5,carbon,[c4,c6,h5]).
atom_elements(c6,carbon,[c1,c5,n3]).
atom_elements(c7,carbon,[c3,c8,c12]).
atom_elements(c8,carbon,[n4,c7,c9]).
atom_elements(c9,carbon,[c8,c10,h9]).
atom_elements(c10,carbon,[c9,c11,c13]).
atom_elements(c11,carbon,[c10,c12,c16]).
atom_elements(c12,carbon,[c11,c7,n6]).
atom_elements(c13,carbon,[c10,c14,h13]).
atom_elements(c14,carbon,[c13,c15,h14]).
atom_elements(c15,carbon,[c14,c16,h15]).
atom_elements(c16,carbon,[c11,c15,h16]).
atom_elements(n4,nitrogen,[c8,o7,o8]).
atom_elements(n6,nitrogen,[c12,o12,o11]).
atom_elements(o7,oxygen,[n4]).
atom_elements(o8,oxygen,[n4]).
atom_elements(o11,oxygen,[n6]).
atom_elements(o12,oxygen,[n6]).
atom_elements(h9,hydrogen,[c9]).
atom_elements(h13,hydrogen,[c13]).
atom_elements(h14,hydrogen,[c14]).
atom_elements(h15,hydrogen,[c15]).
atom_elements(h16,hydrogen,[c16]).
