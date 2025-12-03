#!/bin/bash
# ============================================
# Script para ejecutar pruebas JMeter en Linux/Mac
# ============================================

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TEST_PLANS_DIR="$PROJECT_DIR/test-plans"
RESULTS_DIR="$PROJECT_DIR/results"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar si JMETER_HOME está configurado
if [ -z "$JMETER_HOME" ]; then
    echo -e "${RED}[ERROR] La variable JMETER_HOME no está configurada.${NC}"
    echo "Por favor, configure JMETER_HOME con la ruta de instalación de JMeter."
    echo "Ejemplo: export JMETER_HOME=/opt/apache-jmeter-5.6.3"
    exit 1
fi

# Verificar si JMeter existe
if [ ! -f "$JMETER_HOME/bin/jmeter" ]; then
    echo -e "${RED}[ERROR] No se encontró jmeter en $JMETER_HOME/bin${NC}"
    exit 1
fi

# Crear directorio de resultados si no existe
mkdir -p "$RESULTS_DIR"

# Obtener el nombre del test plan (por defecto: basic-http-test.jmx)
TEST_PLAN="${1:-basic-http-test.jmx}"

# Verificar si el test plan existe
if [ ! -f "$TEST_PLANS_DIR/$TEST_PLAN" ]; then
    echo -e "${RED}[ERROR] No se encontró el test plan: $TEST_PLAN${NC}"
    echo "Test plans disponibles:"
    ls -1 "$TEST_PLANS_DIR"/*.jmx 2>/dev/null || echo "  (ninguno)"
    exit 1
fi

# Generar nombre único para resultados
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULT_FILE="$RESULTS_DIR/results_$TIMESTAMP.jtl"
REPORT_DIR="$RESULTS_DIR/report_$TIMESTAMP"

echo "============================================"
echo "JMeter Test Runner"
echo "============================================"
echo -e "Test Plan: ${YELLOW}$TEST_PLAN${NC}"
echo -e "Resultados: ${YELLOW}$RESULT_FILE${NC}"
echo -e "Reporte: ${YELLOW}$REPORT_DIR${NC}"
echo "============================================"

# Ejecutar JMeter en modo no-GUI
echo ""
echo "Ejecutando prueba..."
"$JMETER_HOME/bin/jmeter" -n -t "$TEST_PLANS_DIR/$TEST_PLAN" -l "$RESULT_FILE" -e -o "$REPORT_DIR"

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================"
    echo -e "${GREEN}Prueba completada exitosamente!${NC}"
    echo -e "Reporte HTML disponible en: ${YELLOW}$REPORT_DIR${NC}"
    echo "============================================"
else
    echo ""
    echo -e "${RED}[ERROR] La prueba falló${NC}"
    exit 1
fi
