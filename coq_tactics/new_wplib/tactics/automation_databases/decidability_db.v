(** * decidability_db.v
Hint database for being able to prove via case distinction.
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


(** **Decidability**
    There are a number of tactics that deal with decidability. 
    They are of the form ``{r1 s1 r2} + {r1 s2 r2}``, and can be useful in case evaluation.
    To implement this, we create a new database ``decidiability``, and a tactic that uses 
    this database (only).
    We first add existing lemmas to the new database.

**TODO**:
    - Add options to split hypotheses ``{r1 <= r2}`` into ``Either {r1 < r2} or {r1 = r2}``.*)


From Ltac2 Require Import Ltac2.

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

Local Open Scope R_scope.



Create HintDb decidability.
Hint Resolve Req_EM_T : decidability.
Hint Resolve Rlt_dec Rle_dec Rgt_dec Rge_dec : decidability.
Hint Resolve Rlt_le_dec Rle_lt_dec Rgt_ge_dec Rge_gt_dec : decidability.


(** The following lemmas are necessary to write e.g. `{r1 ≤ r2} + {r2 < r1}`.*)
Lemma Rlt_ge_dec : forall r1 r2, {r1 < r2} + {r1 >= r2}.
Proof.
    intros.
    destruct (total_order_T r1 r2). 
    destruct s. 
    ltac1:(apply (left r)).
    ltac1:(apply (right (Req_ge r1 r2 e))). 
    ltac1:(apply (right (Rle_ge r2 r1 (Rlt_le r2 r1 r)))).
Qed.

Lemma Rgt_le_dec : forall r1 r2, {r1 > r2} + {r1 <= r2}.
Proof.
    intros.
    destruct (total_order_T r1 r2). 
    destruct s. 
    ltac1:(apply (right (Rlt_le r1 r2 r))).
    ltac1:(apply (right (Req_le r1 r2 e))). 
    ltac1:(apply (left r)).
Qed.

Hint Resolve Rlt_ge_dec Rgt_le_dec : decidability.

(** Finally, we add four more lemmas to write e.g. `{r1 ≤ r2} + {~r2 ≥ r1}`.*)
Lemma Rlt_gt_dec : forall r1 r2, {r1 < r2} + {~ r2 > r1}.
Proof.
    intros.
    destruct (total_order_T r1 r2). 
    destruct s.
    ltac1:(apply (left r)).
    ltac1:(apply (right (Rge_not_gt r2 r1 (Req_ge r1 r2 e)))).
    ltac1:(apply (right (Rgt_asym r1 r2 r))).
Qed.

Lemma Rgt_lt_dec : forall r1 r2, {r1 > r2} + {~ r2 < r1}.
Proof.
    intros.
    destruct (total_order_T r1 r2). 
    destruct s.
    ltac1:(apply (right (Rlt_asym r1 r2 r))).
    ltac1:(apply (right (Rle_not_gt r1 r2 (Req_le r1 r2 e)))).
    ltac1:(apply (left r)).
Qed.

Lemma Rle_ge_dec : forall r1 r2, {r1 <= r2} + {~ r2 >= r1}.
Proof.
    intros.
    destruct (total_order_T r1 r2).
    destruct s.
    ltac1:(apply (left (Rlt_le r1 r2 r))).
    ltac1:(apply (left (Req_le r1 r2 e))).
    ltac1:(apply (right (Rlt_not_ge r2 r1 r))).
Qed.

Lemma Rge_le_dec : forall r1 r2, {r1 >= r2} + {~ r2 <= r1}.
Proof.
    intros.
    destruct (total_order_T r1 r2). 
    destruct s.
    ltac1:(apply (right (Rlt_not_le r2 r1 r))).
    ltac1:(apply (left (Req_ge r1 r2 e))).
    ltac1:(apply (left (Rgt_ge r1 r2 r))).
Qed.

Hint Resolve Rlt_gt_dec Rgt_lt_dec Rle_ge_dec Rge_le_dec : decidability.