// https://doc.rust-jp.rs/the-rust-programming-language-ja/1.6/book/inline-assembly.html

pub fn load_eflags() -> i32 {
  let result: i32;
  unsafe {
    asm!("PUSHFD" : : : : "intel");
    asm!("POP EAX": "={EAX}"(result): : : "intel");
  }
  result
}

pub fn store_eflags(flags: i32) {
  unsafe {
    asm!("PUSH EAX" : : "EAX"(flags) : : "intel");
    asm!("POPFD");
  }
}

pub fn cli() {
  unsafe {
    asm!("CLI" : : : : "intel");
  }
}

pub fn out8(port: u32, data: u8) {
  unsafe {
    asm!("OUT DX,AL" : : "{EDX}"(port), "{EAX}"(data) :  : "intel" );
  }
}
