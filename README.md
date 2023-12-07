# colorworld

## Overview

The repro is only my learners repro - I try hard to get a grip on the features.

The repro contains some stupid stuff about graph coloring. This is to try the basics.

Furthermore, there is a tiny calulator using parallel processes and messages.

## Build

~~~
$ rebar3 compile
$ rebar3 eunit
~~~

## Multi-Task-Calculator

It implements parallel processing of terms expressed as reverse Łukasiewicz notation 
([RPN](https://en.wikipedia.org/wiki/Reverse_Polish_notation)).

Each expression is notated as erlang list, e.g.: <code>[1,2,add,2,mul]</code>.

On the rebar3 shell it works like this:

~~~
1> calculator:do([[1,2,add,2,mul]]).
....
[[6]]
2>calculator:do([[30,50,10,10,200,sum],[1,4,7,add,mul,17,add]]).
...
[[300],[28]
3>calculator:do([[30,50,10,10,200,sum],[1,4,7,add,mul,17,add],[0],[17,3,mul,fact]]).
...
...
[[0],
 [1551118753287382280224243016469303211063259720016986112000000000000],
 [300],
 [28]]
 4>
~~~

Currently only *add* with two arguments, *mul* with two arguments, *sum* with all available arguments on the stack, finally, *fact* for factorial.

This is how it works:
- with <code>calculator:do([Terms])</code> all required processes are startet:
  - the operator units (*add*, *mul*, *sum*, *fact*),
  - a supervisor, which collects the results, 
  - for each *term* a single calculation units, which handles the rpn, and calls the operator units accordingly
- if a calculation unit is finished, informs the supervisor and ends by itself.
- when all results are pathed to the supervisor, it tears down the opertor units.
  
## Colorworld

The tiny experiments implements an algorithmus to color some graph. The world example is only an abstract Europe.

On the shell it looks like:

~~~
4> colorworld:color_world().
{[{"de",1},
  {"fr",2},
  {"oe",2},
  {"it",1},
  {"bw",1},
  {"hu",3},
  {"sl",4},
  {"bl",3},
  {"po",2},
  {"ju",2},
  {"v0",1},
  {"ch",3},
  {"tc",3},
  {"lx",4},
  {"sp",3},
  {"pr",2},
  {"nl",2},
  {"gr",3},
  {"dk",2}],
 19,4}
 5>
~~~

The result is a tuple containing: 

<code>{ color map, number of countries and numbers of colors }</code>,
