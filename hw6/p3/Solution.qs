namespace p3 {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation ConditionalPhaseFlip (register : Qubit[]) : Unit is Adj {
        // ...
        let n = Length(register);
        within {
            ApplyToEachA(X, register);
        } apply {
            Controlled Z(register[1..n-1], register[0]);
            R(PauliI, Microsoft.Quantum.Math.PI(), register[0]);
        }
    }
    
    operation GroverIteration_sln (register : Qubit[]) : Unit is Adj {
        // ...
        let oracle = OracleConverter(TestOracle);

        oracle(register);
        ApplyToEachA(H, register);
        ConditionalPhaseFlip(register);
        ApplyToEachA(H, register);
    }

    operation TestOracle(q: Qubit[], target: Qubit) : Unit 
    is Adj {
        within {
            X(q[0]);
            X(q[3]);
        } apply {
            Controlled X(q, target);
        }
    }
}