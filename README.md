# JMeter Demo Repository

Este es un repositorio demo simple para aprender y practicar con Apache JMeter.

## 📋 Contenido

- `test-plans/` - Planes de prueba JMeter (.jmx)
- `scripts/` - Scripts auxiliares para ejecutar pruebas
- `results/` - Directorio para almacenar resultados de pruebas

## 🚀 Requisitos

- Java 8 o superior instalado
- Apache JMeter 5.x descargado
- Variable de entorno `JMETER_HOME` configurada (opcional)

## 📦 Instalación de JMeter

1. Descargar JMeter desde: https://jmeter.apache.org/download_jmeter.cgi
2. Extraer el archivo ZIP
3. Ejecutar `bin/jmeter.bat` (Windows) o `bin/jmeter.sh` (Linux/Mac)

## 🧪 Planes de Prueba Incluidos

### 1. Test Básico HTTP (`basic-http-test.jmx`)
- Prueba simple contra una API pública
- Incluye Thread Group, HTTP Request y Listeners básicos

### 2. Test con Variables (`variables-test.jmx`)
- Demuestra el uso de variables y User Defined Variables
- Parametrización de requests

## 🏃 Ejecución

### Modo GUI (para desarrollo)
```bash
jmeter -t test-plans/basic-http-test.jmx
```

### Modo CLI (para CI/CD)
```bash
jmeter -n -t test-plans/basic-http-test.jmx -l results/results.jtl -e -o results/report
```

### Parámetros comunes:
- `-n`: Modo no-GUI
- `-t`: Archivo de test plan
- `-l`: Archivo de log de resultados
- `-e`: Generar reporte al finalizar
- `-o`: Directorio de salida del reporte HTML

## 📊 Visualización de Resultados

Los resultados se pueden ver:
1. En tiempo real usando Listeners en modo GUI
2. En el reporte HTML generado en `results/report/`
3. Analizando el archivo `.jtl` con herramientas externas

## 📚 Recursos Útiles

- [Documentación Oficial](https://jmeter.apache.org/usermanual/index.html)
- [Best Practices](https://jmeter.apache.org/usermanual/best-practices.html)
- [JMeter Plugins](https://jmeter-plugins.org/)

## 📝 Licencia

Este proyecto es de uso educativo y demostrativo.
