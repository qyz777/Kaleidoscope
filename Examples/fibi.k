def binary : 1 (x y) y;

def fib(x)
    if (x < 3) then
        1
    else
        fib(x-1)+fib(x-2);

def fibi(x)
    var a = 1, b = 1, c in
    (for i = 3, i < x in
        c = a + b :
        a = b :
        b = c) :
    b;

fibi(10);
