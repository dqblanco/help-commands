# Comandos Linux

## Ruta de trabajo actual
```
pwd
```

## Listar contenido de un directorio
```
ls
```

## Cambiar de directorio
```
cd nombre-directorio
```

### Cambiar al directorio superior
```
cd ..
```

## Ver contenido de un archivo
```
cat nombre-archivo.log
```

## Descargar archivos a local con SCP

```
scp usuario@ip_server:/ruta-archivo/archivo.sql archivo.sql
```

## Copiar archivo desde local con SCP
```
scp archivo.sql  usuario@3.ip_server:/ruta-archivo/archivo.sql
```

## Vaciar archivo de linux
```
cat /dev/null > mail.log
```

## Saber Version de linux
```
uname -r
```

## Ver logs en tiempo real
```
tail -f /var/log/archivo.log
```

## Cambiar fecha de un archivo
```
touch -d 19710101 ../ruta-archivo/archivo.log
```

## Crear conexión ssh 

Editar el archivo  ~/.ssh/config agregando la información del hosts

```
host nombre-conexion
HostName ip-host
Port 22
User root
ServerAliveInterval 30
ServerAliveCountMax 120
IdentityFile <Ruta llave privada>
```


Ir al [inicio](../README.md)