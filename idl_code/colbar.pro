PRO colbar, coords, levs, title, LEFT=left, RIGHT=right, $
           UP=up, DOWN=down, TEXTPOS=textpos, ALT=alt
;Simple colourbar program using lines, text and polygons
;AJH Feb 2006

;Variable assigment and some basic checks
IF (N_ELEMENTS(coords) NE 4) THEN BEGIN
  PRINT, 'colbar - coords not defined correctly'
  PRINT, 'need 4 elements, received ', STRTRIM(N_ELEMENTS(coords),2)
  RETURN
ENDIF
x0=coords(0)
y0=coords(1)
x1=coords(2)
y1=coords(3)
IF (N_ELEMENTS(alt) EQ 0) THEN alt=0
IF (N_ELEMENTS(left) EQ 0) THEN left=0
IF (N_ELEMENTS(right) EQ 0) THEN right=0
IF (N_ELEMENTS(up) EQ 0) THEN up=0
IF (N_ELEMENTS(down) EQ 0) THEN down=0
IF (N_ELEMENTS(textpos) EQ 0) THEN textpos=0

ydiff=y1-y0
xdiff=x1-x0
IF (xdiff LE 0) THEN BEGIN
  PRINT, 'colbar - X1 must be > X0'
  RETURN
ENDIF

IF (ydiff LE 0) THEN BEGIN
  PRINT, 'colbar - Y1 must be > Y0'
  RETURN
ENDIF

ncontour=N_ELEMENTS(levs)-1
IF (ncontour LE 1) THEN BEGIN
  PRINT, 'colbar - Number of levels must be >2'
  RETURN
ENDIF

ntitle=N_ELEMENTS(title)-1
IF (ntitle NE 0) THEN BEGIN
  PRINT, 'colbar - Must have a title'
  RETURN
ENDIF

;Some plot definitions
!X.STYLE = 1
!Y.STYLE = 1
!P.NOERASE = 1
!P.REGION = [x0,y0,x1,y1]


;;;;Horizontal colourbar
IF (xdiff GT ydiff) THEN BEGIN
nticks=ncontour
IF (left) THEN nticks=nticks-1
IF (right) THEN nticks=nticks-1

xint = xdiff/ncontour
yint = 0.25*ydiff
xstart=x0
icol=2

IF (left) THEN BEGIN
xpts=[x0, x0+xint, x0+xint, x0]
ypts=[y1-yint/2,y1,y1-yint,y1-yint/2]
POLYFILL, xpts, ypts, COLOR=icol, /NORMAL
PLOTS, xpts, ypts, /NORMAL
xstart=xstart+xint
icol=icol+1
ENDIF

FOR ix=0, nticks-1 DO BEGIN
  myx=xstart+ix*xint
  xpts=[myx, myx+xint, myx+xint, myx, myx]
  ypts=[y1,y1, y1-yint,y1-yint,y1]
  POLYFILL, xpts, ypts, COLOR=icol+ix, /NORMAL
  PLOTS, xpts, ypts, /NORMAL 
  mylev=STRTRIM(STRING(levs(ix+icol-2)),2)
  IF (ALT EQ 0) THEN BEGIN
    XYOUTS, myx, y0+yint*1.35,mylev , ALIGNMENT=0.5, /NORMAL
  ENDIF ELSE BEGIN
    IF (ix MOD 2 EQ 0) THEN BEGIN
      XYOUTS, myx, y0+yint*1.35,mylev , ALIGNMENT=0.5, /NORMAL
    ENDIF ELSE BEGIN
      XYOUTS, myx, y1+yint*0.75,mylev , ALIGNMENT=0.5, /NORMAL
    ENDELSE
  ENDELSE  
ENDFOR
myx=xstart+nticks*xint
mylev=STRTRIM(STRING(levs(ix+icol-2)),2)
IF (ALT EQ 0) THEN BEGIN
  XYOUTS, myx, y0+yint*1.35, mylev, ALIGNMENT=0.5, /NORMAL
ENDIF ELSE BEGIN
   IF (ix MOD 2 EQ 0) THEN BEGIN
      XYOUTS, myx, y0+yint*1.35,mylev , ALIGNMENT=0.5, /NORMAL
    ENDIF ELSE BEGIN
      XYOUTS, myx, y1+yint*0.75,mylev , ALIGNMENT=0.5, /NORMAL
    ENDELSE
ENDELSE

IF (right) THEN BEGIN
xpts=[x1-xint, x1, x1-xint, x1-xint]
ypts=[y1,y1-yint/2.0,y1-yint,y1]
POLYFILL, xpts, ypts, COLOR=icol+nticks, /NORMAL
PLOTS, xpts, ypts, /NORMAL
ENDIF

xstart=x0-xint
mystart=0
IF (left) THEN BEGIN
  mystart=1
ENDIF


;Add the title
XYOUTS, x0+xdiff/2, y0, title, ALIGNMENT=0.5, /NORMAL

;Reset the position
!P.POSITION = 0

ENDIF


;;;;Vertical colourbar
IF (ydiff GT xdiff) THEN BEGIN
nticks=ncontour
IF (up) THEN nticks=nticks-1
IF (down) THEN nticks=nticks-1

yint = ydiff/ncontour
xint = 0.25*xdiff
ystart=y0
icol=2

IF (down) THEN BEGIN
xpts=[x0+xint/2, x0, x0+xint, x0+xint/2]
ypts=[y0,y0+yint,y0+yint,y0]
POLYFILL, xpts, ypts, COLOR=icol, /NORMAL
PLOTS, xpts, ypts, /NORMAL
ystart=ystart+yint
icol=icol+1
ENDIF

myalign=1.0
myx=x0-xint*0.25
IF TEXTPOS then myalign=0.0
IF TEXTPOS THEN myx=x0+xint*1.25
FOR iy=0, nticks-1 DO BEGIN
  myy=ystart+iy*yint
  xpts=[x0, x0, x0+xint, x0+xint, x0]
  ypts=[myy,myy+yint, myy+yint, myy, myy]
  POLYFILL, xpts, ypts, COLOR=icol+iy, /NORMAL
  PLOTS, xpts, ypts, /NORMAL 
  myy=ystart+iy*yint
  mylev=STRTRIM(STRING(levs(iy+icol-2)),2)
  XYOUTS, myx, myy-0.005, mylev, ALIGNMENT=myalign, /NORMAL
ENDFOR
myy=ystart+nticks*yint
mylev=STRTRIM(STRING(levs(iy+icol-2)),2)
XYOUTS, myx, myy-0.005, mylev, ALIGNMENT=myalign, /NORMAL


IF (up) THEN BEGIN
xpts=[x0+xint/2, x0, x0+xint, x0+xint/2]
ypts=[y1,y1-yint,y1-yint,y1]
POLYFILL, xpts, ypts, COLOR=icol+nticks, /NORMAL
PLOTS, xpts, ypts, /NORMAL
ENDIF

;Add the title
XYOUTS, x0+xint/2, y0-ydiff/10, title, ALIGNMENT=0.5, /NORMAL


!P.POSITION = 0

ENDIF

END


