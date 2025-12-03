# Configuración de Jenkins para JMeter

## 📋 Requisitos Previos

1. Jenkins instalado y funcionando
2. Apache JMeter instalado en el servidor Jenkins
3. Java 8+ instalado

## 🔌 Plugins Necesarios

Instalar los siguientes plugins desde **Manage Jenkins > Plugins**:

| Plugin | Descripción |
|--------|-------------|
| [Pipeline](https://plugins.jenkins.io/workflow-aggregator/) | Soporte para Jenkinsfile |
| [HTML Publisher](https://plugins.jenkins.io/htmlpublisher/) | Publicar reportes HTML |
| [Performance](https://plugins.jenkins.io/performance/) | Análisis de resultados JMeter |
| [Git](https://plugins.jenkins.io/git/) | Integración con Git |

## ⚙️ Configuración Inicial

### 1. Configurar JMeter en Jenkins

**Opción A: Variable de Entorno Global**
1. Ir a **Manage Jenkins > System**
2. En **Global properties**, marcar **Environment variables**
3. Agregar:
   - Nombre: `JMETER_HOME`
   - Valor: `/opt/apache-jmeter-5.6.3` (ajustar según tu instalación)

**Opción B: En el Jenkinsfile**
```groovy
environment {
    JMETER_HOME = '/opt/apache-jmeter-5.6.3'
}
```

### 2. Configurar JDK

1. Ir a **Manage Jenkins > Tools**
2. En **JDK installations**, agregar:
   - Name: `JDK11`
   - JAVA_HOME: `/usr/lib/jvm/java-11-openjdk` (ajustar según tu instalación)

### 3. Crear el Pipeline Job

1. Ir a **New Item**
2. Nombre: `jmeter-performance-tests`
3. Tipo: **Pipeline**
4. En **Pipeline**, configurar:
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `https://github.com/NahuelGiudizi/jmeter-demo.git`
   - Branch: `*/master`
   - Script Path: `Jenkinsfile`
5. Guardar

## 🚀 Ejecutar el Pipeline

1. Ir al job `jmeter-performance-tests`
2. Click en **Build with Parameters**
3. Seleccionar:
   - **TEST_PLAN**: El plan de prueba a ejecutar
   - **THREADS**: Número de usuarios virtuales
   - **RAMP_UP**: Tiempo de ramp-up
   - **LOOPS**: Iteraciones por usuario
4. Click en **Build**

## 📊 Ver Resultados

Después de la ejecución:

1. **JMeter Performance Report**: Link en la página del build
2. **Console Output**: Logs detallados de ejecución
3. **Artifacts**: Archivos JTL y reportes descargables
4. **Performance Trend**: Gráficos de tendencia (si el plugin está instalado)

## 🔄 Integración con GitHub (Webhook)

Para ejecutar automáticamente en cada push:

1. En el job Jenkins, ir a **Configure**
2. En **Build Triggers**, marcar:
   - ☑️ GitHub hook trigger for GITScm polling
3. En GitHub:
   - Ir a **Settings > Webhooks > Add webhook**
   - Payload URL: `http://TU_JENKINS_URL/github-webhook/`
   - Content type: `application/json`
   - Events: `Just the push event`

## 🐳 Ejecución con Docker (Alternativa)

Si prefieres usar Docker en lugar de instalar JMeter:

```groovy
agent {
    docker {
        image 'justb4/jmeter:5.6.3'
        args '-v $PWD:/workspace -w /workspace'
    }
}
```

## 📝 Notas Adicionales

- Los reportes HTML se guardan por cada build
- El Performance Plugin genera gráficos de tendencia entre builds
- Los umbrales de error se pueden ajustar en el Jenkinsfile
- Para pruebas distribuidas, ver: [JMeter Distributed Testing](https://jmeter.apache.org/usermanual/jmeter_distributed_testing_step_by_step.html)
