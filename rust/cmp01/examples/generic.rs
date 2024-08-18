use std::cmp::Ordering;

//  Select minimal value from input pair with any comparable type
fn min<T>(a: T, b: T) -> T where T: Ord {
    match a.cmp(&b) {
        Ordering::Less | Ordering::Equal => a,
        Ordering::Greater => b,
    }
}

fn main() {
    assert_eq!(min(0, 10), 0);
    assert_eq!(min(500, 123), 123);
    assert_eq!(min('a', 'z'), 'a');
    assert_eq!(min('7', '1'), '1');
    assert_eq!(min("hello", "goodbye"), "goodbye");
    assert_eq!(min("bat", "armadillo"), "armadillo");
}
