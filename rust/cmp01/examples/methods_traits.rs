#[derive(Debug)]
struct Race {
    name: String,
    laps: Vec<i32>,
}

impl Race {
    fn new(name: &str) -> Self {
        Race{name: String::from(name), laps: Vec::new()}
    }

    fn add_lap(&mut self, lap: i32) {
        self.laps.push(lap);
    }

    fn print_laps(&self) {
        println!("Recorded {} laps for {}:", self.laps.len(), self.name);
        for (idx, lap) in self.laps.iter().enumerate() {
            println!("Lap {idx}: {lap} sec");
        }
    }
}

trait Dimensional {
    fn get_dimension(&self) -> usize;
}

#[derive(Debug)]
struct Cooridinate {
    indexes: Vec<i32>,
}

impl Dimensional for Cooridinate {
    fn get_dimension(&self) -> usize {
        self.indexes.len()
    }
}

fn main() {
    println!("Hello methods and traits!");

    let mut race = Race::new("Price race");
    race.add_lap(13);
    race.add_lap(71);
    race.add_lap(99);
    race.print_laps();

    let dim0: &dyn Dimensional = &Cooridinate{indexes: [-5, 7].to_vec()};
    println!("Dimensional {}", dim0.get_dimension());
}
