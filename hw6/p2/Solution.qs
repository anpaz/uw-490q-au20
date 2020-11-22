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
        
        Fail(); 

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
}
