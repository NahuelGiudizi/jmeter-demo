pipeline {
    agent any
    
    // Configuración de herramientas
    tools {
        jdk 'JDK11'  // Configurar en Jenkins: Manage Jenkins > Tools
    }
    
    environment {
        // Configurar JMETER_HOME en Jenkins o como variable de entorno
        JMETER_HOME = "${env.JMETER_HOME ?: '/opt/apache-jmeter'}"
        RESULTS_DIR = 'results'
        TIMESTAMP = "${new Date().format('yyyyMMdd_HHmmss')}"
    }
    
    parameters {
        choice(
            name: 'TEST_PLAN',
            choices: ['basic-http-test.jmx', 'variables-test.jmx'],
            description: 'Seleccionar el plan de prueba a ejecutar'
        )
        string(
            name: 'THREADS',
            defaultValue: '10',
            description: 'Número de usuarios virtuales (threads)'
        )
        string(
            name: 'RAMP_UP',
            defaultValue: '10',
            description: 'Tiempo de ramp-up en segundos'
        )
        string(
            name: 'LOOPS',
            defaultValue: '5',
            description: 'Número de iteraciones por thread'
        )
    }
    
    stages {
        stage('🔍 Verificar Entorno') {
            steps {
                script {
                    echo "============================================"
                    echo "JMeter Performance Test Pipeline"
                    echo "============================================"
                    echo "Test Plan: ${params.TEST_PLAN}"
                    echo "Threads: ${params.THREADS}"
                    echo "Ramp-up: ${params.RAMP_UP}s"
                    echo "Loops: ${params.LOOPS}"
                    echo "============================================"
                }
                
                // Verificar que JMeter está disponible
                sh '''
                    if [ ! -f "${JMETER_HOME}/bin/jmeter" ]; then
                        echo "ERROR: JMeter no encontrado en ${JMETER_HOME}"
                        echo "Por favor, configure JMETER_HOME correctamente"
                        exit 1
                    fi
                    echo "JMeter encontrado: ${JMETER_HOME}"
                    ${JMETER_HOME}/bin/jmeter --version
                '''
            }
        }
        
        stage('🧹 Limpiar Resultados Anteriores') {
            steps {
                sh '''
                    rm -rf ${RESULTS_DIR}/*.jtl
                    rm -rf ${RESULTS_DIR}/report_*
                    mkdir -p ${RESULTS_DIR}
                '''
            }
        }
        
        stage('🚀 Ejecutar Test JMeter') {
            steps {
                script {
                    def resultFile = "${RESULTS_DIR}/results_${TIMESTAMP}.jtl"
                    def reportDir = "${RESULTS_DIR}/report_${TIMESTAMP}"
                    
                    sh """
                        ${JMETER_HOME}/bin/jmeter -n \
                            -t test-plans/${params.TEST_PLAN} \
                            -l ${resultFile} \
                            -e -o ${reportDir} \
                            -Jthreads=${params.THREADS} \
                            -Jrampup=${params.RAMP_UP} \
                            -Jloops=${params.LOOPS} \
                            -Jjmeter.save.saveservice.output_format=csv
                    """
                    
                    // Guardar las rutas para stages posteriores
                    env.RESULT_FILE = resultFile
                    env.REPORT_DIR = reportDir
                }
            }
        }
        
        stage('📊 Publicar Resultados') {
            steps {
                // Publicar reporte HTML de JMeter
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: "${env.REPORT_DIR}",
                    reportFiles: 'index.html',
                    reportName: 'JMeter Performance Report',
                    reportTitles: 'JMeter Report'
                ])
                
                // Archivar resultados
                archiveArtifacts artifacts: "${RESULTS_DIR}/**/*", fingerprint: true
            }
        }
        
        stage('📈 Análisis de Performance') {
            steps {
                // Usar Performance Plugin si está instalado
                script {
                    try {
                        perfReport sourceDataFiles: "${env.RESULT_FILE}",
                                   errorFailedThreshold: 5,
                                   errorUnstableThreshold: 3,
                                   relativeFailedThresholdNegative: 20,
                                   relativeFailedThresholdPositive: 20,
                                   relativeUnstableThresholdNegative: 10,
                                   relativeUnstableThresholdPositive: 10
                    } catch (Exception e) {
                        echo "Performance Plugin no instalado. Saltando análisis detallado."
                        echo "Instalar: https://plugins.jenkins.io/performance/"
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo "============================================"
            echo "Pipeline completado"
            echo "Reporte disponible en: ${env.REPORT_DIR}"
            echo "============================================"
        }
        
        success {
            echo "✅ Todas las pruebas pasaron correctamente"
        }
        
        failure {
            echo "❌ Las pruebas fallaron. Revisar los logs."
        }
        
        unstable {
            echo "⚠️ Algunas pruebas tienen problemas de rendimiento"
        }
    }
}
