# Comandos Git

## Confiración Base 
```
  git config --global user.name 'Tu nombre'
  git config --global user.email tucorreo@midominio.com
```

## Iniciar un  repositorio
```
git init 
```
 
## Agrega un archivo a la lista de cambios
```
git add miarchivo.txt
```
### Agregar todos los archivos agregados o modificados
```
git add . 
```
## Hacer commit de los cambios
```
git commit 
```

### Hacer commit con un mensaje
```
git commit -m "Mi mensaje del commit"
```

## Modificar un commit
```
 git commit --amend
```

## Subir cambios al repositorio remoto
```
git push origin mi-rama
```

## Crear una nueva rama
Esto saca una rama partiendo de la rama donde nos encontramos actualmente
```
git checkout -b mi-rama
```

### Crear una nueva rama desde un repositorio remoto
```
git checkout -b mi-rama origin/mi-rama-remota
```

## Repositorios remoto
```
git remote -v
```

## Agregar repositorios remoto
```
git remote add origin UrlServidorRemoto
```

## Lista de ramas
```
git branch -v
``` 

## Eliminar una rama
```
git branch -d mi-rama
``` 

## Actualizar una rama
```
git pull origin mi-rama
``` 

## Mezclar una rama
```
git merge
``` 

## Lista de commit
```
git log
```

## Lista de etiquetas
```
git tag
```

## Crear una etiquetas
```
git tag -a 1.1.0 -m "descripción de la etiqueta"
```

## Excluir permisos de archivos
```
git config core.fileMode false
```

## Salvar cambios sin hacer commit
Este comando es uno de mis favoritos. Nos permite guardar nuestros cambios es una memoria temporal sin 
necesidad de hacer commit. Para conocer los subcomando de stash puedes usar  `git stash -h` 
```
git stash
```

## Una buena practica
Muchos proyectos no suelen implementar un procedimiento de creación de etiquetas antes del deploy. 

Tener etiquetas con las versiones estables de nuestro software, nos ahorra tiempo en caso que por error llegue algo incorrectos
a producción y tengamos que regresar a la versión antes de la subida. A continuación les dejo un procedimiento que puede ayudarlos en esta tarea.

1. Cambiar a la rama master: `git checkout master`
2. Hacer pull de master: `git pull origin master`
3. Cambiar a la rama donde está el código: `git checkout mi-rama`
4. Hacer merge con master: `git merge master`
5. Hacer push de  mi rama de trabajo: `git push origin mi_rama`
6. Cambiar a la rama master: `git checkout master`
7. Hacer merge con mi_rama: `git merge mi-rama`
8. Actualizar ramas y tag remotos: `git fetch -pv`
9. Ver último tag creado: `git describe --abbrev=0 --tags `
10. Editar el archivo Manifest y aumentar la versión: 01.02.0x. `vim MANIFEST`
11. Agregar Manifest: `git add .`
12. Hacer Commit del Manifest: `git commit` 
13. En el commit se pone Release 01.02.0x. y abajo un comentario
14. Se suben los cambios en master: `push git push origin master`
15. Se revisa el log para copiar la descripción: `git log --name-status`
16. Se crea la etiqueta: `git tag -a 01.02.0x`
17. Se sube la etiqueta al repositorio remoto: `git push origin 01.02.0x`
 

Ir al [inicio](../README.md)
