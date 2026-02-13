//! Minimal STM32F407 example for QEMU with interrupt vectors

#![no_std]
#![no_main]

use cortex_m_rt::entry;
use panic_halt as _;

#[entry]
fn main() -> ! {
    loop {
        cortex_m::asm::wfi();
    }
}

// Default exception handler
#[cortex_m_rt::exception]
unsafe fn DefaultHandler(_irqn: i16) {
    loop {}
}

// Hard fault handler
#[cortex_m_rt::exception]
unsafe fn HardFault(_frame: &cortex_m_rt::ExceptionFrame) -> ! {
    loop {}
}
