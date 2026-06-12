# 📯 InstrumentosApp

Una aplicación de iOS nativa escrita en **SwiftUI** diseñada para llevar el control de la entrega de 13 instrumentos musicales a un grupo de estudiantes. La app guarda automáticamente todos los datos de forma local en tu iPhone, por lo que no necesitas ninguna base de datos externa ni conexión a internet.

---

## 🚀 Características
*   **Gestión de Instrumentos (1-13)**: Una pantalla principal que muestra el estado de cada instrumento (Disponible en verde o Asignado en naranja) con la información del alumno y la hora de entrega.
*   **Gestión de Alumnos**: Listado alfabético con barra de búsqueda para encontrar estudiantes rápidamente, añadir nuevos alumnos de forma individual o eliminarlos deslizando la fila.
*   **Carga Masiva de Estudiantes**: En Configuración puedes pegar tu lista de estudiantes directamente (un nombre por línea) y cargarlos todos a la vez.
*   **Reportes Rápidos**: Genera un reporte en texto listo para copiar al portapapeles y enviarlo por WhatsApp o correo.
*   **Guardado Automático**: Los datos se guardan usando `@AppStorage` (`UserDefaults`), persistiendo incluso si reinicias el iPhone.

---

## 🛠️ Cómo subir la App a tu GitHub para compilar el IPA

Como estás en Windows, no puedes compilar el proyecto de Xcode localmente. Para solucionar esto, hemos incluido un workflow de **GitHub Actions** que compilará el archivo `.ipa` por ti en un servidor virtual de macOS de GitHub.

Sigue estos pasos en tu terminal (por ejemplo, en PowerShell o Command Prompt en la carpeta de este proyecto):

### 1. Crear un Repositorio en GitHub
1.  Inicia sesión en tu cuenta de [GitHub](https://github.com).
2.  Crea un nuevo repositorio vacío. Ponle el nombre `InstrumentosApp` (puedes dejarlo como Público o Privado).
3.  **No** agregues README ni `.gitignore` al crearlo en la web (ya que la app ya los tiene).

### 2. Inicializar Git y subir el proyecto
Ejecuta los siguientes comandos desde la carpeta de la aplicación (`C:\Users\fredd\.gemini\antigravity\scratch\InstrumentosApp`):

```bash
# 1. Inicializar el repositorio Git local
git init

# 2. Agregar todos los archivos al commit
git add .

# 3. Crear el primer commit
git commit -m "Initial commit with SwiftUI app and GitHub Actions workflow"

# 4. Cambiar el nombre de la rama principal a main
git branch -M main

# 5. Vincular tu repositorio local con el de GitHub (Reemplaza 'TU_USUARIO' por tu nombre de usuario de GitHub)
git remote add origin https://github.com/TU_USUARIO/InstrumentosApp.git

# 6. Subir el código a GitHub
git push -u origin main
```

> [!NOTE]
> Si es la primera vez que usas Git en tu computadora, es posible que te pida iniciar sesión en GitHub en una ventana emergente para autorizar la subida.

---

## 📦 Cómo descargar el archivo `.ipa` compilado

Una vez que hagas el `git push`, el proceso de compilación automática se iniciará en GitHub.

1.  Abre tu repositorio en la web de GitHub.
2.  Haz clic en la pestaña **Actions** en la parte superior.
3.  Verás un flujo de trabajo ejecutándose llamado **Build iOS IPA (Unsigned)**. Haz clic sobre él.
4.  Espera de 2 a 4 minutos a que termine (el círculo cambiará a un check verde `✓`).
5.  Una vez completado, entra al run de la acción y haz scroll hacia abajo hasta la sección **Artifacts** (Artefactos).
6.  Allí verás el archivo **`InstrumentosApp-Unsigned-IPA`**. Haz clic para descargarlo. Se descargará un archivo `.zip` que contiene tu `.ipa` en su interior.

---

## 📲 Cómo instalar el `.ipa` en tu iPhone (Sideloading)

Dado que este archivo `.ipa` no está firmado por Apple, debes firmarlo con tu propia cuenta gratuita de Apple ID para poder instalarlo en tu iPhone. La herramienta recomendada y más fácil en Windows es **Sideloadly**:

1.  Descarga e instala **iTunes** y **iCloud** para Windows directamente desde la web de Apple (no de la Microsoft Store si es posible, ya que a veces fallan las conexiones por USB).
2.  Descarga e instala [Sideloadly](https://sideloadly.io/).
3.  Conecta tu iPhone a la computadora mediante USB. Si el iPhone te pregunta, presiona **"Confiar en esta computadora"**.
4.  Abre **Sideloadly**:
    *   Verás que detecta tu iPhone en la casilla **Device**.
    *   En la casilla **Apple Account**, escribe tu correo electrónico de Apple ID (el que usas en tu iPhone).
    *   Arrastra el archivo `InstrumentosApp.ipa` que descargaste y extrajiste a la casilla que tiene el icono de la app (el cuadro grande de la izquierda).
5.  Haz clic en el botón **Start**.
6.  Te solicitará la contraseña de tu Apple ID (Sideloadly hace la petición segura directamente a los servidores de Apple para firmar la app con tu certificado personal gratuito).
7.  Espera a que diga **Done**. La aplicación aparecerá instalada en tu iPhone.

### ⚠️ Habilitar la App en el iPhone (Paso Obligatorio)
La primera vez que intentes abrir la app en tu iPhone verás un aviso de "Desarrollador no confiable". Para activarla:
1.  En tu iPhone, ve a **Ajustes** > **General** > **Gestión de VPN y dispositivos**.
2.  Bajo "App de desarrollador", verás tu correo de Apple ID. Toca sobre él.
3.  Selecciona **"Confiar en [tu correo]"** y confirma la acción.
4.  Si tienes iOS 16 o posterior, también debes activar el **Modo de desarrollador**:
    *   Ve a **Ajustes** > **Privacidad y seguridad**.
    *   Haz scroll hasta el final y activa **Modo de desarrollador**.
    *   El iPhone se reiniciará y te pedirá confirmar que deseas activarlo.
5.  ¡Listo! Ya puedes abrir y usar **InstrumentosApp** en tu iPhone.

---

## 📂 Estructura del Código Fuente

*   `Sources/InstrumentosAppApp.swift`: Punto de entrada que inicializa el estado de la app.
*   `Sources/Models/Student.swift`: Modelo de datos de los estudiantes.
*   `Sources/Models/Assignment.swift`: Modelo que asocia estudiantes con instrumentos.
*   `Sources/Models/AppState.swift`: Controlador que gestiona la carga masiva, asignaciones, reportes y el guardado automático local.
*   `Sources/Views/ContentView.swift`: Contenedor principal con barra de navegación por pestañas.
*   `Sources/Views/InstrumentListView.swift`: Vista con barra de progreso de entregas y lista de instrumentos (1 al 13).
*   `Sources/Views/StudentListView.swift`: Vista de gestión y búsqueda de alumnos.
*   `Sources/Views/SettingsView.swift`: Pantalla de configuración para carga de texto y exportaciones.
