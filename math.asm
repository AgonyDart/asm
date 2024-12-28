; Operaciones Básicas
; Tinoco Duarte Angel David
; 16 de Febrero de 2024
.model small ; Generar código para un modelo de memoria pequeño
.stack ; Segmento de pila

.data ; Segmento de datos
  input db "Ingrese el primer carácter: ","$"
  input1 db "Ingrese el segundo carácter: ","$"
  jumper db 10,13,"$"
  suma db "Suma: ","$"
  resta db "Resta: ","$"
  mult db "Multiplicación: ","$"
  divi db "División: ","$"
  var1 db (?)
  var2 db (?)
  res db ?

.code ; Segmento de código
main PROC ; Inicio del procedimiento principal
  mov ax, @data ; Cargar segmento de datos en ax
  mov ds, ax ; Mover ax a ds

  lea dx, input ; Cargar dirección del mensaje input
  mov ah, 09 ; Imprimir cadena
  int 21h

  mov ah, 01 ; Leer carácter
  int 21h
  sub al, 30h ; Convertir ASCII a número
  mov var1, al ; Almacenar en var1

  mov dl, jumper ; Nueva línea
  mov ah, 02 ; Imprimir carácter
  int 21h

  lea dx, input1 ; Cargar dirección del mensaje input1
  mov ah, 09 ; Imprimir cadena
  int 21h

  mov ah, 01 ; Leer carácter
  int 21h
  sub al, 30h ; Convertir ASCII a número
  mov var2, al ; Almacenar en var2

  mov dl, jumper ; Nueva línea
  mov ah, 02 ; Imprimir carácter
  int 21h

  ; Suma
  mov al, var1
  add al, var2
  add al, 30h ; Convertir número a ASCII
  mov res, al

  lea dx, suma ; Cargar dirección del mensaje suma
  mov ah, 09 ; Imprimir cadena
  int 21h

  mov dl, res ; Imprimir resultado
  mov ah, 02
  int 21h

  mov dl, jumper ; Nueva línea
  mov ah, 02
  int 21h

  ; Resta
  mov al, var1
  sub al, var2
  add al, 30h ; Convertir número a ASCII
  mov res, al

  lea dx, resta ; Cargar dirección del mensaje resta
  mov ah, 09 ; Imprimir cadena
  int 21h

  mov dl, res ; Imprimir resultado
  mov ah, 02
  int 21h

  mov dl, jumper ; Nueva línea
  mov ah, 02
  int 21h

  ; Multiplicación
  mov al, var1
  mul var2
  add al, 30h ; Convertir número a ASCII
  mov res, al

  lea dx, mult ; Cargar dirección del mensaje mult
  mov ah, 09 ; Imprimir cadena
  int 21h

  mov dl, res ; Imprimir resultado
  mov ah, 02
  int 21h

  mov dl, jumper ; Nueva línea
  mov ah, 02
  int 21h

  ; División
  mov ax, 0
  mov al, var1
  div var2
  add al, 30h ; Convertir número a ASCII
  mov res, al

  lea dx, divi ; Cargar dirección del mensaje divi
  mov ah, 09 ; Imprimir cadena
  int 21h

  mov dl, res ; Imprimir resultado
  mov ah, 02
  int 21h

  mov ax, 4c00h ; Salir del programa
  int 21h
main ENDP ; Fin del procedimiento principal
END main ; Fin del programa a ensamblar
