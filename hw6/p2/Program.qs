namespace p2 {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    //@EntryPoint()
    operation Main(x: Int) : Unit {
        let n = 4; // Number of qubits

        using (qubits = Qubit[n + 1]) {
            let target = qubits[0];
            let register = qubits[1..n];

            // Encode x into the state of the qubit register
            EncodeInt(register, x);

            // Call the Oracle_And
            p2.sln.Oracle_And(register, target);
            let a = MResetZ(target);            
            Message($"And({x}) = {a}");

            // Call the Oracle_6
            p2.sln.Oracle_6(register, target);
            let b = MResetZ(target);
            Message($"IsSix({x}) = {b}");

            // Call the Oracle_Or
            p2.sln.Oracle_Or(register, target);
            let c = MResetZ(target);
            Message($"Or({x}) = {c}");

            // Call the Oracle_SATClause
            let clause = [(0, false), (1, true)];            
            p2.sln.Oracle_SATClause(register, target, clause);
            let d = MResetZ(target);
            Message($"SATClause({x}, [~0,1]) = {d}");
                   
            // Call the Oracle_SAT
            p2.sln.Oracle_SAT(register, target, [clause]);
            let e = MResetZ(target);
            Message($"SAT({x}, [~0,1]) = {d}");

            // To avoid errors from releasing non-measured qubits.
            ResetAll(qubits);
        }
    }

    /// #Summary
    ///     Given an array of Qubits, it prepares its state
    ///     to match the value given, in LittleEndian notation.
    operation EncodeInt(a: Qubit[], value: Int) : Unit 
    is Adj {
        for(i in 0..(Length(a) - 1)) {
            if (((value >>> i) &&& 1) == 1) {
                X(a[i]);
            }
        }
    }

    /// #Summary
    ///     Given an array of Qubits, it measures the value of each
    ///     and return the value of the corresponding bits in LittleEndian notation.
    operation DecodeInt(a: Qubit[], carry: Qubit) : Int {
        mutable r = 0;
        
        for(i in 0..(Length(a) - 1)) {
            if (M(a[i]) == One) {
                set r += (1 <<< i);
            }
        }

        if (M(carry) == One) {
            set r += (1 <<< Length(a));
        }

        return r;
    }
}
