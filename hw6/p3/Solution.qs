namespace p3.sln {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

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
    
    operation GroverIteration (register : Qubit[], oracle : (Qubit[] => Unit is Adj)) : Unit 
    is Adj {
        oracle(register);
        ApplyToEachA(H, register);
        ConditionalPhaseFlip(register);
        ApplyToEachA(H, register);
    }


    /// # Summary
    ///     Implements GroverSearch by calling the GroverIteration `iterations`
    operation GroversSearch (register : Qubit[], oracle : ((Qubit[], Qubit) => Unit is Adj), iterations : Int) : Unit {
        ApplyToEachA(H, register);
        
        for (i in 1..iterations) {
            p3.GroverIteration(register, p3.OracleConverter(oracle));
        }
    }

    function allOracles() : (((Qubit[], Qubit) => Unit is Adj), Int)[] {
        let clauses = [
            [ (0, true) ],
            [ (1, false) ],
            [ (2, false) ],
            [ (3, true) ]
        ];

        return [
            (p2.sln.Oracle_And, 15),
            (p2.sln.Oracle_6, 6),
            (p2.sln.Oracle_SAT(_, _, clauses), 9)
        ];
    }


    @EntryPoint()
    operation Main() : Unit {
        for((oracle, classical) in allOracles()) {
            testGrover(oracle, classical);
        }
    }

    operation testGrover(oracle : ((Qubit[], Qubit) => Unit is Adj), expected: Int) : Unit {
        let n = 4;
        let iterations = p3.GroverIterationsCount(n);
        
        using ((register, target) = (Qubit[n], Qubit())) {
            GroversSearch(register, oracle, iterations);    

            let actual = p2.DecodeInt(register, target);
            let a = (actual == expected) ? "    " | "!!! ";

            Message($"{a}{oracle}: x:{expected}; a:{actual} {a}");
        }
    }
}