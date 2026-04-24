# Aplicacion de Quimica

Aplicacion movil y web desarrollada con **Flutter** para la materia de **Quimica**, creada en el **Instituto Tecnologico de Piedras Negras** (TecNM). Permite explorar los 118 elementos quimicos de la tabla periodica de forma interactiva, visualizar la tabla periodica completa con codigo de colores por categoria, consultar el principio de Aufbau y buscar elementos por nombre o numero atomico.

## Descripcion General

La aplicacion esta disenada como herramienta educativa para estudiantes de quimica. Ofrece acceso rapido a informacion detallada de cada elemento quimico, incluyendo configuracion electronica, estados de oxidacion, familia, grupo, periodo, estado de la materia, origen, propiedades, abundancia, produccion y extraccion.

### Caracteristicas principales

- **Pantalla de inicio animada** con splash screen GIF personalizado
- **Buscador de elementos** por nombre o numero atomico con filtrado en tiempo real
- **Tabla periodica interactiva** con colores por categoria (metales, no metales, gases nobles, etc.)
- **Diagrama del principio de Aufbau** con niveles de energia y subniveles (s, p, d, f)
- **Ficha detallada** de cada elemento con toda su informacion quimica
- **Despliegue web** con Docker + Nginx
- **Multiplataforma**: Android, iOS, Web, Linux, macOS, Windows

---

## Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicacion
├── json/
│   └── leer_json.dart           # Carga de datos JSON de elementos
├── screen/
│   ├── buscador.dart            # Pantalla principal con buscador
│   ├── tabla_periodica.dart     # Tabla periodica interactiva
│   ├── aufbau.dart              # Diagrama del principio de Aufbau
│   └── creditos.dart            # Pantalla de creditos
└── tools/
    ├── elemento.dart            # Modelo de datos del elemento quimico
    └── globals.dart             # Utilidades globales (colores, categorias, modal de detalle)

assets/
├── elementos_quimicos.json      # Base de datos de los 118 elementos
├── logo.png                     # Icono de la aplicacion
├── logosc.gif                   # Animacion del splash screen
├── tecnm.png                    # Logo del TecNM
└── itpn.png                     # Logo del ITPN
```

---

## Funcionamiento y Partes Importantes del Codigo

### 1. Punto de Entrada (`lib/main.dart`)

El archivo `main.dart` inicializa la aplicacion Flutter y muestra una **pantalla de splash animada** usando el paquete `another_flutter_splash_screen`. La animacion GIF (`logosc.gif`) se muestra durante 3.4 segundos antes de navegar a la pantalla principal (`MainPage`).

```dart
home: FlutterSplashScreen.gif(
  gifPath: 'assets/logosc.gif',
  gifWidth: 269,
  gifHeight: 474,
  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  nextScreen: const MainPage(),
  duration: const Duration(milliseconds: 3400),
),
```

La aplicacion utiliza `PlatformProvider` de `flutter_platform_widgets` para adaptar la interfaz automaticamente segun la plataforma (Material Design en Android/Web, Cupertino en iOS).

---

### 2. Modelo de Datos (`lib/tools/elemento.dart`)

La clase `Elemento` define la estructura de cada elemento quimico con 16 propiedades:

| Propiedad      | Descripcion                        |
|----------------|------------------------------------|
| `z`            | Numero atomico                     |
| `n`            | Nombre del elemento                |
| `s`            | Simbolo quimico                    |
| `cc`           | Configuracion electronica completa |
| `cr`           | Configuracion electronica compacta |
| `grupo`        | Grupo en la tabla periodica        |
| `periodo`      | Periodo en la tabla periodica      |
| `familia`      | Familia quimica                    |
| `estado`       | Estado de la materia               |
| `descripcion`  | Descripcion general                |
| `origen`       | Origen natural                     |
| `oxidacion`    | Numeros de oxidacion               |
| `propiedades`  | Propiedades principales            |
| `abundancia`   | Abundancia en la corteza terrestre |
| `produccion`   | Principales paises productores     |
| `extraccion`   | Metodo de extraccion               |

El constructor `Elemento.fromJson()` permite crear instancias directamente desde el JSON:

```dart
Elemento.fromJson(Map<String, dynamic> json) {
  z = json['z'];
  n = json['n'];
  s = json['s'];
  // ... demas propiedades
}
```

Tambien incluye la funcion `buildElementoItem()` que construye el widget visual de lista para cada elemento, mostrando el nombre y numero atomico.

---

### 3. Carga de Datos (`lib/json/leer_json.dart`)

Los datos de los 118 elementos se almacenan en `assets/elementos_quimicos.json`. La funcion asincrona `leerJson()` los carga usando `rootBundle` de Flutter:

```dart
Future<List<Elemento>> leerJson() async {
  final String response = await rootBundle.loadString(
    'assets/elementos_quimicos.json',
  );
  final data = await jsonDecode(response);

  List<Elemento> elementos = [];
  for (var item in data) {
    elementos.add(Elemento.fromJson(item));
  }
  return elementos;
}
```

Cada elemento en el JSON contiene informacion como:
```json
{
  "z": 1,
  "n": "Hidrogeno",
  "s": "H",
  "cc": "1s1",
  "cr": "1s1",
  "grupo": "1",
  "periodo": 1,
  "familia": "No metal",
  "estado": "Gas",
  "oxidacion": "+1, -1",
  "descripcion": "El elemento mas abundante del universo..."
}
```

---

### 4. Pantalla Principal - Buscador (`lib/screen/buscador.dart`)

La clase `MainPage` es la pantalla principal de la aplicacion. Contiene:

- **Barra de busqueda** con campo de texto que filtra elementos en tiempo real usando un `ValueNotifier<String>` (`querySearch`)
- **Lista de resultados** construida con `ValueListenableBuilder` para reactividad sin necesidad de `setState`
- **Navegacion** a las demas pantallas (Tabla Periodica, Aufbau, Creditos) mediante botones en el `AppBar`

El filtrado de elementos funciona comparando el texto ingresado con el nombre y numero atomico:

```dart
final filtrados = elementos.where((el) {
  if (searchQuery.isEmpty) return false;
  if (vistas.contains(el.z)) return false;
  final q = searchQuery.toLowerCase();
  if (!el.n.toLowerCase().contains(q) &&
      !el.z.toString().contains(searchQuery)) {
    return false;
  }
  vistas.add(el.z);
  return true;
}).toList()..sort((a, b) => a.z.compareTo(b.z));
```

Se usa un `Set<int> vistas` para evitar duplicados en los resultados.

---

### 5. Tabla Periodica (`lib/screen/tabla_periodica.dart`)

La pantalla `TablaPeriodica` renderiza la tabla periodica completa de 118 elementos. Aspectos clave:

- **Posicionamiento manual**: Cada elemento tiene su posicion exacta `(fila, columna, numero_atomico)` definida en la lista `_positions` para reproducir fielmente la disposicion de la tabla periodica estandar.
- **Colores por categoria**: Cada elemento se colorea segun su clasificacion (metal alcalino, gas noble, lantanido, etc.) usando la funcion `colorElemento()`.
- **Scroll bidireccional**: La tabla soporta scroll horizontal y vertical para navegar por todos los elementos.
- **Leyenda de colores**: En la parte superior se muestra una barra con los colores de cada categoria.
- **Celdas especiales**: Las posiciones de lantanidos (57-71) y actinidos (89-103) tienen celdas de referencia con etiquetas `La->Lu` y `Ac->Lr`.

```dart
Widget _cell(Elemento el) {
  final color = _colorCategoria(el.z);
  return GestureDetector(
    onTap: () => mostrarDetalleElemento(context, el),
    child: Container(
      width: 52, height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.88),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(el.z.toString()),  // Numero atomico
          Text(el.s),             // Simbolo
          Text(el.n),             // Nombre (truncado si >8 chars)
        ],
      ),
    ),
  );
}
```

Al tocar cualquier elemento se abre el modal de detalle con toda su informacion.

---

### 6. Principio de Aufbau (`lib/screen/aufbau.dart`)

La pantalla `Aufbau` muestra un diagrama visual del **principio de Aufbau** (orden de llenado de orbitales). Se construye como un `Stack` con posicionamiento absoluto:

- **Columnas**: Subniveles `s`, `p`, `d`, `f`
- **Filas**: Niveles de energia 1 a 7, con su letra y capacidad maxima de electrones (ej: `1K 2`, `2L 8`, `3M 18`, etc.)
- **Interactividad**: Al tocar un subnivel, muestra un `SnackBar` con la capacidad maxima de electrones:

```dart
switch (lvl.substring(1)) {
  case 's': electrones = 2;
  case 'p': electrones = 6;
  case 'd': electrones = 10;
  case 'f': electrones = 14;
}
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Puede tener hasta $electrones Electrones")),
);
```

---

### 7. Utilidades Globales (`lib/tools/globals.dart`)

Este archivo contiene funciones y variables compartidas por toda la aplicacion:

- **`colorElemento(int z)`**: Asigna un color unico a cada categoria de elementos:
  - Rojo para Hidrogeno
  - Morado para gases nobles
  - Naranja para metales alcalinos
  - Amarillo para metales alcalinoterreos
  - Verde para lantanidos y no metales
  - Azul para metales de transicion
  - Gris para metales post-transicion
  - Turquesa para actinidos y metaloides

- **`categoriaElemento(int z)`**: Retorna el nombre de la categoria como texto.

- **`mostrarDetalleElemento()`**: Muestra un `ModalBottomSheet` con la ficha completa del elemento, incluyendo:
  - Numero atomico y simbolo con color de categoria
  - Nombre del elemento
  - Etiqueta de categoria
  - Informacion detallada en filas: descripcion, configuracion electronica, oxidacion, familia, grupo, periodo, estado, origen, propiedades, abundancia, produccion y extraccion

- **`querySearch`**: `ValueNotifier<String>` global para el estado reactivo de la busqueda.

---

### 8. Pantalla de Creditos (`lib/screen/creditos.dart`)

La pantalla de creditos muestra:

- Logos institucionales (TecNM e ITPN)
- Nombre del desarrollador: **Erick Sebastian Santibanez Cepeda**
- Numero de control: **25430120**
- Carrera: **Ingenieria en Sistemas Computacionales**
- Fecha de creacion: **18 de Abril del 2026**
- Lugar de desarrollo: **Instituto Tecnologico de Piedras Negras**
- Materia: **Quimica**
- Maestro: **ING. PEDRO CRUZ VAZQUEZ**
- Boton de donaciones (visible solo en plataformas nativas, no en web)

La pantalla tiene efectos visuales decorativos con circulos desenfocados y un efecto `BackdropFilter` para glassmorphism.

---

## Despliegue Web (Docker)

La aplicacion incluye configuracion para despliegue web con Docker:

### Dockerfile (multi-stage build)
1. **Etapa de build**: Usa la imagen oficial de Flutter para compilar la app web (`flutter build web --release`)
2. **Etapa de servicio**: Usa Nginx Alpine para servir los archivos estaticos generados

### nginx.conf
- Compresion Gzip para mejor rendimiento
- Cache agresivo para assets estaticos (1 ano)
- Fallback SPA (todas las rutas redirigen a `index.html`)

### docker-compose.yml
- Servicio `quimica-web` configurado para integracion con **Coolify** como plataforma de hosting

---

## Dependencias

| Paquete                          | Uso                                          |
|----------------------------------|----------------------------------------------|
| `flutter_platform_widgets`       | Widgets adaptativos (Material/Cupertino)      |
| `cupertino_icons`                | Iconos estilo iOS                            |
| `url_launcher`                   | Abrir URLs externas (donaciones)             |
| `another_flutter_splash_screen`  | Splash screen animado con GIF                |
| `flutter_launcher_icons`         | Generacion automatica de iconos de la app    |
| `flutter_lints`                  | Reglas de analisis estatico                  |

---

## Requisitos

- **Flutter SDK** >= 3.9.2
- **Dart SDK** (incluido con Flutter)
- **Docker** (opcional, para despliegue web)

## Instalacion y Ejecucion

```bash
# Clonar el repositorio
git clone https://github.com/Cordiaxis/Aplicacion_de_Quimica.git
cd Aplicacion_de_Quimica

# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run

# Compilar para web
flutter build web --release

# Desplegar con Docker
docker-compose up --build
```

---

## Autor

**Erick Sebastian Santibanez Cepeda**
Instituto Tecnologico de Piedras Negras (TecNM)
Ingenieria en Sistemas Computacionales
Materia: Quimica | Maestro: ING. PEDRO CRUZ VAZQUEZ
