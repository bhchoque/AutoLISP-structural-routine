# Rutinas AutoLISP para AutoCAD

Colección de rutinas AutoLISP para automatizar tareas de dibujo estructural en AutoCAD.

## Rutinas Disponibles

### DIBVIGA - Dibujo de Vigas
Dibuja vigas estructurales con información de nomenclatura, nivel, sección y cantidad.

**Uso:** `DIBVIGA`

**Parámetros solicitados:**
- Nombre de la viga (por defecto: VG-01)
- Nivel (por defecto: BASE)
- Sección (por defecto: 25x30)
- Cantidad (por defecto: Es 1)
- Punto de inicio
- Anchos de vanos (0 para terminar)

### DES - Distribución de Estribos
Genera distribución de estribos en elementos estructurales con cálculo automático de cantidades.

**Uso:** `DES`

**Características:**
- Crea capas ESTRIBOS (color 92) y TEXTO_E (color 162)
- Calcula automáticamente cantidad de estribos
- Genera texto con formato de distribución

### VARE - Varillas con Longitud Estándar
Mide distancia entre dos puntos y genera texto con formato `4#5L=dist/dist`

**Uso:** `VARE`

**Características:**
- Redondeo automático a múltiplos de 0.05
- Texto centrado con offset perpendicular de 0.05

### VARL - Varillas con Longitud Adicional
Similar a VARE pero agrega 0.35 unidades a la segunda medida: `4#5L=dist/(dist+0.35)`

**Uso:** `VARL`

## Instalación

1. Descarga los archivos .LSP
2. En AutoCAD, usa el comando `APPLOAD` o escribe `(load "ruta/al/archivo.lsp")`
3. Ejecuta el comando correspondiente

## Carga Automática

Para cargar automáticamente al iniciar AutoCAD, agrega estas líneas a tu archivo `acaddoc.lsp`:
```lisp
(load "ruta/DIBVIGA_v03.LSP")
(load "ruta/ESTRIB_DES_ent_v02.lsp")
(load "ruta/VARE.LSP")
(load "ruta/VARL.lsp")
```

## Requisitos

- AutoCAD (probado en versión 2024)
- Sistema de unidades métricas

## Licencia

MIT

## Contribuciones

Las contribuciones son bienvenidas. Por favor abre un issue para discutir cambios mayores.

## Autor

bregychoque@ustavillavicencio.edu.co
## Versión

- DIBVIGA: v0.3
- ESTRIB_DES: v0.2
- VARE: 12-Mayo-2025
- VARL: 12-Mayo-2025
