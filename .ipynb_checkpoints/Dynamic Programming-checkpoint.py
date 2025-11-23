import math
def memorized_rod_cutter(n,p):
    for i in range(0,n+1):
        r[i]=-math.inf
    if r[n]>=0:
        return 
