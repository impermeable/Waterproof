(** * we_need_to_show.v
Authors: 
    - Lulof Pirée (1363638)

Creation date: 18 May 2021

Tactic that checks if the user input matches the goal.
Does not proceed the proof;
only helps for proof readability.

--------------------------------------------------------------------------------

This file is part of Waterproof-lib.

Waterproof-lib is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Waterproof-lib is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Waterproof-lib.  If not, see <https://www.gnu.org/licenses/>.
*)
From Ltac2 Require Import Ltac2.
From Ltac2 Require Option.
From Ltac2 Require Import Message.
Add LoadPath "./coq_tactics/new_wplib/" as wplib.
Load auxiliary. (* Imports check_constr_type_equal (among others)*)


Ltac2 Type exn ::= [ GoalCheckError(string) ].

Ltac2 raise_goal_check_error (s:string) := 
    Control.zero (GoalCheckError s).

(** * check_goal
    Check if the type of the goal is syntactically equal to [t].

    Arguments:
        - [t: constr], any constr to be compared against the goal.

    Does:
        - Prints a confirmation that the goal equals the provided type.
    
    Raises Exceptions:
        - [GoalCheckError], if the goal is not syntactically equal to [t].
*)
Local Ltac2 check_goal := fun (t:constr) =>
    lazy_match! goal with
    | [ |- ?g] => 
        match Aux.check_constr_equal g t with
        | true => print (concat 
                    (of_string "The goal is indeed: ") (of_constr t))
        | false => raise_goal_check_error "No such goal"
        end
    | [|-_] => raise_goal_check_error "No such goal"
    end.

(* Allow different syntax styles:
    - We need to show ...
    - We need to show that ...
    - We need to show : ...
    - We need to show that : ...
    - To show ...
    - To show that ...
    - To show : ...
    - To show that : ...

    Optional string keywords do need to have a name,
    even though the parser will not populate this name. 
    (That's why it reads "that(opt('that'))" instead of "opt('that')".*)
Ltac2 Notation "We" "need" "to" "show" that(opt("that")) 
        column(opt(":")) t(constr) :=
        check_goal t.
Ltac2 Notation "To" "show" that(opt("that")) column(opt(":")) t(constr) :=
  check_goal t.

