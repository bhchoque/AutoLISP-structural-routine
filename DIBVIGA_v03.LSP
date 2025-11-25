(defun c:DIBVIGA (/ pt-inicio altura-fija pt-actual ancho pt-esquina1 pt-esquina2 
                    ancho-nombre alto-nombre centro-x centro-y altura-texto nombre-viga 
                    nivel-viga seccion-viga cant-viga old-cmdecho old-osmode)
  
  ;; Guardar variables del sistema
  (setq old-cmdecho (getvar "CMDECHO"))
  (setq old-osmode (getvar "OSMODE"))
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
  
  ;; Configuración inicial
  (setq altura-fija 2.15)
  (setq ancho-nombre 2.0)
  (setq alto-nombre 2.15)
  (setq altura-texto 0.25)
  
  ;; Solicitar nombre de la viga
  (setq nombre-viga (getstring "\nNombre de la viga (por defecto VG-01): "))
  (if (or (= nombre-viga "") (= nombre-viga nil))
    (setq nombre-viga "VG-01")
  )
  
  ;; Solicitar nivel
  (setq nivel-viga (getstring "\nNivel (por defecto BASE): "))
  (if (or (= nivel-viga "") (= nivel-viga nil))
    (setq nivel-viga "BASE")
  )
  
  ;; Solicitar sección
  (setq seccion-viga (getstring "\nSección (por defecto 25x30): "))
  (if (or (= seccion-viga "") (= seccion-viga nil))
    (setq seccion-viga "25x30")
  )

  ;; Solicitar cantidad
  (setq cant-viga (getstring "\nCantidad (por defecto Es 1): "))
  (if (or (= cant-viga "") (= cant-viga nil))
    (setq cant-viga "Es 1")
  )
  
  ;; Solicitar punto de inicio
  (setq pt-inicio (getpoint "\nPunto de inicio de la viga: "))
  
  (if pt-inicio
    (progn
      ;; Dibujar rectángulo del nombre al inicio
      (setq pt-esquina1 pt-inicio)
      (setq pt-esquina2 (list (+ (car pt-inicio) ancho-nombre) 
                              (+ (cadr pt-inicio) alto-nombre)))
      (command "_.RECTANGLE" pt-esquina1 pt-esquina2)
      
      ;; Calcular centro horizontal
      (setq centro-x (+ (car pt-inicio) (/ ancho-nombre 2.0)))
      
      ;; Insertar texto del nombre (1.65 unidades desde la base)
      (setq centro-y (+ (cadr pt-inicio) 1.65))
      (command "_.TEXT" "_J" "_MC" 
               (list centro-x centro-y 0.0) 
               altura-texto 
               0 
               nombre-viga)
      
      ;; Insertar texto del nivel (0.80 unidades desde la base)
      (setq centro-y (+ (cadr pt-inicio) 0.80))
      (command "_.TEXT" "_J" "_MC" 
               (list centro-x centro-y 0.0) 
               0.15 
               0 
               nivel-viga)
      
      ;; Insertar texto de sección (0.60 unidades desde la base)
      (setq centro-y (+ (cadr pt-inicio) 0.60))
      (command "_.TEXT" "_J" "_MC" 
               (list centro-x centro-y 0.0) 
               0.15 
               0 
               seccion-viga)
      
      ;; Insertar texto de cantidad (0.40 unidades desde la base)
      (setq centro-y (+ (cadr pt-inicio) 0.40))
      (command "_.TEXT" "_J" "_MC" 
               (list centro-x centro-y 0.0) 
               0.15 
               0 
               cant-viga)
      
      ;; Iniciar desde el final del rectángulo del nombre
      (setq pt-actual (list (+ (car pt-inicio) ancho-nombre) (cadr pt-inicio)))
      
      ;; Bucle para dibujar vanos
      (while (and 
               (setq ancho (getreal "\nAncho del vano (0 o Enter para terminar): "))
               (> ancho 0))
        
        ;; Calcular esquinas del rectángulo
        (setq pt-esquina1 pt-actual)
        (setq pt-esquina2 (list (+ (car pt-actual) ancho) 
                                (+ (cadr pt-actual) altura-fija)))
        
        ;; Dibujar rectángulo del vano
        (command "_.RECTANGLE" pt-esquina1 pt-esquina2)
        
        ;; Mover al siguiente vano
        (setq pt-actual (list (+ (car pt-actual) ancho) (cadr pt-actual)))
      )
      
      (princ "\nViga dibujada correctamente.")
    )
    (princ "\nOperación cancelada.")
  )
  
  ;; Restaurar variables del sistema
  (setvar "CMDECHO" old-cmdecho)
  (setvar "OSMODE" old-osmode)
  (princ)
)