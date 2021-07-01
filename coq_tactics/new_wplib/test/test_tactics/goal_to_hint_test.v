(** * Testcases for [goal_to_hint.v].
Authors: 
    - Lulof Pirée (1363638)
Creation date: 2 June 2021

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
Load goal_to_hint.

(** * Test 1
    Should print a hint for a ∀-goal twice.
*)
Goal forall x:nat, x = x.
    print (goal_to_hint (Control.goal ())).
    (* Should print exactly the same:*)
    Help.

    (* Print some whitelines*)
    Ltac2 Eval print (of_string "

    ").
Abort.


(** * Test 2
    Should print a hint for a ⇒-goal twice.
*)
Goal 0=0 -> 0=0.
    print (goal_to_hint (Control.goal ())).
    (* Should print exactly the same:*)
    Help.
    
    (* Print some whitelines*)
    Ltac2 Eval print (of_string "

    ").
Abort.


(** * Test 3
    Should print a hint for a ∃-goal twice.
*)
Goal exists x:nat, x = 1.
    print (goal_to_hint (Control.goal ())).
    (* Should print exactly the same:*)
    Help.
Abort.