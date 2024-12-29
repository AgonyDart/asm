; Juego de la Serpiente (Snake) en TASM

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
.stack 100h
.data
; Variables de la serpiente
x_pos dw 100          ; Posición X inicial de la serpiente
y_pos dw 100         ; Posición Y inicial de la serpiente
direction db 'd'     ; Dirección inicial ('w', 'a', 's', 'd')
snake_length dw 24    ; Longitud inicial de la serpiente
max_snake_length dw 64 ; Longitud máxima de la serpiente
; Array de posiciones de la serpiente
snake_pos_x dw 8 dup(0)
snake_pos_y dw 8 dup(0)

; Variables de comida
food_x dw 50          ; Posición X de la comida
food_y dw 50          ; Posición Y de la comida

; Mensajes
msg_game_over db 'Game Over!$'
msg_win db 'You Win!$'

.code
main PROC
    mov ax, @data ; cargar el segmento de datos al registro ax
    mov ds, ax

    ; inicializar el modo de video
    mov ah, 0
    mov al, 13h
    int 10h

    call draw_borders
main_loop:
    ; dibujar comida
    call draw_food

    ; dibujar la serpiente
    call draw_snake

    ; leer la entrada del usuario
    call read_input

    ; Borrar la serpiente de su posición anterior
    call clear_snake

    ; actualizar la posición de la serpiente
    call update_position

    ; Comprobar colisiones
    call check_collisions

    ; Comprobar si se comió la comida
    call check_food

    ; Temporización
    call delay

    ; Repetir el ciclo
    jmp main_loop

; Dibujar los bordes del campo de juego
draw_borders:
    ; dibujar las paredes en azul (color 1)
    ; Parte superior
    rect 1, 0, 0, 319, 7      ; Pared superior (de 0,0 a 319,2)
    ; Parte inferior
    rect 1, 0, 193, 319, 200  ; Pared inferior (de 0,198 a 319,200)
    ; Parte izquierda
    rect 1, 0, 0, 7, 199      ; Pared izquierda (de 0,0 a 1,199)
    ; Parte derecha
    rect 1, 313, 0, 319, 199  ; Pared derecha (de 318,0 a 319,199)

    ret

; Dibujar la comida
draw_food:
    ; dibujar la comida en rojo (color 4)
    mov si, food_x
    mov di, food_y
    add si, 8
    add di, 8
    rect 4, food_x, food_y, si, di
    ret

; Dibujar la serpiente
draw_snake:
    ; dibujar la serpiente en verde (color 2)
    ; if snake_length = 8, draw 1 block
    mov si, x_pos
    mov di, y_pos
    add si, 8
    add di, 8
    rect 2, x_pos, y_pos, si, di
    ret
    ;


; Borrar la serpiente de su posición anterior
clear_snake:
    ; borrar la serpiente
    mov si, x_pos
    mov di, y_pos
    add si, snake_length
    add di, 8
    rect 0, x_pos, y_pos, si, di
    ret

; Leer la entrada del usuario
read_input:
    ; leer la tecla presionada
    mov ah, 00h
    int 16h

    ; actualizar la dirección de la serpiente
    mov direction, al
    ret

; Actualizar la posición de la serpiente
update_position:
    ; comprobar la dirección actual
    cmp direction, 'w' ; arriba
    je move_up
    cmp direction, 'a' ; izquierda
    je move_left
    cmp direction, 's' ; abajo
    je move_down
    cmp direction, 'd' ; derecha
    je move_right
    ret

; Mover hacia arriba
move_up:
    ; decrementar la posición Y
    sub y_pos, 1
    ret

; Mover hacia la izquierda
move_left:
    ; decrementar la posición X
    sub x_pos, 1
    ret

; Mover hacia abajo
move_down:
    ; incrementar la posición Y
    add y_pos, 1
    ret

; Mover hacia la derecha
move_right:
    ; incrementar la posición X
    add x_pos, 1
    ret

; Comprobar colisiones
check_collisions:
    ; comprobar si la serpiente choca con las paredes
    cmp x_pos, 8
    je game_over
    cmp x_pos, 312
    je game_over
    cmp y_pos, 8
    je game_over
    cmp y_pos, 192
    je game_over
    ret

game_over:
    ; mostrar el mensaje de Game Over
    mov ah, 09h
    lea dx, msg_game_over
    int 21h

    ; salir del programa
    mov ah, 4Ch
    int 21h

    ret

; Comprobar si la serpiente se comió la comida
check_food:
    ; Cargar valores de las posiciones en registros
    mov ax, x_pos       ; Cargar la posición X de la serpiente en al
    mov bx, food_x      ; Cargar la posición X de la comida en bl
    cmp ax, bx            ; Comparar las posiciones X
    jne .skip_x_check     ; Si no son iguales, saltar a la comprobación Y

    ; Si las posiciones X coinciden, comprobar la posición Y
    mov ax, y_pos      ; Cargar la posición Y de la serpiente en al
    mov bx, food_y      ; Cargar la posición Y de la comida en bl
    cmp ax, bx            ; Comparar las posiciones Y
    jne .skip_y_check     ; Si no son iguales, saltar

    ; Si las posiciones X e Y coinciden, la serpiente comió la comida

    ; Mostrar que ganaste
    mov ah, 09h
    lea dx, msg_win
    int 21h

    ; Salir del programa
    mov ah, 4Ch
    int 21h

    ret

    add snake_length, 8   ; Incrementar la longitud de la serpiente
    call clear_food       ; Borrar la comida
    call generate_food    ; Generar nueva comida
    call draw_food        ; Dibujar la nueva comida

.skip_y_check:
.skip_x_check:
    ret


; Borrar la comida
clear_food:
    ; borrar la comida
    mov si, food_x
    mov di, food_y
    add si, 8
    add di, 8
    rect 0, food_x, food_y, si, di
    ret

; Generar nueva comida
generate_food:
    ; Generar un número aleatorio para la coordenada X
    mov ah, 00h          ; Función para obtener el valor del reloj (random)
    int 1Ah              ; Llamada a la interrupción 1Ah para obtener el tiempo
    mov ax, dx           ; Almacenar los 16 bits bajos del reloj en AX (usaremos este valor como semilla)
    and ax, 7Fh          ; Asegurarse de que el valor esté en un rango limitado (por ejemplo, 0-127)
    mov food_x, ax       ; Almacenar el valor generado como la nueva posición X de la comida

    ; Generar un número aleatorio para la coordenada Y
    mov ah, 00h          ; Función para obtener el valor del reloj (random)
    int 1Ah              ; Llamada a la interrupción 1Ah para obtener el tiempo
    mov ax, dx           ; Almacenar los 16 bits bajos del reloj en AX
    and ax, 7Fh          ; Asegurarse de que el valor esté en un rango limitado (por ejemplo, 0-127)
    mov food_y, ax       ; Almacenar el valor generado como la nueva posición Y de la comida

    ret


; Temporización
delay:
    mov cx, 0FFFFh       ; Contador de tiempo
.delay_loop:
    loop .delay_loop     ; Bucle de temporización
    ret

main ENDP
END main
