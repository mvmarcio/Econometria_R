#!/usr/bin/env python
# coding: utf-8

# ## **Revisão Ciclos for e while**
# 
# O objetivo deste notebook é fazer uma revisão dos ciclos for e while. 

# In[4]:


# Vamos criar um algoritmo para fazer a tabuada

num = int(input('Digite um número: '))

for i in range(0, 11):
    print('{}x{}={}'.format(num, i, num*i))


# In[30]:


# Vamos criar uma função para ler a tabuada:

def tabuada(x):
    x 
    
    for y in range(0,11):
        print('{}x{}={}'.format(x, y, x*y))


# In[31]:


# Testando a função

tabuada(3)


# In[28]:


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


# In[29]:


# Testando a função para a equação do segundo grau

segundo_grau(1,3,1)


# In[33]:


# Ciclo while

for c in range(1,10,2):
    print(c)


# In[34]:


c = 1

while c < 10:
    print(c)
    c = c + 1
print('Fim')


# In[35]:


# Vamos somar e multiplicar os números que são divisíveis por 3 no intervalo de 15 a 60

soma = 0
produto = 1

for i in range(15, 61):
    if i % 3 == 0:
        soma = soma + i
        produto = produto * i
        
print('A soma foi de {} e o produto de {}.'.format(soma, produto))


# In[36]:


n = 1

while n != 0:
    n = int(input('Digite um número: '))
    
print('Fim.')


# In[37]:


r = 'S'

while r == 'S':
    n = int(input('Digite um valor: '))
    r = str(input('Quer continuar? [s/n]')).upper()
print('Fim.')


# In[41]:


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


# In[ ]:




