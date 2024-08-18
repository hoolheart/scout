use std::collections::HashMap;
use std::hash::Hash;

///  Counter  counts  the  number  of  times  each  value  of  type  T  has  been  seen.
struct Counter<T:  Eq  +  Hash> {
    values: HashMap<T, u64>,
}

impl<T> Counter<T> where T: Eq + Hash {
    ///  Create  a  new  Counter.
    fn new() -> Self {
        Counter {
            values: HashMap::new(),
        }
    }

    ///  Count  an  occurrence  of  the  given  value.
    fn count(&mut self, value: T) {
        let entry = self.values.entry(value).or_insert(0);
        *entry += 1;
    }

    ///  Return  the  number  of  times  the  given  value  has  been  seen.
    fn times_seen(&self, value: T) -> u64 {
        self.values.get(&value).copied().unwrap_or(0)
    }
}

impl<T> From<Vec<T>> for Counter<T> where T: Eq + Hash {
    fn from(from: Vec<T>) -> Self {
        let mut counter = Counter::new();
        for i in from {
            counter.count(i);
        }
        counter
    }
}

fn main() {
    let ctr = Counter::from(vec![13, 14, 16, 14, 14, 11]);
    for i in 10..20 {
        println!("saw  {}  values  equal  to  {}", ctr.times_seen(i), i);
    }
    let mut strctr = Counter::new();
    strctr.count("apple");
    strctr.count("orange");
    strctr.count("apple");
    println!("got  {}  apples", strctr.times_seen("apple"));
}
