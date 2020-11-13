namespace p2 {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    /// # Summary
    /// Creates an entangled state when q1 and q2 are |0>
    operation Entangle(q1: Qubit, q2: Qubit) : Unit {
        H(q1);
        CNOT(q1, q2);
    }

    /// # Summary
    /// Sets the qubit's state to |+>
    operation SetPlus(q: Qubit) : Unit {
        Reset(q);
        H(q);
    }
    
    /// # Summary
    /// Sets the qubit's state to |->
    operation SetMinus(q: Qubit) : Unit {
        Reset(q);
        X(q);
        H(q);
    }

    /// # Summary
    /// Returns true if qubit is |+> (assumes qubit is either |+> or |->)
    operation IsPlus(q: Qubit) : Bool {
        return (Measure([PauliX], [q]) == Zero);
    }

    /// # Summary
    /// Returns true if qubit is |-> (assumes qubit is either |+> or |->)
    operation IsMinus(q: Qubit) : Bool {
        return (Measure([PauliX], [q]) == One);
    }
    
    /// # Summary
    /// Randomly prepares the qubit into |+> or |->
    operation PrepareMessage(q: Qubit, usePlus : Bool) : Unit {
        if (usePlus) {
            Message("Sending  |+>");
            SetPlus(q);
        } else {
            Message("Sending  |->");
            SetMinus(q);
        }
    }

    operation EncodeMessage(q: Qubit, usePlus : Bool) : (Result, Result) {
        using (msg = Qubit()) {
            PrepareMessage(msg, usePlus);
            CNOT(msg, q);
            H(msg);

            return (M(q), M(msg));
        }
    }

    operation DecodeMessage(q: Qubit, a: Result, b: Result) : Unit {
        if (a == One) {
            X(q);
        }

        if (b == One) {
            Z(q);            
        }        
    }

    @EntryPoint()
    operation Main(msg: Bool) : Unit {
        using ((alice, bob) = (Qubit(), Qubit())) {
            Entangle(alice, bob);

            let (a, b) = EncodeMessage(alice, msg);

            DecodeMessage(bob, a, b);

            if (IsPlus(bob)) {
                Message("Received |+>!");
            } elif (IsMinus(bob)) {
                Message("Received |->!");
            } else {
                Message($"Received unexpected state!");
            }
        }
    }
}
