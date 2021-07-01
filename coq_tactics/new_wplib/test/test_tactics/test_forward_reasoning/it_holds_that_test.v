(** * Testcases for [it_holds_that.v]
Authors: 
    - Lulof Pirée (1363638)
Creation date: 6 June 2021


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
Load test_auxiliary.
Load it_holds_that.

(* lra only works in the [R_scope] *)
Local Open Scope R_scope.
Lemma zero_lt_one: 0 < 1.
Proof.
    ltac1:(lra).
Qed.

(* This axiom does not make sense, 
    but therefore we can be sure that [waterprove]
    does not know it without *explicitly* being told to use it.*)
    Axiom zero_is_ten: 0 = 10.

(* -------------------------------------------------------------------------- *)
(** * Testcases for [By ... it holds that ... : ...] *)
Ltac2 Eval (print (of_string "

Testcases for [By ... it holds that ... : ...]:" )).

(** * Test 1
    Base case: intoduce a sublemma with a lemma that proves it
    immediately.

    NOTE: [waterprove] can apparently also find
    [zero_lt_one] by itself.
*)
Lemma test_by_it_holds_1: 0 = 0.
Proof.
    By zero_lt_one it holds that this_lemma:(0 < 1).
    assert_hyp_has_type @this_lemma constr:(0 < 1).
Abort.

(** * Test 2
    Base case: intoduce a sublemma with a lemma that proves it
    immediately. 
    The sublemma cannot be proven without the given lemma!

*)
Lemma test_by_it_holds_2: True.
Proof.
    (* This is just to test if the extra lemma is really needed: *)
    let failure () := It holds that ten_is_zero:(10 = 0) in
    assert_raises_error failure.
    
    By zero_is_ten it holds that ten_is_zero:(10 = 0).
Abort.

(** * Test 3
    Corner case: try a sublemma that cannot be solved,
    at least not with the default lemmas and the provided lemma.
*)
Lemma test_by_it_holds_3: 0 = 0.
Proof.
    let result () := 
        By zero_lt_one it holds that this_lemma:(1 > 2)
    in
    assert_raises_error result.
Abort.


(* -------------------------------------------------------------------------- *)
(** * Testcases for [It holds that ... : ...] *)
Ltac2 Eval (print (of_string "

Testcases for [It holds that ... : ...]:" )).


(** * Test 1
    Base case: intoduce a sublemma that can be proven immediately.
*)
Lemma test_it_holds_1: 0 = 0.
Proof.
    It holds that this_lemma:(True).
    assert_hyp_has_type @this_lemma constr:(True).
Abort.


(** * Test 2
    Corner case: try a sublemma that cannot be solved,
    at least not with the default lemmas [waterprove] uses.
*)
Lemma test_it_holds_2: 0 = 0.
Proof.
    let result () := 
        It holds that this_lemma:(1 > 2)
    in
    assert_raises_error result.
Abort.

(** * Example for the SUM.
    Somewhat more realistic context.
*)

Open Scope nat_scope.
Inductive even : nat -> Prop :=
    even0 : even 0
  | evenS : forall x:nat, even x -> even (S (S x)).

Lemma it_holds_example: forall x:nat, x > 1 /\ x < 3 -> even x.
Proof.
    intros x h.
    It holds that x_is_two: (x = 2).
    rewrite x_is_two. (* Change the goal to "even 2"*)
    apply evenS. (* Change the goal to "even 0"*)
    apply even0.
Qed.

Open Scope R_scope.