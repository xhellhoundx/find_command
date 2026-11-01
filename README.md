<div align="center">
    <img src="./assets/find_commands_banner.jpeg">
</div>

<br><br>

# 🔍 Find Commands

Herramienta de la shell para buscar rápidamente en un índice personal de comandos, herramientas y protocolos usados en ciberseguridad.

<br>

## ¿Por qué existe esta herramienta?

Cuando estoy practicando en plataformas como **TryHackme** y **OverTheWire**, acumulo comandos, flags y flujos de trabajo que necesito consultar frecuentemente. En lugar de buscar en internet cada vez, mantengo un `index.yaml` con mis propias notas y este script me permite consultarlo directamente desde la terminal.

<br>

>[!IMPORTANT]
>
>Esta herramienta ha sido probada solamente en distribuciones basadas en **Debian**
>

<br>

## Contexto

Este repositorio forma parte de mis herramientas automatización

<br>

## Características

- Panel de ayuda: (`-h`)
- Lista todos los **paquetes** y **servicios** disponibles (`-l`)
- Búsqueda por **comando** o **aparición** en el documento (`-c`)
- Búsqueda por **título** de herramienta o protocolo (`-k`)
- Búsqueda de **programas** o **servicios** por categoría (`-a`) (*¡NUEVA FUNCIONALIDAD! - Las categorías están listadas en la ayuda*)
- Validación de argumentos y mensajes de error según sea el caso

<br>

## Instalación

```bash
# Clonar el repositorio
git clone https://github.com/xhellhoundx/find_command
cd find_comands

# Dar permisos de ejecución
chmod +x find_commands.sh

# (recomendación) Añadir al $PATH con un symlink
sudo ln -s "$(pwd)/find_command.sh" /usr/local/bin/findcommand

# O también puedes agregarlo como alias al archivo ~/.*sh_aliases
findcommands='ruta/al/script'
```

---

## Uso

```bash
find_command [ -l | -k | -c | -h | -a] [TÉRMINO]
```

| Flag | Descripción |
|------|-------------|
|  -l  | Lista todos los servicios y paquetes |
|  -k  | Busca por título en el índice (ej: `"SSH"`, `"nmap"`) |
|  -c  | Busca apariciones en el documento |
|  -a  | Busca por categoría |
|  -h  | Muestra la ayuda |


### Ejemplos

```bash
# Buscar las notas del bloque "SSH"
find_commands -k ssh

# Buscar cualquier mención a "john" en el índice
find_commands -c john
```

<br>

## Estructura del proyecto:

```
find_commands/
├── find_commands.sh    # Script principal
└── index.yaml           # Índice personal de comandos (ejemplo)
```

<br>

### Recomendaciones

Intenta mantener el formato del `.yaml` para que no ocurran errores con la búsqueda. La información que aportes será totalmente de tu criterio.

>[!TIP]
>Siéntanse libres de usarla y modificarla a su gusto

<br><br>

---

<div align="center">

**HellHound DevSecOps**<br>
*Ciberseguridad, Análsis de Sistemas & Reportes*

[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/xhellhoundx/hellhound)
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=flat&logo=youtube&logoColor=white)](https://www.youtube.com/@H3llH0undDSO)
[![X](https://img.shields.io/badge/X-000000?style=flat&logo=x&logoColor=white)](https://x.com/hellhoundso)

<div>
