//! STM32F407 RTIC 最小系统示例

#![no_std]
#![no_main]

use panic_halt as _;

use cortex_m::peripheral::NVIC;
use rtic::app;
use stm32f4xx_hal::{
    gpio::{self, Output, PushPull},
    pac,
    prelude::*,
};

type LedPin = gpio::PA5<Output<PushPull>>;
type MyTimer = stm32f4xx_hal::timer::Counter<pac::TIM2, 168000000>;

#[app(device = stm32f4xx_hal::pac, peripherals = true)]
mod app {
    use super::*;

    #[shared]
    struct Shared {
        led: LedPin,
        counter: u32,
    }

    #[local]
    struct Local {
        timer: MyTimer,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local, init::Monotonics) {
        let dp = cx.device;

        let rcc = dp.RCC.constrain();
        let clocks = rcc.cfgr.sysclk(168.MHz()).freeze();

        let gpioa = dp.GPIOA.split();
        let led = gpioa.pa5.into_push_pull_output();

        let mut timer = dp.TIM2.counter(&clocks);

        let _ = timer.start(1.secs());
        timer.listen(stm32f4xx_hal::timer::Event::Update);

        unsafe {
            NVIC::unmask(pac::Interrupt::TIM2);
        }

        (
            Shared { led, counter: 0 },
            Local { timer },
            init::Monotonics(),
        )
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {
            cortex_m::asm::wfi();
        }
    }

    #[task(binds = TIM2, local = [timer], shared = [led, counter])]
    fn timer_interrupt(cx: timer_interrupt::Context) {
        let _ = cx.local.timer.wait();
        let _ = cx.local.timer.start(1.secs());

        let mut led = cx.shared.led;
        let mut counter = cx.shared.counter;

        led.lock(|l| l.toggle());
        counter.lock(|c| *c += 1);
    }
}
