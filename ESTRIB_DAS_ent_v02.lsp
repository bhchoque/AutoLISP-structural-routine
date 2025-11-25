(defun c:DAS (/ pt1 pt2 x1 y1 x2 y2 zc d2 d4 Li cant1 cant2 xIni1 xFin1 xIni2 xFin2 xIni3 xFin3 texto1 texto2 capa_original estribos_id texto_id texto_altura)
  ;; Configuración inicial
  (setvar "CMDECHO" 0)
  
  ;; Guardar la capa actual
  (setq capa_original (getvar "CLAYER"))
  
  ;; Crear o verificar capas necesarias y obtener sus IDs
  (if (not (tblsearch "LAYER" "ESTRIBOS"))
    (command "_LAYER" "_N" "ESTRIBOS" "_C" "92" "ESTRIBOS" "")
    (command "_LAYER" "_C" "92" "ESTRIBOS" "")  ;; Si ya existe, solo cambia el color
  )
  (if (not (tblsearch "LAYER" "TEXTO_E"))
    (command "_LAYER" "_N" "TEXTO_E" "_C" "162" "TEXTO_E" "")
    (command "_LAYER" "_C" "162" "TEXTO_E" "")  ;; Si ya existe, solo cambia el color
  )
  
  ;; Obtener IDs de las capas
  (setq estribos_id (cdr (assoc 5 (tblsearch "LAYER" "ESTRIBOS"))))
  (setq texto_id (cdr (assoc 5 (tblsearch "LAYER" "TEXTO_E"))))
   
  ;; Solicitar puntos con validación
  (setq pt1 (getpoint "\nSeleccione la esquina inferior izquierda: "))
  (if pt1
    (progn
      (setq pt2 (getcorner pt1 "\nSeleccione la esquina superior derecha: "))
      (if pt2
        (progn
          ;; Extraer coordenadas
          (setq x1 (car pt1))
          (setq y1 (cadr pt1))
          (setq x2 (car pt2))
          (setq y2 (cadr pt2))
          
          ;; Verificar que los puntos no sean iguales y que x2 > x1 y y2 > y1
          (if (and (> x2 x1) (> y2 y1))
            (progn
              (setq zc (+ 1.0 ))  
              (setq Li (- x2 x1 0.4 (* 2 zc)))
              (setq d2 0.22)
              (setq d4 0.11)
              (setq texto_altura 0.11)
              
              ;; Verificar que Li sea positivo
              (if (> Li 0)
                (progn
                           
                  
                  (setq cant1 (1+ (fix (/ zc d4))))  ;; Usar fix en lugar de atoi(rtos())
                  (setq cant2 (1+ (fix (/ Li d2))))  ;; Usar fix en lugar de atoi(rtos())
                  
                  ;; === Dibujar líneas 1 con entmake ===
                  (setq xIni1 (+ x1 0.1))     
                  (setq xFin1 (+ xIni1 zc))  
                  
                  ;; Crear función auxiliar para crear líneas
                  (defun crear-linea (p1 p2 capa-id)
                    (entmake (list 
                      '(0 . "LINE")
                      (cons 8 capa-id)  ;; Nombre de capa
                      (cons 10 p1)      ;; Punto inicial
                      (cons 11 p2)      ;; Punto final
                    ))
                  )
                  
                  ;; Primera sección de estribos
                  (crear-linea (list xIni1 (+ y1 0.9) 0.0) (list xIni1 (- y2 1.15) 0.0) "ESTRIBOS")
                  (crear-linea (list xFin1 (+ y1 0.9) 0.0) (list xFin1 (- y2 1.15) 0.0) "ESTRIBOS")
                  (crear-linea (list xIni1 (+ y1 0.95) 0.0) (list xFin1 (+ y1 0.95) 0.0) "ESTRIBOS")
                  
                  ;; === Dibujar líneas 2 con entmake ===
                  (setq xIni2 (+ xFin1 0.1))
                  (setq xFin2 (- x2 0.2 zc))
                  
                  ;; Verificar que xFin2 > xIni2
                  (if (> xFin2 xIni2)
                    (progn
                      ;; Segunda sección de estribos
                      (crear-linea (list xIni2 (+ y1 0.9) 0.0) (list xIni2 (- y2 1.15) 0.0) "ESTRIBOS")
                      (crear-linea (list xFin2 (+ y1 0.9) 0.0) (list xFin2 (- y2 1.15) 0.0) "ESTRIBOS")
                      (crear-linea (list xIni2 (+ y1 0.95) 0.0) (list xFin2 (+ y1 0.95) 0.0) "ESTRIBOS")
                      
                      ;; === Dibujar líneas 3 con entmake ===
                      (setq xIni3 (+ xFin2 0.1))
                      (setq xFin3 (- x2 0.1))
                      
                      ;; Verificar que xFin3 > xIni3
                      (if (> xFin3 xIni3)
                        (progn
                          ;; Tercera sección de estribos
                          (crear-linea (list xIni3 (+ y1 0.9) 0.0) (list xIni3 (- y2 1.15) 0.0) "ESTRIBOS")
                          (crear-linea (list xFin3 (+ y1 0.9) 0.0) (list xFin3 (- y2 1.15) 0.0) "ESTRIBOS")
                          (crear-linea (list xIni3 (+ y1 0.95) 0.0) (list xFin3 (+ y1 0.95) 0.0) "ESTRIBOS")
                          
                          ;; === Textos con entmake ===
                          (setq texto1 (strcat (itoa cant1) "E#3C/" (rtos d4 2 2)))
                          (setq texto2 (strcat (itoa cant2) "E#3C/" (rtos d2 2 2)))
                          
                          ;; Función para crear texto
                          (defun crear-texto (texto punto capa-id altura)
                            (entmake (list 
                              '(0 . "TEXT")
                              (cons 8 capa-id)    ;; Nombre de capa
                              '(100 . "AcDbEntity")
                              '(100 . "AcDbText")
                              (cons 10 punto)     ;; Punto de inserción
                              (cons 11 punto)     ;; Punto de alineación (igual para centrado)
                              (cons 40 altura)    ;; Altura del texto
                              (cons 1 texto)      ;; Contenido del texto
                              '(72 . 1)           ;; Tipo de justificación horizontal (1=centrado)
                              '(73 . 1)           ;; Tipo de justificación vertical (1=centrado)
                            ))
                          )
                          
                          ;; Crear los tres textos
                          (crear-texto texto1 (list (/ (+ xIni1 xFin1) 2) (+ y1 1.03) 0.0) "TEXTO_E" texto_altura)
                          (crear-texto texto2 (list (/ (+ xIni2 xFin2) 2) (+ y1 1.03) 0.0) "TEXTO_E" texto_altura)
                          (crear-texto texto1 (list (/ (+ xIni3 xFin3) 2) (+ y1 1.03) 0.0) "TEXTO_E" texto_altura)
                          
                          (princ "\nLíneas dibujadas correctamente.")
                          (princ (strcat "\nCantidad de estribos 1: " (itoa cant1)))
                          (princ (strcat "\nCantidad de estribos 2: " (itoa cant2)))
                        )
                        (princ "\nError: El ancho de la tercera sección es muy pequeño.")
                      )
                    )
                    (princ "\nError: El ancho de la segunda sección es muy pequeño.")
                  )
                )
                ;; ELSE para cuando Li no es mayor que 0 (agregar un solo grupo de líneas)
                (progn
                  (setq cant1 (1+ (fix (/ (- x2 x1) d4))))  ;; Usar fix en lugar de atoi(rtos())
                  (setq xIni1 (+ x1 0.1))     
                  (setq xFin1 (- x2 0.1))
                  (defun crear-linea (p1 p2 capa-id)
                    (entmake (list 
                      '(0 . "LINE")
                      (cons 8 capa-id)  ;; Nombre de capa
                      (cons 10 p1)      ;; Punto inicial
                      (cons 11 p2)      ;; Punto final
                    ))
                  )
                  (crear-linea (list xIni1 (+ y1 0.9) 0.0) (list xIni1 (- y2 1.15) 0.0) "ESTRIBOS")
                  (crear-linea (list xFin1 (+ y1 0.9) 0.0) (list xFin1 (- y2 1.15) 0.0) "ESTRIBOS")
                  (crear-linea (list xIni1 (+ y1 0.95) 0.0) (list xFin1 (+ y1 0.95) 0.0) "ESTRIBOS")
                  
                  
                   ;; === Textos con entmake ===
                          (setq texto1 (strcat (itoa cant1) "E#3C/" (rtos d4 2 2)))
                                                    
                          ;; Función para crear texto
                          (defun crear-texto (texto punto capa-id altura)
                            (entmake (list 
                              '(0 . "TEXT")
                              (cons 8 capa-id)    ;; Nombre de capa
                              '(100 . "AcDbEntity")
                              '(100 . "AcDbText")
                              (cons 10 punto)     ;; Punto de inserción
                              (cons 11 punto)     ;; Punto de alineación (igual para centrado)
                              (cons 40 altura)    ;; Altura del texto
                              (cons 1 texto)      ;; Contenido del texto
                              '(72 . 1)           ;; Tipo de justificación horizontal (1=centrado)
                              '(73 . 1)           ;; Tipo de justificación vertical (1=centrado)
                            ))
                          )
                          
                          ;; Crear los tres textos
                          (crear-texto texto1 (list (/ (+ xIni1 xFin1) 2) (+ y1 1.03) 0.0) "TEXTO_E" texto_altura)
                  
                )
              )
            )
            (princ "\nError: Los puntos seleccionados no son válidos. Asegúrese de que x2 > x1 y y2 > y1.")
          )
        )
        (princ "\nOperación cancelada.")
      )
    )
    (princ "\nOperación cancelada.")
  )

  ;; Restaurar configuración
  (command "_LAYER" "_S" capa_original "")
  (setvar "CMDECHO" 1)
  (princ)  ; Retorno limpio
)

;; Mensaje de carga
(princ "\nComando DES cargado. Escribe DES para ejecutar.")
(princ)