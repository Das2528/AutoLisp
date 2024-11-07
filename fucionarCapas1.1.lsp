

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
 
 (defun filterNameLayer ()
    (setq lis (GetTblLayer))
    (setq lisName '())
    (setq lisNameWithoutPrefix '())
    (setq listAllLayerGroup '())
    (setq layerGroupByLayerName '())
   ;; captura tods los nomre de los layer 
    (foreach item lis
      (setq name (cdr (assoc 2 item )))
      (setq lisName (append lisName (list name)))
      
    )
    (if (> (length lisName) 0)
      ;; capturara nombre sim prefijos caracter clave $
      (progn
        (foreach name1 lisName 
          (setq position (PositionChar name1 "$"))
          (if position
            (setq name1 (substr name1 position ))
          )
          (setq lisNameWithoutPrefix (append lisNameWithoutPrefix (list name1)))

        )
        
        (princ (length lisNameWithoutPrefix))
        (print)
        (setq lisNameWithoutPrefix(removeDuplicates lisNameWithoutPrefix))
        (print)
        (princ (length lisNameWithoutPrefix))
        (print)
      )
    )
   (imp lisNameWithoutPrefix)
 )   

;; retorna la posiscion de un caracter espesifico en una cadena de texto
(defun PositionChar(str char / i encontrado charI)
  (setq i (strlen str)  )
  (setq encontrado nil)
  (while (and (> i 0 ) ( not encontrado ))
    (setq charI (substr str i 1))
    (if(= char charI)
        (setq encontrado T)
        (setq i (1- i))
    )
  )
  (if( not encontrado  )
    nil
    (1+ i)
  )
)

;; quita duplicados de una lista 
(defun removeDuplicates ( lis / newList item )
  (setq newList '())
  
      (foreach item lis
        (if (not (member item newList)); si no encuentra el elemnto en la nueva lista 
          (setq newList (append newList (list item)))
        )
      )
    
  
   newList
)
  
      
  
    
   
  

(DEFUN imp(lis / i)
  (FOREACH i lis
   (PRINT i)
   (PRINC)
  )
)






