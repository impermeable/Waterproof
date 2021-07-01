(** * forward_reasoning.v
Authors: 
    - Lulof Pirée (1363638)
Creation date: 3 June 2021

Auxiliary functions for tactics 
that rely on [auto] (usually indirectly via [waterprove]).

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

Require Import Rbase.
Require Import Qreals.
Require Import Rfunctions.
Require Import SeqSeries.
Require Import Rtrigo.
Require Import Ranalysis.
Require Import Integration.
Require Import micromega.Lra.
Require Import Omega.
Require Import Max.

Require Import Sets.Ensembles.
Require Import Sets.Classical_sets.

Add LoadPath "./coq_tactics/new_wplib/" as wplib.
Load waterprove.
Load goal_to_hint.
Load auxiliary.

Lemma dummy_lemma: True.
Proof.
    apply I.
Qed.

(** * get_search_depth
    Placeholder for the function that retrieves the maximum
    search-depth to pass as an argument to [waterprove].
*)
Ltac2 get_search_depth () := 
    print (of_string "Warning: seach depth still hardcoded to '2'.");
    2.

(** * waterprove_with_hint
    First print an hint for reaching the target goal,
    try to prove the goal immediately afterward.

    Arguments:
        - [target_goal: constr], the goal to prove. 
        - [lemmas: constr], lemmas to pass to [waterprove] for automatically
            proving the [target_goal].
*)
Ltac2 waterprove_with_hint (target_goal:constr) (lemmas:constr) :=
    print_goal_hint (Some target_goal);
    waterprove target_goal lemmas (get_search_depth ()).

Ltac2 print_failure () :=
    print (of_string "Waterproof could not find a proof. 
If you believe the statement should hold, 
try making a smaller step.").

(** * unwrap_optional_lemma
    Given an optional lemma, either returns the lemma itself,
    or case the argument is [None], returns a dummy lemma.

    Arguments:
        - [lemma: constr option], one of the following:
            - a [constr] referring to a lemma, wrapped in [Some].
            - the value [None]
    
    Returns:
        - [constr]: the provided lemma, or [dummy_lemma] in case
            the input was [None]. [dummy_lemma] simply states that [0=0].
*)
Ltac2 unwrap_optional_lemma (lemma: constr option) :=
    match lemma with
    | None => constr:(dummy_lemma)
    | Some y => y
    end.