
;; obtiene la lista de todos los layes 
(DEFUN GetTblLayer (/ layer lisLay)
  (SETQ layer (TBLNEXT "LAYER" T));; en este caso la T indica q iniciara desde el primer registro 
  (SETQ lisLay '())

  (print "-------------------------------------")
  (print "obteniendo lista de layers..  ")
  (while layer 

    (setq idlayer(tblobjname "LAYER" (cdr (assoc 2 layer))))
    (setq entLayer (entget idLayer))
    (SETQ lisLay (APPEND lisLay (LIST entLayer)))
    (SETQ layer (TBLNEXT "LAYER" ))
  )
  
  
  (print "...operacion completada")
  (print  (strcat "Total de layer encontrados: " (itoa (length lisLay))))
  (print "-------------------------------------")
  (print)
  lisLay
) 
;; filtra solo las capas bloqueadas apagadas o congeladas 
(defun GetLayerLookOf( / lis LisLayerLookOf item )
  (setq lis (GetTblLayer))
  (print "-------------------------------------")
  (print "Buscando layers bloqueados  apagados o congelados ...  ")
  (setq LisLayerLookOf '())
  (foreach item lis    
    (if (or (< (cdr (assoc 62 item)) 0) (/= (cdr (assoc 70 item)) 0 ))
      (setq LisLayerLookOf (append LisLayerLookOf (list item )))
    )
  )
  
  (print "...operacion completada")
  (print  (strcat "Total de layer encontrados: " (itoa (length LisLayerLookOf))))
  (print "-------------------------------------")
  (print)
  LisLayerLookOf
)


; activa los estados de los layer 
(DEFUN ActivateLayer(/ item lis name color)
  (setq lis (GetLayerLookOf))
  (print "-------------------------------------")
  (print "activando layer ...  ")
  (FOREACH item lis
    (setq color (cdr (assoc 62 item)))
    (if(/= (cdr (assoc 70 item)) 0 )        
      (setq item (subst (cons 70 0) (assoc 70 item) item ))
    )
    (if(< color 0)
      (progn 
        (setq color (* -1 color))
        (setq item (subst (cons 62 color) (assoc 62 item) item ))                                 
      )
    )
    (setq name (cdr (assoc 2 item))); nombre del layer 
    (if (equal "0" name)   
      (command "-LAYER" "SET" "0" "") ; cambia a alayer 0 como el activo 
    )
    (entmod item )  
  )    
  (print "...operacion completada")
  (print  (strcat "Total de layer activados: " (itoa (length lis))))
  (print "-------------------------------------")
  (print)
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






;;; funcion para medir velocidad 
(defun testVelocidad ()
  (setq startTime (getvar "DATE"))
  (ActivateLayer)
  (setq endTime (getvar "DATE"))
  (setq elapsedTime (* (- endTime startTime) 86400.0)) ; Convierte de días a segundos
  (print (strcat "Tiempo de ejecución: " (rtos elapsedTime 2 6) " segundos"))
)



