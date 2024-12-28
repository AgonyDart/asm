; Display
; Angel David Tinoco Duarte
; 24-Mayo-2024

rect MACRO c, x, y, tx, ty
    LOCAL fila, columna
    mov ah, 0Ch
    mov al, c ; color
    mov bh, 00h

    ; bucle para las filas
    mov dx, y ; coordenada y inicial
    fila:
        ; bucle para las columnas
        mov cx, x ; coordenada x inicial
        columna:
            ; llamar a la interrupción
            int 10h

            ; incrementar la coordenada x
            inc cx
            cmp cx, tx ; coordenada x final
            jl columna

        ; incrementar la coordenada y
        inc dx
        cmp dx, ty ; coordenada y final
        jl fila
ENDM

.model small
.stack
.data
cadena1 db 'Jasiel Huerta$'
cadena2 db "Angel Duarte", "$"
new_l db 10, 13

.code
main PROC
    mov ax, @data ; cargar el segmento de datos al registro ax
    mov ds, ax

    ; inicializar el modo de video
    mov ah, 0
    mov al, 13h
    int 10h

    ; fondo
    rect 01h, 10, 50, 310, 192

     ; A
    rect 10, 64, 55, 66, 72
    rect 10, 64, 55, 70, 57
    rect 10, 64, 63, 70, 65
    rect 10, 70, 55, 72, 72

    ; N
    rect 10, 76, 55, 78, 72
    rect 10, 76, 55, 84, 57
    rect 10, 84, 55, 86, 72

    ; G
    rect 10, 90, 55, 98, 57
    rect 10, 95, 62, 100, 64
    rect 10, 90, 70, 100, 72
    rect 10, 90, 57, 92, 72
    rect 10, 98, 64, 100, 72

    ; E
    rect 10, 104, 55, 114, 57
    rect 10, 104, 62, 114, 64
    rect 10, 104, 70, 114, 72
    rect 10, 104, 55, 106, 72

    ; L
    rect 10, 118, 55, 120, 72
    rect 10, 118, 70, 128, 72

    ; D minuscula
    rect 10, 132, 63, 134, 72
    rect 10, 132, 63, 138, 65
    rect 10, 138, 55, 140, 72
    rect 10, 132, 70, 140, 72

    ; finalizar programa
    mov ax, 4C00h
    int 21h
main ENDP
END main