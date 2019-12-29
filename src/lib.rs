#![no_std]
#![feature(asm)]
#![feature(start)]

use core::panic::PanicInfo;

#[no_mangle]
fn hlt() {
    unsafe {
        asm!("hlt");
    }
}

#[no_mangle]
fn fill(i: u32, color: u8) {
    // &mut参照によって、借用しているリソースを変更できるようになる
    let ptr = unsafe { &mut *(i as *mut u8) };
    // &mut参照だから * がついている
    // 生ポインタで指定したアドレスに直接色情報を入れている
    *ptr = color
}

#[no_mangle]
#[start]
pub extern "C" fn haribote_os() -> ! {
    for i in 0xa0000..0xaffff {
        fill(i, (i as u8) & 0x0f);
    }
    loop {
        hlt()
    }
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {
        hlt()
    }
}
