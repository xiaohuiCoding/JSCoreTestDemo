var testBool = 1;
var testArray = ['a', 'b', 'c', 1, 2, 3];

function func1() {
    return 'OC调用了JS的无参方法';
};

function func2(arg1,arg2) {
    return 'OC调用了JS的有参方法，参数分别是：' + arg1 + '、' + arg2;
};

function func3() {
    callOCMethod1();
}

function func4() {
    callOCMethod2('Hello','world');
}
