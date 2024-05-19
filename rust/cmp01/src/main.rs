fn interproduct(a: i32, b: i32, c: i32) -> i32 {
    a * b + b * c + c * a
}

fn fib(n: u32) -> u32 {
    if n <= 2 {
        // todo!("Implement initial case")
        1
    } else {
        // todo!("Implement recursive case")

        // fib(n - 1) + fib(n - 2)

        // let mut f1: u32 = 1;
        // let mut f2: u32 = 1;
        // for _ in 2..n {
        //     let tmp = f2;
        //     f2 = f1 + f2;
        //     f1 = tmp;
        // }
        // f2

        let mut last2 = (1_u32, 1_u32);
        for _ in 2..n {
            last2 = (last2.1, last2.0 + last2.1);
        }
        last2.1
    }
}

/// Determine the length of the collatz sequence beginning at `n`.
fn collatz_length(n: i32) -> u32 {
    if n == 1 {
        1
    } else if (n % 2) == 0 {
        1 + collatz_length(n / 2)
    } else {
        1 + collatz_length(n * 3 + 1)
    }
}

#[test]
fn test_collatz_length() {
    assert_eq!(collatz_length(11), 15);
}

fn transpose(matrix: [[i32; 3]; 3]) -> [[i32; 3]; 3] {
    let mut transposed = [[0_i32; 3]; 3];
    for row in 0..3 {
        for col in 0..3 {
            transposed[col][row] = matrix[row][col]
        }
    }
    transposed
}

fn main() {
    println!("Hello, 🌏!");
    println!("result: {}", interproduct(120, 100, 148));

    let n = 20;
    println!("fib({n}) = {}", fib(n));

    println!("Length: {}", collatz_length(11));

    let mut arr = [42_i32; 10];
    arr[5] = 0;
    println!("array = {arr:?}");

    let matrix = [
        [101, 102, 103], // <-- the comment makes rustfmt add a newline
        [201, 202, 203],
        [301, 302, 303],
    ];

    println!("matrix: {:?}", matrix);
    let transposed = transpose(matrix);
    println!("transposed: {:?}", transposed);
}
