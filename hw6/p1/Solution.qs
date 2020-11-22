namespace p1.sol {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    
    operation BaseCarry(a: Qubit, b: Qubit, c_out: Qubit) : Unit
    is Adj + Ctl {
        Controlled X([a, b], c_out);
    }

    operation BaseSum(a: Qubit, b: Qubit) : Unit
    is Adj + Ctl {
        CNOT(a, b);
    }

    operation Carry(a: Qubit, b: Qubit, c_in: Qubit, c_out: Qubit) : Unit
        is Adj + Ctl {
        Controlled X([a, b], c_out);

        within {
            CNOT(a,b);
        } apply {
            Controlled X([c_in, b], c_out);
        }       
    }

    operation Sum(a: Qubit, b: Qubit, c_in: Qubit) : Unit
        is Adj + Ctl {
        CNOT(c_in, b);
        CNOT(a, b);
    }


    operation Add(a: Qubit[], b: Qubit[], carry: Qubit) : Unit 
    is Adj + Ctl {
        let n = Length(a);
        
        using (t = Qubit[n]) {
            BaseCarry(a[0], b[0], t[0]);

            for (i in 1 .. n-1) {           
                Carry(a[i], b[i], t[i-1], t[i]);
            }
            // Apply the last carry to the carry output:
            CNOT(t[n-1], carry);
                    
            for (i in n-1..-1..1) {           
                Adjoint Carry(a[i], b[i], t[i-1], t[i]);
                Sum(a[i], b[i], t[i-1]);
            }

            Adjoint BaseCarry(a[0], b[0], t[0]);
            BaseSum(a[0], b[0]);   
        }
    }

    operation Subtract(a: Qubit[], b: Qubit[], carry: Qubit) : Unit 
    is Adj + Ctl {
        Adjoint Add(a, b, carry);
    }

    // -------------------------------------------
    // | HARNESS
    // -------------------------------------------
    operation testOp(x: Int, y: Int, op: ((Qubit[], Qubit[], Qubit) => Unit)) : Int {

        let n = 4;
        using(qubits = Qubit[(n*2) + 1]) {
            let carry = qubits[0];
            let a = qubits[1..(n)];
            let b = qubits[n+1..n*2];
            
            p1.EncodeInt(a, x);        
            p1.EncodeInt(b, y);
            
            op(a, b, carry);
            
            let r = p1.DecodeInt(b, carry);

            ResetAll(qubits);
            return r;        
        }
    }

    operation testAdd(x: Int, y:Int) : Int {
        return testOp(x, y, p1.Add);
    }

    operation testSubstract(x: Int, y:Int) : Int {
        return testOp(x, y, p1.Subtract);
    }

    @EntryPoint()
    operation Main(x: Int, y: Int) : Unit {
        if (x == 0 and y == 0) {
            testAll();
        } else {
            testOne(x, y);
        }
    }

    operation testAll() : Unit {
        let n = 4;
        let max = (1 <<< n) - 1;

        for (x in 0..max) {
            for (y in 0..max) {
                testOne(x, y);
            }
        }
    }

    operation testOne(x: Int, y: Int) : Unit {
        let n = 4;
        let r1= testAdd(x, y);
        let a1 = (r1 == (x+y) ? "" | "!!!! ");
        Message($"{a1}{y} + {x} = {r1} {a1}");
        //`AllEqualityFactI([(x+y)], [r1], "+");

        let r2 = testSubstract(x, y);
        let y2 = (y >= x) ? y | ((1 <<< (n + 1)) + y);
        let a2 = (r2 == (y2-x)) ? "" | "!!!! ";
        Message($"{a2}{y2} - {x} = {r2} {a2}");
        //AllEqualityFactI([a], [r2], "-");
    }
}