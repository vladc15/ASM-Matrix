.data
	n: .space 4
	m: .space 400
	x: .space 4
	count: .long 0
	cerinta: .space 4  
	i: .long 0
	j: .long 0
	k: .long 0
	nr: .long 0
	matrix: .space 40000
	lung: .space 4
	sursa: .space 4
	destinatie: .space 4
	matrix_sol: .space 40000
	#matrix_sol1: .space 40000

	dimAloc: .long 0


	formatS: .asciz "%d"
	formatP: .asciz "%d "
	formatP1: .asciz "%d"
	formatP2: .asciz "%s"
	newline: .asciz "\n"
	
.text

.global main

matrix_mult:
	push %ebp
	mov %esp, %ebp
	
	#conventie: mai intai se pun registrii
	#apoi se creeaza var locale
	
	push %ebx
	push %edi
	push %esi
	
	
	#+12 la val de la minus de dinainte
	mov $0, %eax
	#fac o var locala pentru dim
	sub $4, %esp
	mov %eax, -16(%ebp)
	
	#i
	sub $4, %esp
	mov %eax, -20(%ebp)
	#j
	sub $4, %esp
	mov %eax, -24(%ebp)
	#k
	sub $4, %esp
	mov %eax, -28(%ebp)
	#aux1
	sub $4, %esp
	mov %eax, -32(%ebp)
	#aux2
	sub $4, %esp
	mov %eax, -36(%ebp)
	#aux3
	sub $4, %esp
	mov %eax, -40(%ebp)
	
	
	#mat1
	mov 8(%ebp), %edi
	#mat2
	mov 12(%ebp), %esi
	#mat_rez
	mov 16(%ebp), %ebx
	#dim / ult arg pus
	mov 20(%ebp), %eax
	mov %eax, -16(%ebp)
	
	
	#cod
	mov $0, %ecx
for1:	
	mov -20(%ebp), %ecx
	mov -16(%ebp), %eax
	cmp %ecx, %eax
	je final1
	
	
	mov $0, %eax
	mov %eax, -24(%ebp)
	for2:
		mov -24(%ebp), %ecx
		mov -16(%ebp), %eax
		cmp %ecx, %eax
		je final2
	
		
		mov $0, %eax
		mov %eax, -28(%ebp)
		for3:
			mov -28(%ebp), %ecx
			mov -16(%ebp), %eax
			cmp %ecx, %eax
			je final3	
			
			#c[i][j] += a[i][k] * b[k][j]
			
			#a[i][k]
			mov -20(%ebp), %eax
			mov $0, %edx
			mov -16(%ebp), %ecx
			mul %ecx
			add -28(%ebp), %eax
			mov (%edi, %eax, 4), %ecx
			#am a[i][k] in aux1 = -32(%ebp)
			mov %ecx, -32(%ebp)
			
			#b[k][j]
			mov -28(%ebp), %eax
			mov $0, %edx
			mov -16(%ebp), %ecx
			mul %ecx
			add -24(%ebp), %eax
			mov (%esi, %eax, 4), %ecx
			#am b[k][j] in aux2 = -36(%ebp)
			mov %ecx, -36(%ebp)
			
			#c[i][j]
			mov -20(%ebp), %eax
			mov $0, %edx
			mov -16(%ebp), %ecx
			mul %ecx
			add -24(%ebp), %eax
			mov %eax, -40(%ebp)
			#in aux3 am acum indexul din c
			#c[i][j] este la (%ebx, %eax, 4)
			
			mov -32(%ebp), %eax
			mov $0, %edx
			mov -36(%ebp), %ecx
			mul %ecx
			#am eax = a[i][k] * b[k][j]
			mov -40(%ebp), %ecx
			add %eax, (%ebx, %ecx, 4) 
			
		
			#k++
			mov -28(%ebp), %eax
			inc %eax
			mov %eax, -28(%ebp)
			jmp for3
		
		final3:
	
		#j++
		mov -24(%ebp), %eax
		inc %eax
		mov %eax, -24(%ebp)
		jmp for2
	
	final2:	
	
	#i++
	mov -20(%ebp), %eax
	inc %eax
	mov %eax, -20(%ebp)
	jmp for1

final1:
	
	#eliberarea spatiului var locale
	#esp += 4 * nr var locale
	add $28, %esp



	#restaurarea
	pop %esi
	pop %edi
	pop %ebx

	
	pop %ebp
	ret

main:

	#citirea
	push $cerinta
	push $formatS
	call scanf
	pop %ebx
	pop %ebx
	
	push $n
	push $formatS
	call scanf
	pop %ebx
	pop %ebx
	
	lea m, %esi
for_citire_nr_noduri:
	mov count, %ecx
	cmp %ecx, n
	je final_for_citire_nr_noduri

	push $x
	push $formatS
	call scanf
	pop %ebx
	pop %ebx

	mov x, %eax
	mov count, %ecx
	mov %eax, (%esi, %ecx, 4)
	
	inc %ecx
	mov %ecx, count
	jmp for_citire_nr_noduri

final_for_citire_nr_noduri:


	lea matrix, %edi	
for_citire_vecini_1:
	mov i, %ecx
	cmp %ecx, n
	je final_for_citire_vecini_1
	
	mov (%esi, %ecx, 4), %eax
	mov %eax, nr
	mov $0, %ecx
	mov %ecx, j
	for_citire_vecini_2:
		mov j, %ecx
		cmp %ecx, nr
		je final_for_citire_vecini_2
	
		push $x
		push $formatS
		call scanf
		pop %ebx
		pop %ebx
	
		#am i vecin cu x
		mov i, %eax
		mov $0, %edx
		mov n, %ecx
		mul %ecx
		add x, %eax
		
		mov $1, %ecx
		mov %ecx, (%edi, %eax, 4)
	
		mov j, %ecx
		inc %ecx
		mov %ecx, j
		jmp for_citire_vecini_2
	
	final_for_citire_vecini_2:

	mov i, %ecx
	inc %ecx
	mov %ecx, i
	jmp for_citire_vecini_1

final_for_citire_vecini_1:
	#acum am matricea de adiacenta

	mov cerinta, %ecx
	mov $1, %eax
	cmp %ecx, %eax
	je cerinta1
	
	#am cerinta 3
	
	push $lung
	push $formatS
	call scanf
	pop %ebx
	pop %ebx
	
	push $sursa
	push $formatS
	call scanf
	pop %ebx
	pop %ebx
	
	push $destinatie
	push $formatS
	call scanf
	pop %ebx
	pop %ebx
	
	#imi trebuie matrix^lung
	#din care iau matrix[sursa][destinatie]
	
	lea matrix_sol, %esi
	mov $0, %ecx
	mov %ecx, i
	for__1:
		mov i, %ecx
		cmp %ecx, n
		je final_for__1
	
		mov $0, %ecx
		mov %ecx, j
		for__2:
			mov j, %ecx
			cmp %ecx, n
			je final_for__2
		
			mov i, %eax
			mov $0, %edx
			mov n, %ecx
			mul %ecx
			add j, %eax
			mov (%edi, %eax, 4), %ecx
			mov %ecx, (%esi, %eax, 4)
			
			mov j, %ecx
			inc %ecx
			mov %ecx, j
			jmp for__2
		
		final_for__2:
	
		mov i, %ecx
		inc %ecx
		mov %ecx, i
		jmp for__1
	
	final_for__1:
	
	
	#cerinta 3 
	#trebuie sa aloc dinamic matrix_sol1
	
	#salvez registrii inainte de apel
	push %edi
	push %esi
	
	#determin dimensiunea de alocat - 4 * n * n
	mov n, %eax
	mov $0, %edx
	mov n, %ecx
	mul %ecx
	mov $0, %edx
	mov $4, %ecx
	mul %ecx
	mov %eax, dimAloc
	
	
	mov $192, %eax
	#codul pentru apelul de sistem
	
	mov $0, %ebx
	#NULL pentru a-si alege kernelul singur
	#la ce adresa sa aloce memorie
	
	mov dimAloc, %ecx
	#dimensiunea pe care o vrem alocata 
	#(maxim 4 * 100 * 100)
	
	mov $3, %edx
	#prot: PROT_READ | PROT_WRITE (adica 1 | 2 = 3)
	#pentru a putea citi si scrie in zona respectiva
	
	mov $0x22, %esi
	#map: MAP_ANONYMOUS | MAP_PRIVATE 
	#(adica 0x2 | 0x20 = 0x22), nefiind asociata 
	#cu vreun fisier sau file descriptor
	#si ca modificarile sa nu se transmita altor procese
	#care folosesc fisierul atasat (chiar daca, de fapt,
	#fisierul nu exista)
	#de asemenea, MAP_ANONYMOUS nu este suficient
	#pentru a lucra cu adresa obtinuta, este nevoie
	#sa precizam si ce se intampla cu modificarile facute
	
	mov $0, %edi
	dec %edi
	#file descriptor: -1 pentru anonymous mapping
	#pentru ca nu vom folosi un fisier anume
	
	mov $0, %ebp
	#offset-ul de unde sa inceapa = 0 (fara offset)
	
	int $0x80
	
	#rezultatul alocarii va fi in eax
	
	
	#recuperez registrii
	pop %esi
	pop %edi
	
	
	mov $0, %ecx
	mov %ecx, k
	mov lung, %ecx
	
	#lea matrix_sol1, %ebx
	#trebuie sa incarc adresa alocata
	
	mov %eax, %ebx

	
	#caz particular: lung = 0
	mov $0, %eax
	cmp %eax, %ecx
	je caz_part
	
	dec %ecx
	mov %ecx, lung
	
		
while:
	mov k, %ecx
	cmp %ecx, lung
	je final_while
	
	push n
	push %ebx
	push $matrix_sol
	push $matrix
	call matrix_mult
	pop %edx
	pop %edx
	pop %edx
	pop %edx
	
	#acum mut din matrix_sol1 in matrix_sol
	#si reinitializez matrix_sol1
	
	mov $0, %ecx
	mov %ecx, i
	for_1:
		mov i, %ecx
		cmp %ecx, n
		je final_for_1
	
		mov $0, %ecx
		mov %ecx, j
		for_2:
			mov j, %ecx
			cmp %ecx, n
			je final_for_2
		
			mov i, %eax
			mov $0, %edx
			mov n, %ecx
			mul %ecx
			add j, %eax
			mov (%ebx, %eax, 4), %ecx
			mov %ecx, (%esi, %eax, 4)
			mov $0, %ecx
			mov %ecx, (%ebx, %eax, 4)
		
			mov j, %ecx
			inc %ecx
			mov %ecx, j
			jmp for_2
		
		final_for_2:
	
		mov i, %ecx
		inc %ecx
		mov %ecx, i
		jmp for_1
	
	final_for_1:
	
	mov k, %ecx
	inc %ecx
	mov %ecx, k
	jmp while
	
final_while:
	
	#acum am matrix_sol = matrix^lung
	mov sursa, %eax
	mov $0, %edx
	mov n, %ecx
	mul %ecx
	add destinatie, %eax
	mov (%esi, %eax, 4), %ecx
	
	push %ecx
	push $formatP1
	call printf
	pop %edx
	pop %edx
	
	push $0
	call fflush
	pop %edx
	
	#eliberarea memoriei alocate cu munmap
	
	mov $91, %eax
	#codul pentru apelul de sistem
	
	#in %ebx trebuie adresa 
	#pe care o am deja
	
	mov dimAloc, %ecx
	#in %ecx trebuie dimensiunea 
	
	int $0x80 
	

	jmp exit
	
caz_part:

	#daca sursa = destinatie, atunci rasp este 1
	#altfel 0
	
	mov sursa, %eax
	mov destinatie, %ecx
	cmp %eax, %ecx
	je rasp1
	
	mov $0, %ecx
	
	push %ecx
	push $formatP1
	call printf
	pop %edx
	pop %edx
	
	push $0
	call fflush
	pop %edx
	
	#eliberarea memoriei alocate cu munmap
	
	mov $91, %eax
	#codul pentru apelul de sistem
	
	#in %ebx trebuie adresa 
	#pe care o am deja
	
	mov dimAloc, %ecx
	#in %ecx trebuie dimensiunea 
	
	int $0x80 
	
	
	jmp exit
rasp1:

	mov $1, %ecx
	
	push %ecx
	push $formatP1
	call printf
	pop %edx
	pop %edx
	
	push $0
	call fflush
	pop %edx

	#eliberarea memoriei alocate cu munmap
	
	mov $91, %eax
	#codul pentru apelul de sistem
	
	#in %ebx trebuie adresa 
	#pe care o am deja
	
	mov dimAloc, %ecx
	#in %ecx trebuie dimensiunea 
	
	int $0x80


	jmp exit
	
		

cerinta1:
	#am de afisat matricea
	
	mov $0, %ecx
	mov %ecx, i
for_afis1:
	mov i, %ecx
	cmp %ecx, n
	je final_for_afis1
	
	mov $0, %ecx
	mov %ecx, j
	for_afis2:
		mov j, %ecx
		cmp %ecx, n
		je final_for_afis2

		mov i, %eax
		mov $0, %edx
		mov n, %ecx
		mul %ecx
		add j, %eax
		
		mov (%edi, %eax, 4), %ecx
		push %ecx
		push $formatP
		call printf
		pop %ebx
		pop %ebx
		
		push $0
		call fflush
		pop %ebx

		mov j, %ecx
		inc %ecx
		mov %ecx, j
		jmp for_afis2

	final_for_afis2:

	#mov $4, %eax
	#mov $1, %ebx
	#mov $newline, %ecx
	#mov $2, %edx
	#int $0x80
	
	push $newline
	push $formatP2
	call printf
	pop %ebx
	pop %ebx
	
	push $0
	call fflush
	pop %ebx

	mov i, %ecx
	inc %ecx
	mov %ecx, i
	jmp for_afis1

final_for_afis1:


	jmp exit

exit:
	
	mov $1, %eax
	mov $0, %ebx
	int $0x80