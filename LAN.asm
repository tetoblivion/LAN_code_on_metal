

%include "print.asm"
%include "serial.asm"

linkmsg      DB   10,13,"Link change",0

;right way to do this is to read
;x86 PCI configuration space.
;Alternatively go to
;Device Manager -> Network adapters->
;Resources  -> I/O Range
;to get these port addresses
%define  NIC1_base    0xE000
%define  NIC2_base    0xE400
%define  NIC3_base    0xE800

;Media Status Register
%define  MSR_offset     0x0058
;Bit 2, Inverse of Link status. 0 = Link OK. 1 = Link Fail.
%define  LINKB_bitmask  0x0004

%define  status1 0x7e20

linkStatusExample:

    mov dx,NIC1_base
    add dx,MSR_offset
    in ax,dx

    and ax,LINKB_bitmask
    mov [status1],ax

  nicmsr:

    call rebootOnKeypressOrSerial

    in ax,dx
    and ax,LINKB_bitmask
    cmp [status1],ax
    mov [status1],ax
    jz nicmsr

    mov si, linkmsg      ; our message to print
    call Print          ; call our print function
    call sendToSerial

    jmp nicmsr

    ;ret
