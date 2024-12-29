; Suma de vector
; Tinoco Duarte Angel David
; 06 de Diciembre del 2023

.model small
.stack 200H

.data
tabla db "0123456789abcdef"
jumper db 10,13,"$"
saludo db "Este programa suma un vector de tamano N","$"
nombre db "Angel","$"
result db "El resultado es: ","$"
resultHex db "El resultado en Hexadecimal es: ","$"
resultBin db "El resultado en Binario es: ","$"
entrada db "Introduce un numero:  ","$"
tamIn db "Introduce el tamano del vector: ","$"
vector db 10 dup(?)
m db 0
res db (?)
mh db (?)
ascii db (?)
ml db (?)

.code
main proc

  ; Inicializa segmento de datos
  mov ax, @data
  mov ds, ax
  
  ; Muestra saludo
  mov ah, 09
  lea dx, saludo
  int 21h
  
  ; Nueva línea
  mov dl, jumper
  mov ah, 02
  int 21h
  
  ; Muestra nombre
  mov ah, 09
  lea dx, nombre
  int 21h
  
  ; Solicita tamaño del vector
  mov ah, 09
  lea dx, tamIn
  int 21h
  
  ; Lee tamaño del vector
  mov ah, 01
  int 21h
  sub al, '0'
  mov ah, 0    
  mov cx, ax
  
  ; Salto de línea
  mov dh, 03H
  mov dl, 00H
  mov ah, 02H
  int 10h
   
  lea di, vector 
  mov si, 0
  mov bx, 0

inLoop:
  ; Solicita entrada de número
  mov ah, 09
  lea dx, entrada
  int 21h

  ; Lee número y lo convierte
  mov ah, 01
  int 21h
  sub al, '0'
  mov [di], al
  inc di
  inc si
  inc bx
  
  ; Salto de línea
  mov ah, 02h
  mov dl, 0dh
  int 21h
  mov dl, 0ah
  int 21h
  
  loop inLoop
  
  ; Suma los elementos del vector
  mov cx, bx
  mov bx, 0
  mov al, 0

next:
  add al, vector[bx]
  inc bx
  loop next
  
  mov m, al
  mov mh, al
  mov ml, al
  
  ; Nueva línea
  mov dl, jumper
  mov ah, 02
  int 21h
  
  ; Muestra resultado en binario
  mov ah, 09
  lea dx, resultBin
  int 21h
  
  mov bl, m
  mov cx, 8

imprimir:
  mov ah, 2 
  mov dl, '0'
  test bl, 10000000b
  jz hex
  mov dl, '1'
hex:
  int 21h
  shl bl, 1
  loop imprimir
  
  ; Nueva línea
  mov dl, jumper
  mov ah, 02
  int 21h
  
  ; Muestra resultado en hexadecimal
  mov ah, 09
  lea dx, resultHex
  int 21h
  
  shr mh, 4
  
  mov bx, offset tabla
  mov al, mh
  xlat
  mov ascii, al
  
  mov dl, ascii
  mov ah, 02h
  int 21h
  
  and ml, 0fh
  
  mov bx, offset tabla
  mov al, ml
  xlat
  mov ascii, al
  
  mov dl, ascii
  mov ah, 02h
  int 21h
  
  ; Termina el programa
  mov ax, 4c00h
  int 21h

main endp
end main