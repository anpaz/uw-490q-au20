namespace p2.sln {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;

    operation Oracle_And (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        Controlled X(queryRegister, target);
    }
 
    
    operation Oracle_Or (queryRegister : Qubit[], target : Qubit) : Unit 
    is Adj {
        within {
            ApplyToEachA(X, queryRegister);
        } apply {
            Oracle_And(queryRegister, target);
        }
        
        X(target);
    }

    operation Oracle_6 (q : Qubit[], target : Qubit) : Unit 
    is Adj {
        within {
            X(q[0]);
            for(i in 3..Length(q) -1) {
                X(q[i]);
            }
        } apply {
            Controlled X(q, target);
        }
    }

    function get_targets(queryRegister : Qubit[], clause : (Int, Bool)[]) : Qubit[] {
        mutable targets = new Qubit[0];
        for ((index, on) in clause) {
            set targets += [queryRegister[index]];
        }
        
        return targets;
    }

    operation Oracle_SATClause (queryRegister : Qubit[], target : Qubit, clause : (Int, Bool)[]) : Unit is Adj {
        within {
            for ((index, on) in clause) {
                if (on == false) { 
                    X (queryRegister[index]);
                }
            }
        } apply {
            Oracle_Or(get_targets(queryRegister, clause), target);
        }
    }

    operation Oracle_SAT (queryRegister : Qubit[], target : Qubit, problem : (Int, Bool)[][]) : Unit is Adj {
        using (helpers = Qubit[Length(problem)]) {
            let pair = Zipped(problem, helpers);
            
            within {
                for((c, q) in pair) {                
                    Oracle_SATClause(queryRegister, q, c);
                }
            } apply {
                Controlled X(helpers, target);
            }
        }
    }

    @EntryPoint()
    operation Main(x: Int) : Unit {
        if (x < 0) {
            testAllInputs();
        } else {
            testOneInput(x);
        }
    }

    operation testAllInputs() : Unit {
        let n = 4;
        let max = (1 <<< n) - 1;

        for((oracle, classical) in allOracles()) {
            Message($"{oracle}");
            for (x in 0..max) {
                testOracle(x, oracle, classical);
            }
        }
    }

    operation testOneInput(x: Int) : Unit {
        for((oracle, classical) in allOracles()) {
            testOracle(x, oracle, classical);
        }
    }

    operation testOracle(x: Int, oracle: ((Qubit[], Qubit) => Unit), answer: (Int -> Bool)) : Unit {
        let n = 4;
        using((qubits, target) = (Qubit[n], Qubit())) {
            p2.EncodeInt(qubits, x);

            oracle(qubits, target);
            let actual = M(target);
            let expected = answer(x) == true ? One | Zero;
            let a = (actual == expected) ? "    " | "!!! ";

            Message($"{a}{oracle} on {x} = {actual} {a}");
            
            ResetAll(qubits + [target]);
        }
    }

    function classical_And(x: Int) : Bool {
        let n = 4;
        let max = (1 <<< n) - 1;
        return (x == max);
    }

    function classical_6(x: Int) : Bool {
        return (x == 6);
    }

    function classical_Or(x: Int) : Bool {
        return (x != 0);
    }

    function classical_Clause0(x: Int) : Bool {
        return (
            (x > 7) or
            (x == 0) or (x == 1) or
            (x ==4) or (x ==5));
    }

    function classical_Clause1(x: Int) : Bool {
        return 
            (x < 8);
    }

    function classical_SAT(x: Int) : Bool {
        return (classical_Clause0(x) and classical_Clause1(x));
    }

    function allOracles() : (((Qubit[], Qubit) => Unit is Adj), (Int -> Bool))[] {
        let clauses = [
            [
                (1, false),
                (3, true)
            ],
            [
                (3, false)
            ]
        ];

        return [
            (p2.Oracle_And, classical_And),
            (p2.Oracle_6, classical_6),
            (p2.Oracle_Or, classical_Or),
            (p2.Oracle_SATClause(_, _, clauses[0]), classical_Clause0),
            (p2.Oracle_SATClause(_, _, clauses[1]), classical_Clause1),
            (p2.Oracle_SAT(_, _, clauses), classical_SAT)
        ];
    }
}
