OSNAME := haribote

.DEFAULT_GOAL : all
.PHONY : all
all : img

ipl.bin : ipl.asm
${OSNAME}.sys : ${OSNAME}.asm

%.bin : %.asm
	nasm $^ -o $@ -l $*.lst

%.sys : %.asm
	nasm $^ -o $@ -l $*.lst

${OSNAME}.img : ipl.bin ${OSNAME}.sys
	mformat -f 1440 -C -B ipl.bin -i $@ ::
# OS本体をイメージに書き込む
	mcopy -i $@ ${OSNAME}.sys ::

.PHONY : asm
asm :
	make ipl.bin

.PHONY : img
img :
	make ${OSNAME}.img

.PHONY : clean
clean :
# lstは残しておいてもいいと思うのでcleanに入れていない
	@rm *.img *.bin *.sys