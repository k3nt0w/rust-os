OUTPUT_DIR := build
ASM_DIR := asm
OUTPUT_DIR_KEEP := $(OUTPUT_DIR)/.keep
IMG := $(OUTPUT_DIR)/haribote.img

# ターゲット名: 依存ファイル名
#      コマンド行

default:
	make img

# $< : 最初の依存ファイルの名前
# $@ : ターゲットファイル名
# $% : ターゲットがアーカイブメンバだったときのターゲットメンバ名
# $? : ターゲットより新しいすべての依存ファイル名
# $^ : すべての依存ファイルの名前
# $+ : Makefileと同じ順番の依存ファイルの名前
# $* : サフィックスを除いたターゲットの名前

$(OUTPUT_DIR)/%.bin: $(ASM_DIR)/%.asm Makefile $(OUTPUT_DIR_KEEP)
	nasm $< -o $@

$(OUTPUT_DIR)/haribote.sys : $(OUTPUT_DIR)/asmhead.bin $(OUTPUT_DIR)/kernel.bin
	cat $^ > $@

$(IMG) : $(OUTPUT_DIR)/ipl.bin $(OUTPUT_DIR)/haribote.sys Makefile
	mformat -f 1440 -C -B $< -i $@ ::
	mcopy $(OUTPUT_DIR)/haribote.sys -i $@ ::

asm :
	make $(OUTPUT_DIR)/ipl.bin

img :
	make clean
	cargo xbuild --target i686-haribote.json
	make $(IMG)

clean :
	rm -rf $(OUTPUT_DIR)/*

$(OUTPUT_DIR)/kernel.bin: $(OUTPUT_DIR)/libharibote_os.a $(OUTPUT_DIR_KEEP)
	ld -v -nostdlib -m elf_i386 -Tdata=0x00310000 -Tkernel.ld $<  -o $@

$(OUTPUT_DIR)/libharibote_os.a: $(OUTPUT_DIR_KEEP)
	cargo xbuild --target-dir $(OUTPUT_DIR)
	cp $(OUTPUT_DIR)/i686-haribote/debug/libharibote_os.a $(OUTPUT_DIR)/

$(OUTPUT_DIR_KEEP):
	mkdir -p $(OUTPUT_DIR)
	touch $@