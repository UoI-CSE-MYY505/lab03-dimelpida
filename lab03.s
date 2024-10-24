# Conversion of RGB888 image to RGB565
# lab03 of MYY505 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

# This directive declares subroutines. Do not remove it!
.globl rgb888_to_rgb565, showImage

.data

image888:  # A rainbow-like image Red->Green->Blue->Red
    .byte 255, 0,     0
    .byte 255,  85,   0
    .byte 255, 170,   0
    .byte 255, 255,   0
    .byte 170, 255,   0
    .byte  85, 255,   0
    .byte   0, 255,   0
    .byte   0, 255,  85
    .byte   0, 255, 170
    .byte   0, 255, 255
    .byte   0, 170, 255
    .byte   0,  85, 255
    .byte   0,   0, 255
    .byte  85,   0, 255
    .byte 170,   0, 255
    .byte 255,   0, 255
    .byte 255,   0, 170
    .byte 255,   0,  85
    .byte 255,   0,   0
# repeat the above 5 times
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0

image565:
    .zero 512  # leave a 0.5Kibyte free space

.text
# -------- This is just for fun.
# Ripes has a LED matrix in the I/O tab. To enable it:
# - Go to the I/O tab and double click on LED Matrix.
# - Change the Height and Width (at top-right part of I/O window),
#     to the size of the image888 (6, 19 in this example)
# - This will enable the LED matrix
# - Uncomment the following and you should see the image on the LED matrix!
    la   a0, image888
    li   a1, LED_MATRIX_0_BASE
    li   a2, LED_MATRIX_0_WIDTH
    li   a3, LED_MATRIX_0_HEIGHT
    jal  ra, showImage
# ----- This is where the fun part ends!

    la   a0, image888
    la   a3, image565
    li   a1, 19 # width
    li   a2,  6 # height
    jal  ra, rgb888_to_rgb565

    addi a7, zero, 10 
    ecall

# ----------------------------------------
# Subroutine showImage
# a0 - image to display on Ripes' LED matrix
# a1 - Base address of LED matrix
# a2 - Width of the image and the LED matrix
# a3 - Height of the image and the LED matrix
# Caution: Assumes the image and LED matrix have the
# same dimensions!
showImage:
    add  t0, zero, zero # row counter
showRowLoop:
    bge  t0, a3, outShowRowLoop
    add  t1, zero, zero # column counter
showColumnLoop:
    bge  t1, a2, outShowColumnLoop
    lbu  t2, 0(a0) # get red
    lbu  t3, 1(a0) # get green
    lbu  t4, 2(a0) # get blue
    slli t2, t2, 16  # place red at the 3rd byte of "led" word
    slli t3, t3, 8   #   green at the 2nd
    or   t4, t4, t3  # combine green, blue
    or   t4, t4, t2  # Add red to the above
    sw   t4, 0(a1)   # let there be light at this pixel
    addi a0, a0, 3   # move on to the next image pixel
    addi a1, a1, 4   # move on to the next LED
    addi t1, t1, 1
    j    showColumnLoop
outShowColumnLoop:
    addi t0, t0, 1
    j    showRowLoop
outShowRowLoop:
    jalr zero, ra, 0

# ----------------------------------------

rgb888_to_rgb565:
# ----------------------------------------
    add t0, zero, zero #counter grammis
rowsloop: 
    bge t0,a2, endrloop #an t0>=a2 vges apo to loop 
    add t1, zero, zero # an den isxuei to parapanw dhl. an t0<a2 arx. counter sthlhs    
columnsloop: 
    bge t1, a1, endcloop #am  t1>=a1 vges apo to loop 
    
    lbu t2, 0(a0) #fortwnei byte apo diefth mnimis a0+0 ston t2 R
    lbu t3, 1(a0) #fortwnei byte apo a0+1 G
    lbu t3, 2(a0) #fortwnei apo a0+2 B
    
    andi t2, t2, 0xf8 #kanei logiko and ths timis tou R kanaliou kai tou arithmou 11111000 gia na diagrafoun ta teleutaia pshfia
    slli t2, t2,8 #olisthainei thn timh tou t2 8 theseis aristera gia na parw ta 5 msb
    
    andi t3, t3, 0xfc #kanei logiko and me timh tou G kai tou 11111100 gia na diagrapsei ta 2 lsb
    slli t3, t3, 3 # olisthainei 3 theseis aristera gia na mpoun ta 6 msb 
    
    andi t4, t4,0xf8 #logiko and tou B kai tou arithmou 11111000 gia na fugoun ta 3 lsb 
    slli t4, t4, 3
    
    or t2, t2, t3 #sundiazei tis times twn R kai G 
    or t2, t2, t4 
    
    sh t2, 0(a3) #apothikeuei th 16 bit timh tou t2 sth diefth pou deixnei o a3, opou einai o pinakas gia RGB565 
    addi a0,a0,3 #auksanei to a0 kata 3 (paei sto epomeno pixel ths RGB888)
    addi a3,a3,2 #auksanei to a3 kata 2 (paie sto epomeno pixel ths RGB565)
    addi t1,t1,1 #auksanei to metrith twn sthlwn kata 1(paei sthn epomenh sthlh)
    
    j columnsloop #ksanapaei sthn koryfi tou loop 
    
endcloop: #vgainei apo to columnsloop 
    addi t0,t0,1  #auksanei kata 1 ton row counter (paei sthn epomenh grammh )
    j rowsloop 
    
endrloop: #vgainei apo to rowsloop 
    
    jalr zero, ra, 0


