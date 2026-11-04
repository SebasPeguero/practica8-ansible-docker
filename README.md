# Práctica 8: Uso de Ansible para automatizar tareas en servidores

**Estudiante:** Sebastián Peguero  
**Matrícula:** 2025-1172  
**Materia:** Electiva II (DevOps)  
**Institución:** Instituto Tecnológico de Las Américas (ITLA)  
**Repositorio:** [practica8-ansible-docker](https://github.com/SebasPeguero/practica8-ansible-docker)

---

## 🎯 Objetivo de la Práctica
Automatizar la configuración y aprovisionamiento de 5 servidores virtuales de Ubuntu utilizando **Ansible** y **Docker Compose** en un entorno local.

---

## 📁 Estructura del Proyecto
```text
practica8-ansible-docker/
├── Dockerfile              # Imagen Ubuntu con OpenSSH Server y usuario ansible
├── Dockerfile.ansible      # Imagen de control con Ansible instalado
├── docker-compose.yml      # Definición de los 5 servidores + nodo Ansible
├── inventario.ini          # Inventario con los 5 nodos servidores
├── ansible.cfg             # Configuración de Ansible (sin verificación SSH)
├── playbook.yml            # Playbook con todas las tareas de automatización
├── .gitignore              # Archivos excluidos de control de versiones
└── README.md               # Documentación e instrucciones paso a paso
```

---

## ⚙️ Componentes de la Práctica

### 1. Servidores Ubuntu (`Dockerfile`)
* Basados en `ubuntu:22.04`.
* Servicio SSH (`openssh-server`) activo en el puerto 22.
* Usuario `ansible` con contraseña `ansible` y privilegios `sudo` sin contraseña (`NOPASSWD:ALL`).
* Intérprete `python3` instalado para la ejecución de módulos de Ansible.

### 2. Orquestación (`docker-compose.yml`)
* **5 Servidores:** `server1`, `server2`, `server3`, `server4` y `server5`.
* Puertos mapeados al host:
  * `server1`: `2201 -> 22`
  * `server2`: `2202 -> 22`
  * `server3`: `2203 -> 22`
  * `server4`: `2204 -> 22`
  * `server5`: `2205 -> 22`
* Red puente: `ansible-net`.

### 3. Automatización con Playbook (`playbook.yml`)
El playbook ejecuta automáticamente las 5 tareas en los 5 servidores:
1. **Actualizar caché de APT** del sistema operativo (`apt: update_cache=yes`).
2. **Crear el usuario `itla`** en cada servidor (`user: name=itla`).
3. **Crear una carpeta llamada `/app`** (`file: path=/app state=directory`).
4. **Crear un archivo `hola.txt`** en la carpeta `/app` con los datos del estudiante y servidor.
5. **Instalar las aplicaciones `cowsay` y `htop`** en cada servidor.

---

## 🚀 Pasos para Ejecutar la Práctica

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/SebasPeguero/practica8-ansible-docker.git
   cd practica8-ansible-docker
   ```

2. **Levantar los 5 servidores Ubuntu:**
   ```bash
   docker compose up -d server1 server2 server3 server4 server5
   ```

3. **Verificar que los 5 servidores estén corriendo:**
   ```bash
   docker compose ps
   ```

4. **Ejecutar la automatización de Ansible:**
   ```bash
   docker compose run --rm ansible-controller
   ```

5. **Verificar el resultado dentro de cualquiera de los servidores:**
   ```bash
   # Probar en server1 (o cualquier otro del 1 al 5)
   docker exec -it ubuntu-server1 cat /app/hola.txt
   docker exec -it ubuntu-server1 id itla
   docker exec -it ubuntu-server1 /usr/games/cowsay "Ansible funcionó!"
   ```

6. **Detener y limpiar los contenedores:**
   ```bash
   docker compose down
   ```

---

## 📊 Evidencia de Ejecución Exitosa

### Resumen del Playbook de Ansible (`PLAY RECAP`):
```text
PLAY RECAP *********************************************************************
server1                    : ok=6    changed=4    unreachable=0    failed=0
server2                    : ok=6    changed=4    unreachable=0    failed=0
server3                    : ok=6    changed=4    unreachable=0    failed=0
server4                    : ok=6    changed=4    unreachable=0    failed=0
server5                    : ok=6    changed=4    unreachable=0    failed=0
```

### Verificación del archivo `/app/hola.txt` y `cowsay`:
```text
$ docker exec ubuntu-server1 cat /app/hola.txt
=============================================
¡Hola Mundo desde Ansible!
Servidor: server1
Estudiante: Sebastián Peguero
Matrícula: 2025-1172
Materia: Electiva II (DevOps) - Práctica 8
=============================================

$ docker exec ubuntu-server1 /usr/games/cowsay "Ansible exitoso!"
 __________________
< Ansible exitoso! >
 ------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
