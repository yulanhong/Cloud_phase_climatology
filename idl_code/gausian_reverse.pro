function gausian_reverse,x
;A=[50.6103,0.0201921,0.00687019]
;A=[4.15691,0.122857,0.0903068]
;A=[25.2884,294.391,1.53712]
;A=[9.52465,-1.91568,0.412569]
; for whole domain
A=[44.8851,0.0202342,0.00780334]; for reflect0.645
A=[4.24423,0.126054,0.087827]
A=[22.315,294.481,1.71531]
A=[8.9626,-2.0204,0.442501]
print,A[1]+A[2]*sqrt(0-2*alog(x/A[0]))

end
