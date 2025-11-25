;; Función para medir distancia entre dos puntos y crear texto
;; Rutina que mide distancia entre dos puntos y crea un texto con formato 4#5L="distancia"/"distancia+0.25"
;; Las distancias se redondean a múltiplos de 0.05
;; El texto se coloca automáticamente centrado y con una separación perpendicular a la línea de 0.05 unidades
;; Desarrollada: 12-Mayo-2025

(defun c:VARL (/ pt1 pt2 dist dist_str texto_final punto_medio altura estilo dx dy perpendicular_length perpendicular_x perpendicular_y offset_vector punto_texto dist_rounded dist_plus dist_plus_rounded dist_plus_str)
  (setvar "CMDECHO" 0) ;; Desactivar eco de comandos
  
  ;; Solicitar el primer punto
  (setq pt1 (getpoint "\nSeleccione el primer punto: "))
  (if (null pt1) (exit))
  
  ;; Solicitar el segundo punto
  (setq pt2 (getpoint pt1 "\nSeleccione el segundo punto: "))
  (if (null pt2) (exit))
  
  ;; Calcular la distancia
  (setq dist (distance pt1 pt2))
  
  ;; Redondear la distancia a múltiplos de 0.05
  (setq dist_rounded (* (fix (+ (/ dist 0.05) 0.5)) 0.05))
  
  ;; Convertir la distancia a texto con 2 decimales
  (setq dist_str (rtos dist_rounded 2 2))
  
  ;; Calcular dist+0.25 y redondear a múltiplos de 0.05
  (setq dist_plus (+ dist_rounded 0.35))
  (setq dist_plus_rounded (* (fix (+ (/ dist_plus 0.05) 0.5)) 0.05))
  (setq dist_plus_str (rtos dist_plus_rounded 2 2))
  
  ;; Crear el texto formateado
  (setq texto_final (strcat "4#5L=" dist_str "/" dist_plus_str))
  
  ;; Calcular el punto medio entre los dos puntos
  (setq punto_medio (list (/ (+ (car pt1) (car pt2)) 2.0)
                          (/ (+ (cadr pt1) (cadr pt2)) 2.0)
                          (/ (+ (caddr pt1) (caddr pt2)) 2.0)
                    )
  )
  
  ;; Calcular vector perpendicular a la línea para desplazar el texto
  (setq dx (- (car pt2) (car pt1)))
  (setq dy (- (cadr pt2) (cadr pt1)))
  
  ;; Calcular el vector perpendicular (perpendicular en el plano XY)
  (setq perpendicular_length (sqrt (+ (* dx dx) (* dy dy))))
  
  ;; Evitar división por cero
  (if (= perpendicular_length 0.0)
      (setq offset_vector (list 0.0 0.05 0.0)) ;; Usar un valor predeterminado si los puntos son idénticos
      (progn
        ;; Vector unitario perpendicular (-dy, dx)
        (setq perpendicular_x (/ (- dy) perpendicular_length))
        (setq perpendicular_y (/ dx perpendicular_length))
        ;; Crear vector de desplazamiento (multiplicando por 0.05 para la distancia de desplazamiento)
        (setq offset_vector (list (* perpendicular_x 0.05) (* perpendicular_y 0.05) 0.0))
      )
  )
  
  ;; Aplicar el desplazamiento al punto medio
  (setq punto_texto (list (+ (car punto_medio) (car offset_vector))
                          (+ (cadr punto_medio) (cadr offset_vector))
                          (caddr punto_medio)
                    )
  )
  
  ;; Establecer altura y estilo de texto predeterminados
  (setq altura 0.11)
  (setq estilo (getvar "TEXTSTYLE"))
  
  ;; Crear la entidad de texto centrado
  (command "_TEXT" "C" punto_texto altura "0" texto_final))
  
  ;; Mensaje de finalización
  (princ (strcat "\nDistancia original: " (rtos dist 2 2)))
  (princ (strcat "\nDistancia redondeada: " dist_str " - Texto creado exitosamente."))
  (princ)




;; Mensaje al cargar la rutina
(princ "\nRutina DisText cargada. Escribe DisText o LL para usarla.")
(princ)