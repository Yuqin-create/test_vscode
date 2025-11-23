import numpy as np
import math
def memorized_rod_cutter(n,p):
    for i in range(0,n+1):
        r[i]=-math.inf
    if r[n]>=0:
        return memorized_cut_rod_aux(p,n,r)
def memorized_cut_rod_aux(p,n,r):
    if r[n-1]>=0:
        return r[n-1]
    if n==0:
        q=0
    else q=-math.inf
        for i in range(1,n+1):
            q=max(q,p[i]+memorized_cut_rod_aux(p,n-i,r))
    r[n]=q
    return q
def bottom_up_cut_rod(p,n):
    r=np.zeros(n)
    s=np.zeros(n)
    for j in range(n-1):
        q=-math.inf
        for i in range(j-1):
            if q<p[i]+r[j-i]:
                q=p[i]+r[j-i]
                s[j]=i
        r[j]=q
    return r,s
def print_bu_cut_rod_solution(p,n):
    (r,s)=bottom_up_cut_rod(p,n)
    while n>0:
        print s[n]
        n-=s[]

n=[1,2,3,4,5,6,7,8,9,10]
p=[1,5,8,9,10,17,17,20,24,30]
print_bu_cut_rod_solution(p,n)

