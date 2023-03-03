## **Revisão Ciclos for e while**

O objetivo deste notebook é fazer uma revisão dos ciclos for e while. 


```python
# Vamos criar um algoritmo para fazer a tabuada

num = int(input('Digite um número: '))

for i in range(0, 11):
    print('{}x{}={}'.format(num, i, num*i))
```

    Digite um número: 6
    6x0=0
    6x1=6
    6x2=12
    6x3=18
    6x4=24
    6x5=30
    6x6=36
    6x7=42
    6x8=48
    6x9=54
    6x10=60
    


```python
# Vamos criar uma função para ler a tabuada:

def tabuada(x):
    x 
    
    for y in range(0,11):
        print('{}x{}={}'.format(x, y, x*y))
```


```python
# Testando a função

tabuada(3)
```

    3x0=0
    3x1=3
    3x2=6
    3x3=9
    3x4=12
    3x5=15
    3x6=18
    3x7=21
    3x8=24
    3x9=27
    3x10=30
    


```python
# Vamos criar uma função para encotrar as raízes de uma equação de segundo grau

def segundo_grau(a,b,c):
    delta = b**2 - 4*a*c
    
    if a == 0:
        print('Esta não é uma equação do segundo grau.')
        
    x1 = (-b + delta**0.5)/(2*a)
    x2 = (-b - delta**0.5)/(2*a)
        
    
    if delta < 0:
        print('Esta equação não possui raízes reais.')
    else:
        print('As raízes da equação de segundo grau são x1 = {:.3f} e x2 = {:.3f}.'.format(x1, x2))
```


```python
# Testando a função para a equação do segundo grau

segundo_grau(1,3,1)
```

    As raízes da equação de segundo grau são x1 = -0.382 e x2 = -2.618.
    


```python
# Ciclo while

for c in range(1,10,2):
    print(c)
```

    1
    3
    5
    7
    9
    


```python
c = 1

while c < 10:
    print(c)
    c = c + 1
print('Fim')
```

    1
    2
    3
    4
    5
    6
    7
    8
    9
    Fim
    


```python
# Vamos somar e multiplicar os números que são divisíveis por 3 no intervalo de 15 a 60

soma = 0
produto = 1

for i in range(15, 61):
    if i % 3 == 0:
        soma = soma + i
        produto = produto * i
        
print('A soma foi de {} e o produto de {}.'.format(soma, produto))
```

    A soma foi de 600 e o produto de 4363685581929980866560000.
    


```python
n = 1

while n != 0:
    n = int(input('Digite um número: '))
    
print('Fim.')
```

    Digite um número: 1
    Digite um número: 2
    Digite um número: 3
    Digite um número: 3
    Digite um número: 3
    Digite um número: 0
    Fim.
    


```python
r = 'S'

while r == 'S':
    n = int(input('Digite um valor: '))
    r = str(input('Quer continuar? [s/n]')).upper()
print('Fim.')
```

    Digite um valor: 2
    Quer continuar? [s/n]s
    Digite um valor: 3
    Quer continuar? [s/n]n
    Fim.
    


```python
n = 1
par = impar = 0

while n != 0:
    n = int(input('Digite um valor: '))
    if n != 0:
        if n % 2 == 0:
            par = par + 1
        else:
            impar = impar + 1
        
print('Você digitou {} números pares e {} números ímpares!'.format(par, impar))
```

    Digite um valor: 2
    Digite um valor: 3
    Digite um valor: 3
    Digite um valor: 3
    Digite um valor: 3
    Digite um valor: 3
    Digite um valor: 5
    Digite um valor: 0
    Você digitou 1 números pares e 6 números ímpares!
    


```python

```
