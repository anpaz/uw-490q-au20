

# Homework 1

You'll need to write your programs using Q#. For instructions on how to install the QDK tools 
check: https://docs.microsoft.com/en-us/quantum/quickstarts/#install-the-qdk-locally

For the extra credits, you'll also need to be able to run the QuantumKatas locally.
Instructions on how to setup your development environment can be found 
here: https://github.com/microsoft/QuantumKatas#run-the-katas-locally-

Each Exercise has its own folder with a skeleton and entry-points of the programs to get you started. When completes, send the `.qs` file with the answer.


## Exercise 1: Superdense coding.

Write a Q# program that showcases the superdense coding protocol. The program should include:
1. A `PrepareBellState` operation that given two qubits in the |00> state, prepares a Bell Pair state
2. A `EncodeMessage` operation that encodes two bits of information into a single Qubit
3. A `DecodeMessage` operation that given two qubits, it removes entanglement and measures the qubits to return the encoded DecodeMessage
4. A `Main` EntryPoint, that receives two bits of information, invokes the protocol and returns back the measurement of the Qubits.
    
See https://en.wikipedia.org/wiki/Superdense_coding for a good explanation of how the protocol works.


## Exercise 2: Oracles.

Oracles are widely used in quantun algorithms. An oracle is typically a function `f(x)` that returns 1 if a condition is met, 0 otherwise.
A quantum oracle in Q# can be implemented as an `operation` that takes (at least) two arguments:
  * `x`: a register of n qubits in an arbitrary state
  * `y`: a qubit that holds the oracle answer
after calling the operation the state of register `x` must remain constant and the state of qubit `y` will bee `|y + f(x)>`, that is, it takes:
```
    |x, y> => |x, y + f(x)>
```

Implement the following oracles:

1. `Oracle_One`: that is, `f(x) = 1`
1. `Oracle_Kth_Qubit`: that is, an oracle that  `f(x) = 1 iff the k-th qubit is 1` 
1. `Oracle_Odd`: that is, an oracle that  `f(x) = 1 iff the x has an odd number of qubits in state 1` 


## Exercise 3: In-place Adder.

Even the most basic operations like adding integers must be re-implemented for a quantum computer
using only reversible gates.
An in-place adder is an operation that given two qubit registers as arguments, `x` and `y`, leaves the state of register `x` constant
and changes the state of register `y` to be `|y + x>`.

Implement an in-place adder for 4-qubit registers. 

Once you have the adder, what would it take to implement an in-place substractor? i.e. an operation that given two qubit registers 
as arguments, `x` and `y`, leaves the state of register `x` constant and changes the state of register `y` to be `|y - x>`.



## Extra credit: Complete the Deutsch-Jozsa and Grover Search algorithm Katas.

These Katas can be found in the /DeutschJozsaAlgorithm and /GroversAlgorithm folders accordingly of the [QuantumKatas repository](https://github.com/microsoft/QuantumKatas.git).
Clone the repository and complete the Kata locally. You may complete this exercise using either the Jupyter Notebook of the Q# version of the Katas. 
Once completed, send the entire GroversAlgorithm folder with your changes.

