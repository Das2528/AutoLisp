

(DEFUN GetTblLayer (/ layer lisLay)
  (SETQ layer (TBLNEXT "LAYER" T));; en este caso la T indica q iniciara desde el primer registro 
  (SETQ lisLay '())
  (while layer 
    (SETQ lisLay (APPEND lisLay (LIST layer)))
    (SETQ layer (TBLNEXT "LAYER" ))
  )
  lisLay
) 

(DEFUN ActivateLayer(/ item lis name idLayer layer estado color)
  (setq lis (GetTblLayer))
  (FOREACH item lis
    (print (setq name (cdr (assoc 2 item)))); nombre del layer 
    (if (equal "0" name)
      (progn ; si  
        (command "-LAYER" "SET" "0" "") ; cambia a alayer 0 como el activo 
      )
      (progn ;si no 
        ;(print item)
        (setq idLayer (tblobjname "LAYER" name)); id del layer 
        (setq layer (entget idLayer )); opteniendo la enntidad 
        (setq estado (cdr (assoc 70 layer)))
        (setq color (cdr (assoc 62 layer)))
        (if(/= estado  0 )        
          (progn
            (setq layer (subst (cons 70 0) (assoc 70 layer) layer ))
            (entmod layer )
            (entupd idLayer)
          )         
        )
        (if(< color 0)
          (progn 
            (setq color (* -1 color))
            (setq layer (subst (cons 62 color) (assoc 62 layer) layer ))
            (entmod layer )
            (entupd idLayer)
            (princ)
          )
        )
      )    
    )
  )
)
 
    





(DEFUN imp(lis / i)
(FOREACH i lis
(PRINT i)
  (PRINC)

)
)




