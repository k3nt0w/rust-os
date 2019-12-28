; haribote-ipl
; TAB=4
CYLS    EQU   10
OS_BODY EQU   0xc200

		ORG		0x7c00

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"
		DW		512
		DB		1
		DW		1
		DB		2
		DW		224
		DW		2880
		DB		0xf0
		DW		9
		DW		18
		DW		2
		DD		0
		DD		2880
		DB		0,0,0x29
		DD		0xffffffff
		DB		"HARIBOTEOS "
		DB		"FAT12   "
		RESB	18

entry:
		MOV		AX,0
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

		MOV		AX,0x0820 ; この辺シリンダとかの指定
		MOV		ES,AX
		MOV		CH,0
		MOV		DH,0
		MOV		CL,2

readloop:
		MOV   SI,0

retry:
		; 失敗しても5回はドライブリセットを試す
		MOV     AH, 0x02        ; INT 0x13での読み込み指定
		MOV     AL, 1           ; 読み込む連続したセクタ数
		MOV     BX, 0           ; Buffer Address | ES:BXのBX
		MOV     DL, 0x00        ; ドライブ番号 Aドライブ
		INT     0x13            ; BIOS call -> エラーの時キャリーフラグが立つ
														; [INT(0x13); ディスク関係 - (AT)BIOS - os-wiki](http://oswiki.osask.jp/?%28AT%29BIOS#q5006ed6)
		JNC     next            ; Jump if Not CARRY FLAG == 1

		ADD     SI, 1
		CMP     SI, 5
		JAE     error           ; if SI >= 5 then jump to error

		MOV     AH, 0x00
		MOV     DL, 0x00        ; ドライブを指定
		INT     0x13            ; ドライブをリセット
		JMP     retry

next:
		MOV     AX,ES
		ADD			AX,0x0020
		MOV			ES,AX
		ADD			CL,1 ; セクタに1足す
		CMP			CL,18	; セクタの最大数が18だから、１８と比較する
		JBE			readloop ; jump if below
		MOV			CL,1
		ADD			DH,1
		CMP			DH,2
		JB			readloop
		MOV			DH,0
		ADD			CH,1
		CMP			CH,CYLS
		JB			readloop
		MOV     [0x0ff0], CH
		JMP     OS_BODY
fin:
		HLT
		JMP		fin

error:
		MOV		SI,msg
putloop:
		MOV   AL, BYTE [DS:SI]
		ADD		SI,1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e
		MOV		BX,15
		INT		0x10
		JMP		putloop
msg:
		DB		0x0a, 0x0a
		DB		"load error"
		DB		0x0a
		DB		0

		RESB  0x1fe-($-$$) ; $は先頭からどこまで進んでいるか
											 ; $$はセクションの先頭
											 ; よって($-$$)でセクションののどこまで進んでいるかを出せる

		DB		0x55, 0xaa
