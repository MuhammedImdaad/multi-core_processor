#python file to generate input data and read and display output data

R1 = int(input("Enter the number of rows in mat1:"))
C1 = int(input("Enter the number of columns in mat1:"))
R2 = int(input("Enter the number of rows in mat2:"))
C2 = int(input("Enter the number of columns in mat2:"))

if (C1!=R2):
    print("two matrix can't multiply")
    exit()

p = R1*C1
q = R2*C2
r = R1*C2
Out_M1 = []
Out_M2 = []

if (p<=16 and q<=16):#size check
    print("\nEnter the element in mat1")
    mat1 = [list(map(int, input().split())) for y in range(R1)]
    print("\nEnter the element in mat2")
    mat2 = [list(map(int, input().split())) for y in range(R2)]

    for i in mat1:
        if (len(i)==C1):
            for k in i:
                if (k>=-8191 and k<=8191): #value check 32*(X)^2 = (2)^32/2
                    Out_M1.append(k)
                else:
                    print ('result could overflow')
                    exit()
        else:
            print("wrong input matrix 1")
            exit()
    while len(Out_M1)<16:
        Out_M1.append(0)
        
    for i in range(C2):
        for k in range(R2):
            if (len(mat2[k])==C2):
                if (mat2[k][i]>=-8191 and mat2[k][i]<=8191):#value check
                    Out_M2.append(mat2[k][i])
                else:
                    print ('result could overflow')
                    exit()
            else:
                print("wrong input matrix 2")
                exit()               
    while len(Out_M2)<32:
        Out_M2.append(0)
    L = Out_M1 + Out_M2           
    
    
    textfile1 = open("input.txt", "w")
    for element in L: 
        textfile1. write('%d\n' % element)
    textfile1. write('%d\n' % R1)
    textfile1. write('%d\n' % C1)
    textfile1. write('%d\n' % C2)
    textfile1. close()
    
else:
    print('Matrix is too large')
    exit()

#This waits until the process is finished and output file gets generated to display the output
while True:
    Is_OK = str(input("\nIf Processor is Finished, Type \"ok\":"))
    if (Is_OK == "ok"):
        result = []
        i = 0
        print("\nresultant matrix")     
        with open('output.txt','r') as outfile:
            for line in outfile:
                result.append(line.strip())
        while (i<r):
            print(" ".join(result[i:i+C2]))  
            i+=C2;
        break