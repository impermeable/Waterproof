(** * check_status.v
Authors: 
    - Lulof Pirée (1363638)
Creation date: 2 June 2021

[Check status] prints a hint to the user how to tackle the rest of the proof.

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

Ltac2 Type exn ::= [ GoalHintError(string) ].

Local Ltac2 create_forall_message (v_type: constr) :=
Message.concat 
    (Message.concat
            (Message.concat
                (Message.of_string "The goal has a forall-quantifier (∀).
You may need to introduce an arbitrary variable of type ")
                (Message.of_constr v_type)
            )
            ( Message.of_string ".
This can for example be done using 'Take ... : ...'.")
    )
    (Message.concat
        (Message.concat 
            (Message.of_string "
Or you may need to make an assumption stating ")
            (Message.of_constr v_type)
        )
        ( Message.of_string ".
This can for example be done using 'Assume ... : ...'.")
    ).

Local Ltac2 create_implication_message (premise: constr) :=
    Message.concat
        (Message.concat
            (Message.of_string "The goal has an implication (⇒).
You may need to assume the premise ")
            (Message.of_constr premise)
        )
        ( Message.of_string ".
This can for example be done using 'Assume ... : ...'.").

Local Ltac2 create_exists_message (premise: constr) :=
    Message.concat
        (Message.concat
            (Message.of_string "The goal has an existential quantifier (∃).
You may want to choose a specific variable of type ")
                (Message.of_constr premise)
        )
        ( Message.of_string ".
This can for example be done using 'Choose ... '.").


Ltac2 goal_to_hint (g:constr) :=
    (* The order matters. 
        If the ∀ case is above the ⇒,
        then implications will fire the ∀ case instead.*)
    lazy_match! g with
    | context [?a -> ?b] => create_implication_message a
    | context [forall v:?v_type, _]  => create_forall_message v_type
    | context [exists v:?v_type, _] => create_exists_message v_type
    | _ => Control.zero (GoalHintError "No hint available for this goal.")
    end.

Goal forall x:nat, x = x.
    print (goal_to_hint (Control.goal ())).
    let g := Control.goal () in
    print (of_constr (eval cbv in $g)).
Abort.

Goal 0=0 -> 0=0.
    print (goal_to_hint (Control.goal ())).
    let g := Control.goal () in
    print (of_constr (eval cbv in $g)).
Abort.

Goal exists x:nat, x = 1.
    print (goal_to_hint (Control.goal ())).
    let g := Control.goal () in
    print (of_constr (eval cbv in $g)).
Abort.
